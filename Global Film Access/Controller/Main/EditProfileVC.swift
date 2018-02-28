//
//  EditProfileVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 2/11/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var userDetails = [UserType]()
    
    //MARK: Outlets
    @IBOutlet weak var profileImage: CircleImage!
    @IBOutlet weak var firstNameLbl: CommonTextField!
    @IBOutlet weak var lastNameLbl: CommonTextField!
    @IBOutlet weak var cityLbl: CommonTextField!
    @IBOutlet weak var stateLbl: CommonTextField!
    @IBOutlet weak var zipCodeLbl: CommonTextField!
    @IBOutlet weak var agentNameLbl: CommonTextField!
    @IBOutlet weak var agentNumberLbl: CommonTextField!
    @IBOutlet weak var managerNameLbl: CommonTextField!
    @IBOutlet weak var managerNumberLbl: CommonTextField!
    @IBOutlet weak var legalNameLbl: CommonTextField!
    @IBOutlet weak var legalNumberLbl: CommonTextField!
    @IBOutlet weak var videoNameLbl: CommonTextField!
    @IBOutlet weak var videoURLLbl: CommonTextField!
    @IBOutlet weak var movieNameLbl: CommonTextField!
    @IBOutlet weak var movieYearLbl: CommonTextField!
    
    var imagePicker: UIImagePickerController!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        getStatePickers(stateLbl)
        
        
        
        //creating the imagePicker
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImage.image = image
            profileImage.contentMode = .scaleToFill
            if let userProfileImage = userDetails[0].profileImage {
                let storage = FIRStorage.storage()
                let storageRef = storage.reference(forURL: userProfileImage)
                
                storageRef.delete { error in
                    if let error = error {
                        print(error)
                    } else {
                        // File deleted successfully
                    }
                }
            }
            //imageChanged = true
        } else {
            print("ZACK: A valid image wasn't selected.")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    //MARK: Get User Details
    ///Get user details from Firebase
    func getUserDetails() {
        UserType.REF_CURRENT_USER_DETAILS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.userDetails.removeAll()
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    //If the id matches the id from projects then it will be added to userProjectsDetails Array
                    if let userDetailsDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let userDetails = UserType(userKey: key, userData: userDetailsDict)
                        self.userDetails.append(userDetails)
                        self.fillInUserDetail(currentUser: self.userDetails)
                        self.getImageFromFirebase()
                    }
                }
            }
        })
    }
    

    func fillInUserDetail(currentUser: [UserType]) {
        self.firstNameLbl.text = currentUser[0].firstName
        self.lastNameLbl.text = currentUser[0].lastName
        self.cityLbl.text = currentUser[0].city
        self.stateLbl.text = currentUser[0].state
        self.zipCodeLbl.text = currentUser[0].zipCode
        
        if let agentName = currentUser[0].agentName,
            let agentNumber = currentUser[0].agentNumber,
            let managerName = currentUser[0].managerName,
            let managerNumber = currentUser[0].managerNumber,
            let legalName = currentUser[0].legalName,
            let legalNumber = currentUser[0].legalNumber {
            
            self.agentNameLbl.text = agentName
            self.agentNumberLbl.text = agentNumber
            self.managerNameLbl.text = managerName
            self.managerNumberLbl.text = managerNumber
            self.legalNameLbl.text = legalName
            self.legalNumberLbl.text = legalNumber
        }
    }

    //Save Updates
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let firstName = firstNameLbl.text,
            let lastName = lastNameLbl.text,
            let city = cityLbl.text,
            let state = stateLbl.text,
            let zipCode = zipCodeLbl.text,
            let agentName = agentNameLbl.text,
            let agentNumber = agentNumberLbl.text,
            let managerName = managerNameLbl.text,
            let managerNumber = managerNumberLbl.text,
            let legalName = legalNameLbl.text,
            let legalNumber = legalNumberLbl.text,
            let userImage = profileImage.image {
            
            let user = UserType(firstName: firstName, lastName: lastName, city: city, state: state, zipCode: zipCode)
            
            do {
                try user.updateProfileInfo(user: user, userImage: userImage, userAgentName: agentName, userAgentNumber: agentNumber, userManagerName: managerName, userManagerNumber: managerNumber, userLegalName: legalName, userLegalNumber: legalNumber)
                self.dismiss(animated: true, completion: nil)
            } catch CreateUserError.invalidFirstName {
                showAlert(message: CreateUserError.invalidFirstName.rawValue)
            } catch CreateUserError.invalidLastName {
                showAlert(message: CreateUserError.invalidLastName.rawValue)
            } catch CreateUserError.invalidCity {
                showAlert(message: CreateUserError.invalidCity.rawValue)
            } catch CreateUserError.invalidState {
                showAlert(message: CreateUserError.invalidState.rawValue)
            } catch CreateUserError.invalidZipCode {
                showAlert(message: CreateUserError.invalidZipCode.rawValue)
            } catch let error {
                showAlert(message: "\(error)")
            }
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "" , message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { action in
            return
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Add Video Button Tapped
    
    //Validate that a correct url was entered
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    @IBAction func addVideoTapped(_ sender: Any) {
        if let videoName = videoNameLbl.text, let videoURL = videoURLLbl.text {
            guard videoName != "" else {
                showAlert(message: "Please provide a valid video name.")
                return
            }
            guard self.verifyUrl(urlString: videoURL) else {
                showAlert(message: "Please provide a valid vimeo URL to your video." )
                return
            }
            let newVideo: Dictionary<String, String> = [
                FIRUserData.videoName.rawValue: videoName,
                FIRUserData.videoURL.rawValue: videoURL
            ]
            UserType.REF_CURRENT_USER_VIDEOS.child(userID).childByAutoId().setValue(newVideo)
            videoNameLbl.text = nil
            videoURLLbl.text = nil
        }
    }
    
    //MARK: Add movies
    
    @IBAction func addMovieTapped(_ sender: Any) {
        if let movieName = movieNameLbl.text, let movieYear = movieYearLbl.text {
            guard movieName != "" else {
                showAlert(message: "Please provide a valid movie name.")
                return
            }
            guard movieYear != "" else {
                showAlert(message: "Please provide the year you did this movie.")
                return
            }
            let newMovie: Dictionary<String, String> = [
                FIRUserData.movieName.rawValue: movieName,
                FIRUserData.movieYear.rawValue: movieYear
            ]
            
            UserType.REF_CURRENT_USER_MOVIES.child(userID).childByAutoId().setValue(newMovie)
            movieNameLbl.text = nil
            movieYearLbl.text = nil
        }
    }
    
    //MARK: Get image from Firebase
    func getImageFromFirebase(img: UIImage? = nil) {
        if img != nil {
            self.profileImage.image = img
        } else {
            if let imageURL = self.userDetails[0].profileImage {
                let ref = FIRStorage.storage().reference(forURL: imageURL)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion:  { (data, error) in
                    if error != nil {
                        print("ZACK: Unable to download image from Firebase")
                        self.profileImage.image = #imageLiteral(resourceName: "ProfileImage")
                    } else {
                        print("ZACK: Successfully downloaded image.")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.profileImage.image = img
                            }
                        }
                    }
                })
            }
        }
        
    }
    
    
    
    //MARK: States List
    let usaStates: [USAState] = [.alabama, .alaska, .arizone, .arkansas, .california, .colorado, .connecticut, .delaware, .florida, .georgia, .hawaii, .idaho, .illinois, .indiana, .iowa, .kansas, .kentucky, .louisiana, .maine, .maryland, .massachusetts, .michigan, .minnesota, .mississippi, .missouri, .montana, .nebraska, .nevada, .newHampshire, .newJersey, .newMexico, .newYork, .northCarolina, .northDakota, .ohio, .oklahoma, .oregon, .pennsylvania, .rhodeIsland, .southCarolina, .southDakota, .tennessee, .texas, .utah, .vermont, .virginia, .washington, .westVirginia, .wisconsin, .wyoming]
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return usaStates.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return usaStates[row].rawValue as String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.stateLbl.text = usaStates[row].rawValue
    }
    //MARK:- TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.getStatePickers(stateLbl)
    }
    
    //MARK: UIViewPicker for State
    func getStatePickers(_ textField : UITextField){
        let statePickerView = UIPickerView()
        statePickerView.delegate = self
        textField.inputView = statePickerView
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        
        let cancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(CreateProfileVC.cancelPressed(sender:)))
        
        let done = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(CreateProfileVC.donePressed(sender:)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/3, height: 40))
        
        label.font = UIFont.systemFont(ofSize: 14)
        
        label.textColor = UIColor.white
        
        label.text = "Pick a State"
        
        label.textAlignment = NSTextAlignment.center
        
        let textButton = UIBarButtonItem(customView: label)
        
        toolBar.setItems([cancel, flexSpace, textButton, flexSpace, done], animated: true)
        
        stateLbl.inputAccessoryView = toolBar
    }
    //MARK:- Button
    @objc func donePressed(sender: UIBarButtonItem) {
        stateLbl.resignFirstResponder()
    }
    
    @objc func cancelPressed(sender: UIBarButtonItem) {
        stateLbl.resignFirstResponder()
    }

    
    

}
