//
//  NotificationDetailVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 7/10/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class NotificationDetailVC: UIViewController {

    var notificationLabel = EventLabel.na
    var roleID = ""
    var projectID = ""
    var eventID = ""
    var inviterUserID = ""
    var roleDetails = [Cast]()
    var auditionDetails = [Auditions]()
    var inviterUserDetails = [UserType]()
    
    @IBOutlet weak var inviterProfileImage: CircleImage!
    @IBOutlet weak var inviterNameLabel: UILabel!
    @IBOutlet weak var roleName: UILabel!
    @IBOutlet weak var roleShortDescription: UILabel!
    @IBOutlet weak var rateDayLbl: UILabel!
    @IBOutlet weak var daysLbl: UILabel!
    @IBOutlet weak var roleTypeLbl: UILabel!
    @IBOutlet weak var ageRangeLbl: UILabel!
    @IBOutlet weak var longDescriptionLbl: UILabel!
    @IBOutlet weak var eventDateLbl: UILabel!
    @IBOutlet weak var eventTimeLbl: UILabel!
    @IBOutlet weak var eventAddressLbl: UILabel!
    @IBOutlet weak var eventNotesLbl: UILabel!
    @IBOutlet weak var eventDetailTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(notificationLabel.rawValue)
        print(roleID)
        toggleInfo(label: notificationLabel)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func acceptInvite(_ sender: Any) {
        let talentAccepted: Dictionary<String, String> = [
            FIRRoleData.talentAccepted.rawValue: "YES"
        ]
        
        Cast.REF_PRE_PRODUCTION_CASTING_POSITION.child(projectID).child(FIRDataCast.prospect.rawValue).child(roleID).child(userID).updateChildValues(talentAccepted)
    }
    
    
    func getRoleInfo() {
        Cast.REF_PRE_PRODUCTION_CASTING_POSITION.child(projectID).child(FIRDataCast.cast.rawValue).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.roleDetails.removeAll()
                for snap in snapshot {
                    print("SNAP:\(snap)")
                    
                    if let positionDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let position = Cast(roleName: key, roleData: positionDict)
                        if position.roleName == self.roleID {
                            self.roleDetails.append(position)
                        }
                    }
                }
            }
            
        })
    }
    
    func getAuditionDetails() {
        Auditions.REF_AUDTIONS.child(projectID).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.auditionDetails.removeAll()
                for snap in snapshot {
                    print("AUDITION SNAP: \(snap)")
                    
                    //If the id matches the id from projects then it will be added to userProjectsDetails Array
                    if let auditionDetailDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let auditionDetail = Auditions(auditionKey: key, auditionData: auditionDetailDict)
                        if auditionDetail.auditionKey == self.eventID {
                            self.auditionDetails.append(auditionDetail)
                        }
                    }
                }
            }
            self.fillInLabels(label: self.notificationLabel)
        })
    }
    
    func getUserDetails() {
        UserType.REF_CURRENT_USER_DETAILS.child(inviterUserID).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.inviterUserID.removeAll()
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    //If the id matches the id from projects then it will be added to userProjectsDetails Array
                    if let userDetailsDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let userDetails = UserType(userKey: key, userData: userDetailsDict)
                        self.inviterUserDetails.append(userDetails)
                        self.getImageFromFirebase()
                    }
                }
            }
        })
    }
    
    //MARK: Get image from Firebase
    func getImageFromFirebase(img: UIImage? = nil) {
        if img != nil {
            self.inviterProfileImage.image = img
        } else {
            if let imageURL = self.inviterUserDetails[0].profileImage {
                let ref = FIRStorage.storage().reference(forURL: imageURL)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion:  { (data, error) in
                    if error != nil {
                        print("ZACK: Unable to download image from Firebase")
                        self.inviterProfileImage.image = #imageLiteral(resourceName: "ProfileImage")
                    } else {
                        print("ZACK: Successfully downloaded image.")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.inviterProfileImage.image = img
                            }
                        }
                    }
                })
            }
        }
        
    }
    
    func fillInLabels(label: EventLabel) {
        let roleText = roleDetails[0]
        let auditionText = auditionDetails[0]
        let userText = inviterUserDetails[0]
        switch label {
        case .audition:
            self.inviterNameLabel.text = "\(userText.firstName) \(userText.lastName) has invited you to audition! Please look over the details and reply at the bottom by accepting or declinging the invitation."
            self.roleName.text = roleText.roleName
            self.roleShortDescription.text = roleText.shortDescription
            let formatter = NumberFormatter()
            formatter.usesGroupingSeparator = true
            formatter.numberStyle = .currencyAccounting
            formatter.locale = Locale.current
            if let dailyRate = roleText.dailyRate {
                if let dailyRateFloat = Float(dailyRate) {
                  self.rateDayLbl.text = formatter.string(for: dailyRateFloat)
                }
                
            }
            self.daysLbl.text = roleText.daysNeeded
            self.roleTypeLbl.text = roleText.roleType
            if let ageMin = roleText.ageMin, let ageMax = roleText.ageMax {
                self.ageRangeLbl.text = "\(ageMin) - \(ageMax)"
            }
            self.longDescriptionLbl.text = roleText.detailDescription
            self.eventDateLbl.text = auditionText.day
            self.eventTimeLbl.text = "\(auditionText.startTime) - \(auditionText.endTime)"
            self.eventAddressLbl.text = auditionText.address
            self.eventNotesLbl.text = auditionText.notes
            self.eventDetailTypeLabel.text = "\(auditionText.description) Details"
            
        default:
            print("no labels to fill")
        }
    }
    
    /// Get info from Firebase based on Event Label
    func toggleInfo(label: EventLabel) {
        switch label {
        case .audition:
            getUserDetails()
            getRoleInfo()
            getAuditionDetails()
        default:
            print("no labels to fill")
        }
    }
    

}
