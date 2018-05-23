//
//  EditProfileVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 2/11/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {
    
    var userDetails = [UserType]()
    var videoDetail = [UserVideos]()
    var movieDetail = [UserMovies]()
    //Variable for parsing XML
    var currentParsingElement = ""
    var imageURL = ""
    var imageChanged = false
    
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
    @IBOutlet weak var videoTableView: UITableView!
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var imdbRating: CommonTextField!
    @IBOutlet weak var heightFeet: CommonTextField!
    @IBOutlet weak var heightInches: CommonTextField!
    @IBOutlet weak var weight: CommonTextField!
    @IBOutlet weak var bodyType: CommonTextField!
    @IBOutlet weak var eyeColor: CommonTextField!
    @IBOutlet weak var hairColor: CommonTextField!
    @IBOutlet weak var hairLength: CommonTextField!
    @IBOutlet weak var hairType: CommonTextField!
    @IBOutlet weak var ethnicity: CommonTextField!
    @IBOutlet weak var ageLbl: CommonTextField!
    
    //Variable to convert labels in convertText function
    var heightFeetInt: Int = 0
    var heightInchesInt: Int = 0
    var ageInt: Int = 0
    var weightInt: Int = 0
    var bodyTypeEnum = ""
    var eyeColorEnum = ""
    var hairColorEnum = ""
    var hairLengthEnum = ""
    var hairTypeEnum = ""
    var ethnicityEnum = ""
    
    
    //MARK: Constraints
    @IBOutlet weak var movieTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var videoTableViewHeight: NSLayoutConstraint!
    var imagePicker: UIImagePickerController!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        //getStatePickers(stateLbl)
        getUserVideos()
        getUserMovies()
        loadPickerViews()
        hideKeyboard()
        
        //creating the imagePicker
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImage.image = image
            profileImage.contentMode = .scaleToFill

            imageChanged = true
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
        UserType.REF_CURRENT_USER_DETAILS_INFO.observe(.value, with: { (snapshot) in
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
        
        var feet = 0
        var inches = 0
        var userAge = 0
        var userWeight = 0

        if let height = currentUser[0].height {
            if let heightInt = Int(height) {
                feet = heightInt/12
                inches = heightInt - ((heightInt/12) * 12)
            }
        }
        
        if let age = currentUser[0].age {
            if let ageInt = Int(age) {
                userAge = ageInt
            }
        }
        
        if let weight = currentUser[0].weight {
            if let weightInt = Int(weight) {
                userWeight = weightInt
            }
        }
        
        self.heightFeet.text = "\(feet)"
        self.heightInches.text = "\(inches)"
        self.ageLbl.text = "\(userAge)"
        self.weight.text = "\(userWeight)"
        
        
        
        if let agentName = currentUser[0].agentName {
            self.agentNameLbl.text = agentName
        } else {
            self.agentNameLbl.text = ""
        }
        
        if let agentNumber = currentUser[0].agentNumber {
            self.agentNumberLbl.text = agentNumber
        } else {
            self.agentNumberLbl.text = ""
        }
        
        if let managerName = currentUser[0].managerName {
            self.managerNameLbl.text = managerName
        } else {
            self.managerNameLbl.text = ""
        }
        
        if let managerNumber = currentUser[0].managerNumber {
            self.managerNumberLbl.text = managerNumber
        } else {
            self.managerNumberLbl.text = ""
        }
        
        if let legalName = currentUser[0].legalName{
            self.legalNameLbl.text = legalName
        } else {
            self.legalNameLbl.text = ""
        }
        
        if let legalNumber = currentUser[0].legalNumber {
            self.legalNumberLbl.text = legalNumber
        } else {
            self.legalNumberLbl.text = ""
        }
        
        if let ethnicity = currentUser[0].ethnicity {
            self.ethnicity.text = ethnicity.rawValue
        } else {
            self.ethnicity.text = ""
        }
        
        if let bodyType = currentUser[0].bodyType {
            self.bodyType.text = bodyType.rawValue
        } else {
            self.bodyType.text = ""
        }
        
        if let eyeColor = currentUser[0].eyeColor {
            self.eyeColor.text = eyeColor.rawValue
        } else {
            self.eyeColor.text = ""
        }
        
        if let hairColor = currentUser[0].hairColor {
            self.hairColor.text = hairColor.rawValue
        } else {
            self.hairColor.text = ""
        }
        
        if let hairLength = currentUser[0].hairLength {
            self.hairLength.text = hairLength.rawValue
        } else {
            self.hairLength.text = ""
        }
        
        if let hairType = currentUser[0].hairType {
            self.hairType.text = hairType.rawValue
        } else {
            self.hairType.text = ""
        }
        
            


    }
    
    
    // MARK: Table View Controllers
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 1
        
        if tableView == self.videoTableView {
            count = self.videoDetail.count
        } else if tableView == self.movieTableView {
            count = self.movieDetail.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifierVideo = "videoCell"
        let cellIdentifierMovie = "movieCell"
        var cell: UITableViewCell?
        
        if tableView == self.videoTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierVideo, for: indexPath)
            
            cell?.textLabel?.text = videoDetail[indexPath.row].videoName
        } else if tableView == self.movieTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierMovie, for: indexPath)
            
            cell?.textLabel?.text = movieDetail[indexPath.row].movieName
            cell?.detailTextLabel?.text = movieDetail[indexPath.row].movieYear
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            
            if tableView == self.videoTableView {
                
                self.delete(tableView: self.videoTableView, indexPath: indexPath)
                
            } else if tableView == self.movieTableView {
                
                self.delete(tableView: self.movieTableView, indexPath: indexPath)
                
            }
        }
        delete.backgroundColor = UIColor.red
        return [delete]
    }
    
    // MARK: delete movie or video
    func delete(tableView: UITableView, indexPath: IndexPath) {
        switch tableView {
        case self.videoTableView:
            let video = videoDetail[indexPath.row].videoKey
            UserVideos.REF_CURRENT_USER_VIDEOS.child(userID).child(video).removeValue()
        case self.movieTableView:
            let movie = movieDetail[indexPath.row].movieKey
            UserMovies.REF_CURRENT_USER_MOVIES.child(userID).child(movie).removeValue()
        default:
            print("Table View doesn't exist.")
        }
    }
    
    //Get video details
    func getUserVideos() {
        UserVideos.REF_CURRENT_USER_VIDEOS.child(userID).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
            self.videoDetail.removeAll()
                for snap in snapshot {
                    print("SNAP:\(snap)")
                    
                    if let videoDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let video = UserVideos(videoKey: key, videoData: videoDict)
                        self.videoDetail.append(video)
                    }
                }
                
            }
            self.videoTableView.reloadData()
            self.viewDidLayoutSubviews()
        })
        
    }
    //Get Movie Details
    func getUserMovies() {
        UserMovies.REF_CURRENT_USER_MOVIES.child(userID).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.movieDetail.removeAll()
                for snap in snapshot {
                    print("SNAP:\(snap)")
                    
                    if let movieDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let movie = UserMovies(movieKey: key, movieData: movieDict)
                        self.movieDetail.append(movie)
                    }
                }
                
            }
            self.movieTableView.reloadData()
            self.viewDidLayoutSubviews()
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let videotvHeight = CGFloat(self.videoDetail.count) * CGFloat(75)
        let movietvHeight = CGFloat(self.movieDetail.count) * CGFloat(75)
        self.videoTableViewHeight.constant = videotvHeight
        self.movieTableViewHeight.constant = movietvHeight
        
        self.view.layoutIfNeeded()
    }
    
    

    //Save Updates
    @IBAction func saveButtonTapped(_ sender: Any) {
        self.convertText()
        
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
            let imdbRating = imdbRating.text,
            let userImage = profileImage.image {
            
            let user = UserType(firstName: firstName, lastName: lastName, city: city, state: state, zipCode: zipCode)
            
            do {
                print("send to DB height: \(self.heightFeetInt)")
                try user.updateProfileInfo(user: user, userImage: userImage, heightFeet: heightFeetInt, heightInches: heightInchesInt, age: ageInt, weight: weightInt, bodyType: bodyTypeEnum, eyeColor: eyeColorEnum, hairColor: hairColorEnum, hairLength: hairLengthEnum, hairType: hairTypeEnum, ethnicity: ethnicityEnum, userAgentName: agentName, userAgentNumber: agentNumber, userManagerName: managerName, userManagerNumber: managerNumber, userLegalName: legalName, userLegalNumber: legalNumber, userImdbRating: imdbRating, imageChanged: imageChanged)
                
                if imageChanged {
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
                }
                
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
    
    //MARK: Convert Text
    func convertText() {
        print("conversion started...")
        //Convert Feet
        if let heightFeetInput = self.heightFeet.text {
            if let heightFeet = Int(heightFeetInput) {
                self.heightFeetInt = heightFeet
                print("Feet: \(self.heightFeetInt)")
            } else {
                print("Not a number")
            }
        } else {
            print("Nothing entered")
        }
        //Convert Inches
        if let heightInchesInput = self.heightInches.text {
            if let heightInches = Int(heightInchesInput) {
                self.heightInchesInt = heightInches
                print("Inches: \(self.heightInchesInt)")
            } else {
                print("Not a number")
            }
        } else {
            print("Nothing entered")
        }
        
        //Convert Age
        if let ageInput = self.ageLbl.text {
            if let age = Int(ageInput) {
                self.ageInt = age
            } else {
                print("Not a number")
            }
        }
        //Convert Weight
        if let weightInput = self.weight.text {
            if let weight = Int(weightInput) {
                self.weightInt = weight
            } else {
                print("Not a number")
            }
        } else {
            print("Nothing entered")
        }
        //Convert BodyType
        if let bodyTypeInput = self.bodyType.text {
            if let bodyType = BodyType(rawValue: bodyTypeInput) {
                self.bodyTypeEnum = bodyType.rawValue
            } else {
                print("Not a body type")
            }
        } else {
            print("Nothing entered")
        }
        //Convert EyeColor
        if let eyeColorInput = self.eyeColor.text {
            if let eyeColor = EyeColor(rawValue: eyeColorInput) {
                self.eyeColorEnum = eyeColor.rawValue
            } else {
                print("Not a eye color")
            }
        } else {
            print("Nothing entered")
        }
        //Convert HairColor
        if let hairColorInput = self.hairColor.text {
            if let hairColor = HairColor(rawValue: hairColorInput) {
                self.hairColorEnum = hairColor.rawValue
            } else {
                print("Not a hair color")
            }
        } else {
            print("Nothing entered")
        }
        //Convert HairLength
        if let hairLengthInput = self.hairLength.text {
            if let hairLength = HairLength(rawValue: hairLengthInput) {
                self.hairLengthEnum = hairLength.rawValue
            } else {
                print("Not a hair length")
            }
        } else {
            print("Nothing entered")
        }
        //Convert HairType
        if let hairTypeInput = self.hairType.text {
            if let hairType = HairType(rawValue: hairTypeInput) {
                self.hairTypeEnum = hairType.rawValue
            } else {
                print("Not a hair type")
            }
        } else {
            print("Nothing entered")
        }
        //Convert Ethnicity
        if let ethnicityInput = self.ethnicity.text {
            if let ethnicity = Ethnicity(rawValue: ethnicityInput) {
                self.ethnicityEnum = ethnicity.rawValue
            } else {
                print("Not a ethnicity")
            }
        } else {
            print("Nothing entered")
        }
        print("conversion ended...")
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
    
    @IBAction func addVideoTapped(_ sender: Any) {

        if let videoID = videoURLLbl.text {
            if videoID == "" {
                showAlert(message: CreateVideoError.invalidVideoID.rawValue)
            } else {
                getXMLDataFromServer(videoID: videoID)
            }
        }
        
    }
    //MARK: Get XML Data From Server
    func getXMLDataFromServer(videoID: String) {
        let url = NSURL(string:"http://vimeo.com/api/v2/video/\(videoID).xml")
        print("RAN")
        
        //Creating data task
        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
            if data == nil {
                print("dataTaskWithRequest error: \(String(describing: error?.localizedDescription))")
                return
            }
            
            let parser = XMLParser(data: data!)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
        
    }
    
    // XML Parse Delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentParsingElement = elementName
        
        if elementName == "videos" {
            print("Started parsing...")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let foundedChar = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if (!foundedChar.isEmpty) {
            if currentParsingElement == "thumbnail_medium" {
                imageURL += foundedChar
                print(imageURL)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "videos" {
            print("Ended parsing...")
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("Ended Document...")
        print("printing Image URL: \(imageURL)")
        
        self.postVideo()
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccured: \(parseError)")
    }

    func postVideo() {
        DispatchQueue.main.async {
            if let videoName = self.videoNameLbl.text, let videoID = self.videoURLLbl.text {
                
                let newVideo = UserVideos(videoName: videoName, videoID: videoID, videoImageURL: self.imageURL)
                
                do {
                    try newVideo.createNewVideo(video: newVideo)
                    self.videoNameLbl.text = nil
                    self.videoURLLbl.text = nil
                } catch CreateVideoError.invalidVideoName {
                    self.showAlert(message: CreateVideoError.invalidVideoName.rawValue)
                } catch CreateVideoError.invalidVideoID {
                    self.showAlert(message: CreateVideoError.invalidVideoID.rawValue)
                } catch CreateVideoError.invalidVideoImageURL {
                    self.showAlert(message: CreateVideoError.invalidVideoImageURL.rawValue)
                } catch let error {
                    self.showAlert(message: "\(error)")
                }
            }
        }

    }
    
    
    //MARK: Add movies
    
    @IBAction func addMovieTapped(_ sender: Any) {
        if let movieName = movieNameLbl.text, let movieYear = movieYearLbl.text {
            
            let newMovie = UserMovies(movieName: movieName, movieYear: movieYear)
            
            do {
                try newMovie.createNewMovie(movie: newMovie)
                movieNameLbl.text = nil
                movieYearLbl.text = nil
            } catch CreateMovieError.invalidMovieName {
                showAlert(message: CreateMovieError.invalidMovieName.rawValue)
            } catch CreateMovieError.invalidMovieYear {
                showAlert(message: CreateMovieError.invalidMovieYear.rawValue)
            } catch let error {
                print("\(error)")
            }
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
    
    //MARK: Body types
    var bodyTypes: [BodyType] = [.thin, .athletic, .overweight, .obese]
    
    //MARK: Eye Color
    var eyeColors: [EyeColor] = [.amber, .blue, .brown, .gray, .green, .hazel]
    
    //MARK: Hair Color
    var hairColors: [HairColor] = [.black, .blonde, .brown, .other]
    
    //MARK: Hair Length
    var hairLengths: [HairLength] = [.short, .medium, .long]
    
    //MARK: Hair Type
    var hairTypes: [HairType] = [.straight, .wavy, .curly]
    
    //MARK: Ethnicity
    var ethnicities: [Ethnicity] = [.americanIndianAlaskanNative, .asian, .blackAfricanAmerican, .hispanicLatino, .nativeHawaiianPacificIslander, .white]
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return usaStates.count
        case 2:
            return bodyTypes.count
        case 3:
            return eyeColors.count
        case 4:
            return hairColors.count
        case 5:
            return hairLengths.count
        case 6:
            return hairTypes.count
        case 7:
            return ethnicities.count
        default:
            return 1
            
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return usaStates[row].rawValue as String
        case 2:
            return bodyTypes[row].rawValue as String
        case 3:
            return eyeColors[row].rawValue as String
        case 4:
            return hairColors[row].rawValue as String
        case 5:
            return hairLengths[row].rawValue as String
        case 6:
            return hairTypes[row].rawValue as String
        case 7:
            return ethnicities[row].rawValue as String
        default:
            return "Not Available"
        
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1 {
            stateLbl.text = usaStates[row].rawValue
        } else if pickerView.tag == 2 {
            bodyType.text = bodyTypes[row].rawValue
        } else if pickerView.tag == 3 {
            eyeColor.text = eyeColors[row].rawValue
        } else if pickerView.tag == 4 {
            hairColor.text = hairColors[row].rawValue
        } else if pickerView.tag == 5 {
            hairLength.text = hairLengths[row].rawValue
        } else if pickerView.tag == 6 {
            hairType.text = hairTypes[row].rawValue
        } else if pickerView.tag == 7 {
            ethnicity.text = ethnicities[row].rawValue
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    //MARK: Picker Views
    ///Load picker views
    func loadPickerViews() {
        //State
        let statePickerView = UIPickerView()
        statePickerView.delegate = self
        statePickerView.tag = 1
        stateLbl.inputView = statePickerView
        
        //Body type
        let bodyTypePickerView = UIPickerView()
        bodyTypePickerView.delegate = self
        bodyTypePickerView.tag = 2
        bodyType.inputView = bodyTypePickerView
        
        //Eye Color
        let eyeCOlorPickerView = UIPickerView()
        eyeCOlorPickerView.delegate = self
        eyeCOlorPickerView.tag = 3
        eyeColor.inputView = eyeCOlorPickerView
        
        //Hair Color
        let hairColorPickerView = UIPickerView()
        hairColorPickerView.delegate = self
        hairColorPickerView.tag = 4
        hairColor.inputView = hairColorPickerView
        
        //Hair Length
        let hairLengthPickerView = UIPickerView()
        hairLengthPickerView.delegate = self
        hairLengthPickerView.tag = 5
        hairLength.inputView = hairLengthPickerView
        
        //Hair Type
        let hairTypePickerView = UIPickerView()
        hairTypePickerView.delegate = self
        hairTypePickerView.tag = 6
        hairType.inputView = hairTypePickerView
        
        //Ethnicity
        let ethnicityPickerView = UIPickerView()
        ethnicityPickerView.delegate = self
        ethnicityPickerView.tag = 7
        ethnicity.inputView = ethnicityPickerView
    }
    



}
