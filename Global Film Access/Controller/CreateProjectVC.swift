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
    @IBOutlet weak var containerView: CustomView!
    @IBOutlet weak var projectNameLbl: CommonTextField!
    @IBOutlet weak var dateLbl: CommonTextField!
    @IBOutlet weak var imageAdd: CircleImage!
    
    let picker = UIDatePicker()
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        //creating the imagepicker
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true   
        imagePicker.delegate = self
        //Animation for View to popup
        containerView.transform = CGAffineTransform.init(scaleX: 0, y:0)
    }
  //Animation for View to popup
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform.identity
        })
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
    
    
    @IBAction func saveImageTapped(_ sender: Any) {
        guard let projectName = projectNameLbl.text, projectName != "" else {
            print("ZACK: User didn't add name") //TODO: add alert of date or name is blank
            return
        }
        guard let date = dateLbl.text, date != "" else {
            print("ZACK: User didn't add a release date") //TODO: add alert of date or name is blank
            return
        }
        guard let img = imageAdd.image, imageSelected == true else {
            
            print("ZACK: An image must be selected") //TODO: If they do not provide an image provide one
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.ds.REF_PROJECT_IMAGES.child(imgUid).put(imgData, metadata: metaData) { (metaData, error) in
                if error != nil {
                    print("ZACK: Unable to upload to Firebase Storage") //TODO: send alert to user
                } else {
                    print("ZACK: Successfully uploaded image")
                    let downloadURL = metaData?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.addProjectToFirebase(imgURL: url)
                    }
                }
            }
            
        }
        
    }
    
    
    //Post to Firebase
    func addProjectToFirebase(imgURL: String) {
        let project: Dictionary<String, AnyObject> = [
            "name": projectNameLbl.text as AnyObject,
            "image": imgURL as AnyObject,
            "startDate": dateLbl.text as AnyObject
        ]
        
        let firebaseProject = DataService.ds.REF_PROJECTS.childByAutoId()
        firebaseProject.setValue(project)
        
        let projectId = "\(firebaseProject.key)"
        
        let newUserProject: Dictionary<String, String> = [
            "projectid": projectId
        ]
        
        let firebaseUserProject = DataService.ds.REF_USER_PROJECTS.childByAutoId()
        firebaseUserProject.setValue(newUserProject)
        
        projectNameLbl.text = nil
        imageSelected = true
        dateLbl.text = nil
        imageAdd.image = UIImage(named: "ImageBtn.png")
        imageAdd.contentMode = .center
    }
    
    
    //Creation of datepicker
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
