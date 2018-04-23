//
//  AddEditAuditions.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 4/7/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit

class AddEditAuditions: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var descriptionLbl: UITextField!
    @IBOutlet weak var addressLbl: UITextField!
    @IBOutlet weak var dateLbl: UITextField!
    @IBOutlet weak var startLbl: UITextField!
    @IBOutlet weak var endLbl: UITextField!
    @IBOutlet weak var notesLbl: UITextField!
    var projectID = ""
    var editAudition = false
    var editDescription = ""
    var editAddress = ""
    var editDate = ""
    var editstart = ""
    var editEnd = ""
    var editNotes = ""
    var auditionKey = ""
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    var activeTextField = UITextField()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dateLbl.delegate = self
        startLbl.delegate = self
        endLbl.delegate = self
        createDatePicker()
        print(projectID)
        print("AUDITION KEY\(auditionKey)")
        fillInLabels()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        if let audtionDescription = descriptionLbl.text, let address = addressLbl.text, let day = dateLbl.text, let startTime = startLbl.text, let endTime = endLbl.text, let notes = notesLbl.text {
            
            let audition = Auditions(description: audtionDescription, startTime: startTime, endTime: endTime, day: day, address: address, notes: notes)
            do {
                try audition.createAuditionDB(audition: audition, projectID: projectID, auditionKey: auditionKey, isEditing: editAudition)
                self.dismiss(animated: true, completion: nil)
            } catch CreateAudtionError.invalideDescription {
                showAlert(message: CreateAudtionError.invalideDescription.rawValue)
            } catch CreateAudtionError.invalidAddress {
                showAlert(message: CreateAudtionError.invalidAddress.rawValue)
            } catch CreateAudtionError.invalidDay {
                showAlert(message: CreateAudtionError.invalidDay.rawValue)
            } catch CreateAudtionError.invalidStartTime {
                showAlert(message: CreateAudtionError.invalidStartTime.rawValue)
            } catch let error {
                print("\(error)")
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
    
    //function to see if user is editing the audition. If so we bring in the
    func fillInLabels() {
        if editAudition == true {
            descriptionLbl.text = editDescription
            addressLbl.text = editAddress
            dateLbl.text = editDate
            startLbl.text = editstart
            endLbl.text = editEnd
            notesLbl.text = editNotes
        } else {
            return
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.activeTextField = textField
        print("Active text selected")
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
        dateLbl.inputView = datePicker
        datePicker.datePickerMode = .date
        startLbl.inputAccessoryView = toolbar
        endLbl.inputAccessoryView = toolbar
        startLbl.inputView = timePicker
        endLbl.inputView = timePicker
        timePicker.datePickerMode = .time
        
    }
    @objc func donePressed() {
        //format date
            if activeTextField == dateLbl {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                let dateString = formatter.string(from: datePicker.date)
                dateLbl.text = "\(dateString)"
                self.view.endEditing(true)
            } else if activeTextField == startLbl {
                let formatter = DateFormatter()
                formatter.dateStyle = .none
                formatter.timeStyle = .short
                let dateString = formatter.string(from: timePicker.date)
                startLbl.text = "\(dateString)"
                self.view.endEditing(true)
            } else if activeTextField == endLbl {
                let formatter = DateFormatter()
                formatter.dateStyle = .none
                formatter.timeStyle = .short
                let dateString = formatter.string(from: timePicker.date)
                endLbl.text = "\(dateString)"
                self.view.endEditing(true)
            }
            
    }
    

    
    
    
    
    
    
    
    
    
    
    


}
