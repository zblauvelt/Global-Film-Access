//
//  AddEditAuditions.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 4/7/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit

class AddEditAuditions: UIViewController {
    
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


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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



}
