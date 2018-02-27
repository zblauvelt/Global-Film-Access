//
//  EditProfileVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 2/11/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class EditProfileVC: UIViewController {
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        
        
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

    

    

}
