//
//  EditProjectVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 3/26/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class EditProjectVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    
    
    //MARK: Outlets
    @IBOutlet weak var projectImage: CircleImage!
    @IBOutlet weak var projectNameLbl: CommonTextField!
    @IBOutlet weak var releaseDateLbl: CommonTextField!
    @IBOutlet weak var projectAccessCodeLbl: CommonTextField!
    @IBOutlet weak var auditionsTV: UITableView!
    
    
    var editingProject = [ProjectType]()
    var auditionsDetail = [Auditions]()
    var projectID = ""
    var datePicker = UIDatePicker()
    var imagePicker: UIImagePickerController!
    var imageChanged = false
    //This variable holds the original project name to tell
    //if they changed the name. if they did change name we will test for duplicate.
    var currentProjectName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProjectDetails()
        getAuditionDetails()
        createDatePicker()
        //Creating Image Picker
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        print("Project ID: \(projectID)")
    }
    
    //MARK: Auditions Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(auditionsDetail.count)
        return self.auditionsDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let audition = auditionsDetail[indexPath.row]
        let cellIdentifier = "auditionsCell"
        
        // Configure the cell...
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EditProjectCell {
            cell.configureAuditionCell(audition: audition)
            
            return cell
        } else {
            return EditProjectCell()
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            projectImage.image = image
            projectImage.contentMode = .scaleAspectFill
            imageChanged = true
        } else {
            print("ZACK: A valid image wasn't selected.")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func editImage(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
       if let projectName = projectNameLbl.text,
            let releaseDate = releaseDateLbl.text,
            let accessCode = projectAccessCodeLbl.text,
            let projectImage = projectImage.image {
        
            let project = ProjectType(projectName: projectName, projectReleaseDate: releaseDate, projectAccessCode: accessCode)
        
        do {
            try project.updateProject(project: project, image: projectImage, projectID: self.projectID, currentProjectName: currentProjectName, imageChanged: imageChanged)
            
            if imageChanged {
                if let projectImage = editingProject[0].projectImage {
                    let storage = FIRStorage.storage()
                    let storageRef = storage.reference(forURL: projectImage)
                    
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
            
        } catch CreateProjectError.duplicateName {
            showAlert(message: CreateProjectError.duplicateName.rawValue)
        } catch CreateProjectError.inValidProjectName {
            showAlert(message: CreateProjectError.inValidProjectName.rawValue)
        } catch CreateProjectError.invalidProjectDate {
            showAlert(message: CreateProjectError.invalidProjectDate.rawValue)
        } catch CreateProjectError.invalidAccessCode {
            showAlert(message: CreateProjectError.invalidAccessCode.rawValue)
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
    
    
    
    
    
    func getProjectDetails() {
        ProjectType.REF_PROJECT.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.editingProject.removeAll()
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    //If the id matches the id from projects then it will be added to userProjectsDetails Array
                    if let projectDetailDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let projectDetails = try! ProjectType(projectID: key, projectData: projectDetailDict)
                        if projectDetails.projectID == self.projectID {
                            self.editingProject.append(projectDetails)
                            self.currentProjectName = projectDetails.projectName.lowercased()
                            self.fillInTextFields()
                            self.getImageFromFirebase()
                        }
                    }
                }
            }
           self.auditionsTV.reloadData()
        })
    }
    
    func getAuditionDetails() {
        Auditions.REF_AUDTIONS.child(self.projectID).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.auditionsDetail.removeAll()
                for snap in snapshot {
                    print("AUDITION SNAP: \(snap)")
                    
                    //If the id matches the id from projects then it will be added to userProjectsDetails Array
                    if let auditionDetailDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let auditionDetail = Auditions(auditionKey: key, auditionData: auditionDetailDict)
                        self.auditionsDetail.append(auditionDetail)
                        print("Audition Count: \(self.auditionsDetail.count)")
                        }
                    }
                }
                self.auditionsTV.reloadData()
            })
        }
    
    //MARK: Fill in textfields
    func fillInTextFields() {
        let project = editingProject[0]
        self.projectNameLbl.text = project.projectName
        self.releaseDateLbl.text = project.projectReleaseDate
        self.projectAccessCodeLbl.text = project.projectAccessCode
    }
    
    //MARK: Get image from Firebase
    func getImageFromFirebase(img: UIImage? = nil) {
        if img != nil {
            self.projectImage.image = img
        } else {
            if let imageURL = self.editingProject[0].projectImage {
                let ref = FIRStorage.storage().reference(forURL: imageURL)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion:  { (data, error) in
                    if error != nil {
                        print("ZACK: Unable to download image from Firebase")
                        self.projectImage.image = #imageLiteral(resourceName: "ImageBtn")
                    } else {
                        print("ZACK: Successfully downloaded image.")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.projectImage.image = img
                            }
                        }
                    }
                })
            }
        }
        
    }
    
    //MARK: Creation of datepicker
    func createDatePicker() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //done button
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        releaseDateLbl.inputAccessoryView = toolbar
        releaseDateLbl.inputView = datePicker
        datePicker.datePickerMode = .date
        
    }
    
    @objc func donePressed() {
        //format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: datePicker.date)
        releaseDateLbl.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    @IBAction func closeAudition(segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addAudtions" {
            let vc = segue.destination as! AddEditAuditions
            vc.projectID = self.projectID
        } else if segue.identifier == "editAudition" {
            if let indexPath = auditionsTV.indexPathForSelectedRow {
                let vc = segue.destination as! AddEditAuditions
                vc.auditionKey = auditionsDetail[indexPath.row].auditionKey
                vc.projectID = self.projectID
                vc.editDescription = auditionsDetail[indexPath.row].description
                vc.editAddress = auditionsDetail[indexPath.row].address
                vc.editDate = auditionsDetail[indexPath.row].day
                vc.editstart = auditionsDetail[indexPath.row].startTime
                vc.editEnd = auditionsDetail[indexPath.row].endTime
                vc.editNotes = auditionsDetail[indexPath.row].notes
                vc.editAudition = true
            }
            
        }
    }
    
}
