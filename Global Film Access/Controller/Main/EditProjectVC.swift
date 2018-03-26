//
//  EditProjectVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 3/26/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class EditProjectVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var projectImage: CircleImage!
    @IBOutlet weak var projectNameLbl: CommonTextField!
    @IBOutlet weak var releaseDateLbl: CommonTextField!
    @IBOutlet weak var projectAccessCodeLbl: CommonTextField!
    
    
    var editingProject = [ProjectType]()
    var projectID = ""
    var imagePicker: UIImagePickerController!
    var imageChanged = false
    //This variable holds the original project name to tell
    //if they changed the name. if they did change name we will test for duplicate.
    var currentProjectName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProjectDetails()
        //Creating Image Picker
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
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
    
    
    
}
