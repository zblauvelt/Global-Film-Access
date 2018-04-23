//
//  assignAuditionVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 4/19/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class assignAuditionVC: UITableViewController {
    
    var projectID = ProjectDetailVC.currentProject
    var auditions = [Auditions]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getAuditionDetails()    

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return auditions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


            let cellIdentifier = "pickAudition"
            
               let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
                
                cell.textLabel?.text = self.auditions[indexPath.row].description
                cell.detailTextLabel?.text = "\(self.auditions[indexPath.row].day) from \(self.auditions[indexPath.row].startTime) to \(self.auditions[indexPath.row].endTime)"

            return cell
    }
 

    //MARK: Getting Audition Details
    func getAuditionDetails() {
        Auditions.REF_AUDTIONS.child(self.projectID).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.auditions.removeAll()
                for snap in snapshot {
                    print("AUDITION SNAP: \(snap)")
                    
                    //If the id matches the id from projects then it will be added to userProjectsDetails Array
                    if let auditionDetailDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let auditionDetail = Auditions(auditionKey: key, auditionData: auditionDetailDict)
                        self.auditions.append(auditionDetail)
                       
                    }
                }
            }
            self.tableView.reloadData()
            
        })
    }

}
