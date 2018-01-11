//
//  CreateProfileVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 1/7/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit

class CreateProfileVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var pickState: UITextField!
    @IBOutlet weak var firstNameTextLbl: UITextField!
    @IBOutlet weak var lastNameTextLbl: UITextField!
    @IBOutlet weak var cityTextLbl: UITextField!
    @IBOutlet weak var zipCodeTextLbl: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStatePickers(pickState)
        firstNameTextLbl.setBottomBorder()
        lastNameTextLbl.setBottomBorder()
        cityTextLbl.setBottomBorder()
        pickState.setBottomBorder()
        zipCodeTextLbl.setBottomBorder()
        
        //creating the imagepicker
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImage.image = image
            profileImage.contentMode = .scaleToFill
            imageSelected = true
        } else {
            print("ZACK: A valid image wasn't selected.")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func createProfileTapped(_ sender: Any) {
        if let firstName = firstNameTextLbl.text, let lastName = lastNameTextLbl.text, let city = cityTextLbl.text, let state = pickState.text, let zipCode = zipCodeTextLbl.text, let image = profileImage.image {
            
            let user = UserType(firstName: firstName, lastName: lastName, city: city, state: state, profileImage: image, zipCode: zipCode)
            do {
                try user.createUserDB(user: user)
                performSegue(withIdentifier: "goToProjects", sender: self)
                firstNameTextLbl.text = nil
                lastNameTextLbl.text = nil
                cityTextLbl.text = nil
                pickState.text = nil
                zipCodeTextLbl.text = nil
                profileImage.image = UIImage(named: "ProfileImage")
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
                print(error)
            }
            
        } else {
            showAlert(message: "Unable to Create User")
        }
        
        
    }
    
    //Alert message for error handling
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "" , message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { action in
            return
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    //States List
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
        self.pickState.text = usaStates[row].rawValue
    }
    //MARK:- TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.getStatePickers(pickState)
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
        
        pickState.inputAccessoryView = toolBar
    }
    //MARK:- Button
    @objc func donePressed(sender: UIBarButtonItem) {
        pickState.resignFirstResponder()
    }
    
    @objc func cancelPressed(sender: UIBarButtonItem) {
        pickState.resignFirstResponder()
    }

    

}
