//
//  CastPositionsVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 2/1/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit

class CastPositionsVC: UIViewController {
    
    var positionName: String = ""
    var projectID: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("\(projectID)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPositionTapped(_ sender: Any) {
        //1. Create the alert controller.
        let alertController = UIAlertController(title: "Add Position", message: "Enter a name of your new cast member.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { alert -> Void in
            return
        }))
        
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let positionNameField = alertController.textFields![0] as UITextField
            
            if let castName = positionNameField.text {
                
                let createCastName = Cast()
                
                if castName != "" {
                    try! createCastName.createPosition(projectID: self.projectID, positionName: castName)
                } else {
                    
                    let alertController = UIAlertController(title: "" , message: "Please provide a valid name.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .cancel) { action in
                        return
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
               
            }
            
        }))
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Position Name"
            textField.textAlignment = .center
        })
        
        // 4. Present the alert.
        self.present(alertController, animated: true, completion: nil)
    }
    

}
