//
//  CreateProjectVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 12/6/17.
//  Copyright © 2017 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class CreateProjectVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //@IBOutlet weak var containerView: CustomView!
    @IBOutlet weak var projectNameLbl: UITextField!
    @IBOutlet weak var dateLbl: UITextField!
    @IBOutlet weak var projectAccessCodeLbl: UITextField!
    
    @IBOutlet weak var imageAdd: CircleImage!
    
    let picker = UIDatePicker()
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        //White border on text labels
        projectNameLbl.setBottomBorder()
        dateLbl.setBottomBorder()
        projectAccessCodeLbl.setBottomBorder()
        //creating the imagepicker
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true   
        imagePicker.delegate = self
  
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageAdd.contentMode = .scaleToFill
            imageSelected = true
        } else {
            print("ZACK: A valid image wasn't selected.")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func createProjectTapped(_ sender: Any) {
        if let projectName = projectNameLbl.text, let projectReleaseDate = dateLbl.text, let projectAccessCode = projectAccessCodeLbl.text, let projectImage = imageAdd.image {
            
            let newProject = ProjectType(projectName: projectName, projectReleaseDate: projectReleaseDate, projectAccessCode: projectAccessCode)
            do {
                try newProject.createProjectDB(project: newProject, image: projectImage)
                print("ZACK: Project saved.")
                self.dismiss(animated: true, completion: nil)
                projectNameLbl.text = nil
                imageSelected = true
                dateLbl.text = nil
                imageAdd.image = UIImage(named: "ImageBtn.png")
                imageAdd.contentMode = .center
            } catch CreateProjectError.inValidProjectName {
                showAlert(message: CreateProjectError.inValidProjectName.rawValue)
            } catch CreateProjectError.duplicateName {
                showAlert(message: CreateProjectError.duplicateName.rawValue)
            } catch CreateProjectError.invalidProjectDate {
                showAlert(message: CreateProjectError.invalidProjectDate.rawValue)
            } catch CreateProjectError.invalidAccessCode {
                showAlert(message: CreateProjectError.invalidAccessCode.rawValue)
            } catch CreateProjectError.invalideProjectImage {
                showAlert(message: CreateProjectError.invalideProjectImage.rawValue)
            } catch let error {
                showAlert(message: "\(error)")
            }
            
            }   else {
                showAlert(message: "Unable to create project")
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
    

    //MARK: Creation of datepicker
    func createDatePicker() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        dateLbl.inputAccessoryView = toolbar
        dateLbl.inputView = picker
        picker.datePickerMode = .date
    }
    @objc func donePressed() {
        //format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: picker.date)
        dateLbl.text = "\(dateString)"
        self.view.endEditing(true)
    }

}
