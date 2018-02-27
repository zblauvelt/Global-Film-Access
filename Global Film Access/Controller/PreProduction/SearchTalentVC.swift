//
//  SearchTalentVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 2/7/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class SearchTalentVC: UITableViewController, UISearchBarDelegate {

    var unfilteredTalent = [UserType]()
    var filteredTalent = [UserType]()
    var isSearching = false
    static var userProfileImageCache: NSCache<NSString, UIImage> = NSCache()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTalentProfiles()
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if isSearching {
            return filteredTalent.count
        }
        return unfilteredTalent.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let talent = toggleTalentArrays()[indexPath.row]
     //let talent = unfilteredTalent[indexPath.row]
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            
            view.endEditing(true)
            filteredTalent.removeAll()
            tableView.reloadData()
        } else {
            isSearching = true
            
            for talent in unfilteredTalent {
                if talent.firstName.lowercased() == searchText.lowercased() || talent.lastName.lowercased() == searchText.lowercased() {
                   filteredTalent.append(talent)
                }
            }
            tableView.reloadData()
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
                        let userDetails = UserType(userKey: key, userData: userDetailsDict)
                        self.unfilteredTalent.append(userDetails)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    ///Function to see if searching or not.
    func toggleTalentArrays() -> [UserType] {
        if isSearching {
            return filteredTalent
        } else {
            return unfilteredTalent
        }
    }

}
