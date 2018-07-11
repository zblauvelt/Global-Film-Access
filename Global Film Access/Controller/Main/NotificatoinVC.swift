//
//  NotificatoinVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 7/5/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class NotificatoinVC: UITableViewController {
    
    var notifications = [Notifications]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getNotificationDetails()
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
        return notifications.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "notificationCell"
        let notification = notifications[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NotificationCell {
            
            let imageURL = notification.inviterProfileImage
                if let img = SearchTalentVC.userProfileImageCache.object(forKey: imageURL as NSString) {
                    cell.configureCell(notification: notification, img: img)
                    
                } else {
                    cell.configureCell(notification: notification)
                }
            return cell
        }
        return NotificationCell()
    }
 
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func getNotificationDetails() {
            Notifications.REF_NOTIFICATION.child(userID).observe(.value, with: { (snapshot) in
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    self.notifications.removeAll()
                    for snap in snapshot {
                        print("NOTIFICATION SNAP: \(snap)")
                        
                        //If the id matches the id from projects then it will be added to userProjectsDetails Array
                        if let notificationDetailDict = snap.value as? Dictionary<String, String> {
                            let key = snap.key
                            let notificationDetail = Notifications(notificationKey: key, notificationData: notificationDetailDict)
                            self.notifications.append(notificationDetail)
                        }
                    }
                }
                //self.getInviterProfileImage()
                self.tableView.reloadData()
            })
        
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNotificationDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let desVC = segue.destination as! NotificationDetailVC
                desVC.notificationLabel = notifications[indexPath.row].label
                desVC.inviterUserID = notifications[indexPath.row].inviterUserID
                //role ID
                if let roleID = notifications[indexPath.row].roleID {
                    desVC.roleID = roleID
                } else {
                    desVC.roleID = ""
                }
                
                //project ID
                if let projectID = notifications[indexPath.row].projectID {
                    desVC.projectID = projectID
                } else {
                    desVC.projectID = ""
                }
                
                //Audition ID
                if let auditionID = notifications[indexPath.row].eventID {
                    desVC.eventID = auditionID
                } else {
                    desVC.eventID = ""
                }
                
            }
        }
    }
    
    
    /*func getInviterProfileImage() {
        var inviterInfo = [UserType]()
        for notification in notifications {
            let userKey = notification.inviterUserID
            UserType.REF_CURRENT_USER_DETAILS.child(userKey).observe(.value, with: { (snapshot) in
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    inviterInfo.removeAll()
                    for snap in snapshot {
                        print("NOTIFICATION SNAP: \(snap)")
                        
                        //If the id matches the id from projects then it will be added to userProjectsDetails Array
                        if let inviterDetailDict = snap.value as? Dictionary<String, String> {
                            let key = snap.key
                            let inviterInfoDetails = UserType(userKey: key, userData: inviterDetailDict)
                            inviterInfo.append(inviterInfoDetails)
                        }
                    }
                }
            })
            
            if let profileImage = inviterInfo[0].profileImage {
                notification.inviterProfileImage = profileImage
                self.tableView.reloadData()
            } else {
                self.tableView.reloadData()
            }
        }
    }*/
    
    
}
