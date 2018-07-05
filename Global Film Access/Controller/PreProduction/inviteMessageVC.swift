//
//  inviteMessageVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 4/30/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

/*class inviteMessageVC: UIViewController {
    
    var inviteeName = ""
    var inviteeKey = ""
    var invitorName = ""
    var productionCompanyName = ""
    var projectName = ""
    var auditionID = ""
    var invitorProfileImage = ""
    var audition = [Auditions]()
    var positionName = CastingDetailVC.positionName
    let projectID = ProjectDetailVC.currentProject
    
    @IBOutlet weak var invitorNameLbl: UITextField!
    @IBOutlet weak var inviteMessageLbl: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getInvitorInfo()
        getProjectInfo()
        getAuditionInfo()
        print("ProjectID\(projectID)")
    }

    func createMessage() {
        //From label
        invitorNameLbl.text = invitorName
        
        //Greeting
        var greeting = ""
        if inviteeName == "" {
            greeting = "Hello,"
        } else {
            if let firstName = inviteeName.components(separatedBy: " ").first {
                greeting = "Hello \(firstName),"
            } else {
                greeting = "Hello \(inviteeName)"
            }
        }
        
        //Intro
        var intro = ""
        if invitorName == "" {
            intro = ""
        } else {
            intro = "   My name is \(invitorName) and I am with \(productionCompanyName). We would like to invite you to audition for the role of \(positionName) in our new project, \(projectName)."
        }
        
        var auditionDetail = ""
        //Audition Details
        if audition.count == 0 {
            auditionDetail = ""
        } else {
            auditionDetail = "  The \(audition[0].description) will be held at \(audition[0].address) on \(audition[0].day) starting at \(audition[0].startTime) and ending at \(audition[0].endTime).\n Please accept our invitation by choosing accept to this invite.\n\n Hope to see you there,\n \(invitorName)"
        }
        
        //Full message
        self.inviteMessageLbl.text = "\(greeting)\n\n\(intro)\n\(auditionDetail)"
    }
    
    
    @IBAction func inviteBtnTapped(_ sender: Any) {
        if let message = inviteMessageLbl.text {
            
            let invite = EventInvite(message: message, profileImage: invitorProfileImage, invitor: invitorName)
            
            do {
                try invite.createInvite(event: invite, invitorName: invitorName, invitorProfileImage: invitorProfileImage, inviteeKey: inviteeKey, projectID: projectID, auditionID: auditionID, positionName: positionName)
                self.dismiss(animated: true, completion: nil)
            } catch CreateInviteError.invalidMessage {
                showAlert(message: CreateInviteError.invalidMessage.rawValue)
            } catch CreateInviteError.invalidInvitor {
                showAlert(message: CreateInviteError.invalidInvitor.rawValue)
            } catch let error {
                showAlert(message: "\(error)")
            }
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
    

        //get invitee name
        func getInvitorInfo() {
            UserType.REF_CURRENT_USER_DETAILS_INFO.observe(.value, with: { (snapshot) in
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshot {
                        print("SNAP:\(snap)")
                        
                        if let userDict = snap.value as? Dictionary<String, String> {
                            let key = snap.key
                            let user = UserType(userKey: key, userData: userDict)
                            self.invitorName = "\(user.firstName) \(user.lastName)"
                            if let img = user.profileImage {
                                self.invitorProfileImage = img
                            } else {
                                self.invitorProfileImage = ""
                            }
                            
                            self.createMessage()
                        }
                    }
                }
            })
        }
    
    //Get Project Details
    func getProjectInfo() {
        ProjectType.REF_PROJECT.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP:\(snap)")
                    
                    if let projectDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let project = try! ProjectType(projectID: key, projectData: projectDict)
                        if project.projectID == self.projectID {
                            self.productionCompanyName = project.productionCompany
                            self.projectName = project.projectName
                            self.createMessage()
                            return
                        }
                    }
                }
            }
        })
    }
    
    //Get Audition Details
    func getAuditionInfo() {
        Auditions.REF_AUDTIONS.child(projectID).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP:\(snap)")
                    
                    if let auditionDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let audition = Auditions(auditionKey: key, auditionData: auditionDict)
                        if audition.auditionKey == self.auditionID {
                            self.audition.append(audition)
                            self.createMessage()
                            return
                        }
                        
                    }
                }
            }
        })
    }
    

        



}*/
