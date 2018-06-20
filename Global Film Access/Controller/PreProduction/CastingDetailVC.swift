//
//  CastingDetailVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 2/7/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class CastingDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var selectedCastPosition: String = ""
    static var positionName: String = ""
    var selectedRole = [Cast]()
    var prospects = [Prospect]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        CastingDetailVC.positionName = selectedCastPosition
        self.title = selectedCastPosition
        getProspects()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prospects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CastProspectCell"
        let prospect = prospects[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CastingDetailCell {
            //cell.configureCell(prospect: prospect)
            if let imageURL = prospect.talentProfileImage {
                if let img = SearchTalentVC.userProfileImageCache.object(forKey: imageURL as NSString) {
                    cell.configureCell(prospect: prospect, img: img)

                } else {
                    cell.configureCell(prospect: prospect)
                }
                return cell
            } else {
                cell.configureCell(prospect: prospect)
                return CastingDetailCell()
            }
        } else {
            return CastingDetailCell()
        }
    }
    
    func getProspects() {
        Cast.REF_PRE_PRODUCTION_CASTING_POSITION.child(ProjectDetailVC.currentProject).child(FIRDataCast.prospect.rawValue).child(selectedCastPosition).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.prospects.removeAll()
                for snap in snapshot {
                    print("SNAPPROSPECT: \(snap)")
                    
                    //If the id matches the id from projects then it will be added to userProjectsDetails Array
                    if let prospectDetailsDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let proscpectDetails = Prospect(prospectID: key, prospectData: prospectDetailsDict)
                        self.prospects.append(proscpectDetails)
                        print(proscpectDetails.talentName)
                    }
                }
            }
            self.getProfileImage()
        })
    }
    
    func getProfileImage() {
        print("Prospect Count: \(prospects.count)")
        for prospect in prospects {
            UserType.REF_CURRENT_USER_DETAILS.child(prospect.prospectID).observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshot {
                        print("SNAPUSER: \(snap)")
                        
                        if let userDetailsDict = snap.value as? Dictionary<String, String> {
                            let key = snap.key
                            let userDetails = UserType(userKey: key, userData: userDetailsDict)
                            if let img = userDetails.profileImage {
                                let prospectImgUpdate: Dictionary<String, String> = [
                                    FIRRoleData.talentProfileImage.rawValue: "\(img))"
                                ]
                                Cast.REF_PRE_PRODUCTION_CASTING_POSITION.child(ProjectDetailVC.currentProject).child(FIRDataCast.prospect.rawValue).child(self.selectedCastPosition).child(prospect.prospectID).updateChildValues(prospectImgUpdate)
                            }
                            
                        }
                    }
                }
            })
        }
        self.tableView.reloadData()
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchTalent" {
            let desVC = segue.destination as! SearchTalentVC
            desVC.searchingRole.append(selectedRole[0])
        } else if segue.identifier == "prospectToProfile" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let desVC = segue.destination as! ProfileVC
                desVC.currentUserKey = prospects[indexPath.row].prospectID
            }
            
        }
    }

    @IBAction func unwindToCastingDetail(segue: UIStoryboardSegue) {}

}
