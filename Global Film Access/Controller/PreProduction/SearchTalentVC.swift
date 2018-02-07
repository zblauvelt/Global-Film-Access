//
//  SearchTalentVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 2/7/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class SearchTalentVC: UITableViewController {

    var unfilteredTalent = [UserType]()
    static var userProfileImageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTalentProfiles()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return unfilteredTalent.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let talent = unfilteredTalent[indexPath.row]
        let cellIdentifier = "userSearchCell"
        
        // Configure the cell...
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchTalentCell {
            if let imageURL = talent.profileImage {
                if let img = SearchTalentVC.userProfileImageCache.object(forKey: imageURL as NSString) {
                    cell.configureCell(user: talent, img: img)
                    
                } else {
                    cell.configureCell(user: talent)
                }
                return cell
            } else {
                return SearchTalentCell()
            }
        } else {
            return SearchTalentCell()
        }
    }

    //Get all users for Search
    func getTalentProfiles() {
        UserType.REF_USERS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.unfilteredTalent.removeAll()
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    //If the id matches the id from projects then it will be added to userProjectsDetails Array
                    if let userDetailsDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let userDetails = try! UserType(userKey: key, userData: userDetailsDict)
                        self.unfilteredTalent.append(userDetails)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }



}
