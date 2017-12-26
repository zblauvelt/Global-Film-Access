//
//  ArchiveProjectsVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 12/26/17.
//  Copyright © 2017 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class ArchiveProjectsVC: UITableViewController {
    var projectid = [String]()
    var archiveProjects = [CurArchProjects]()
    var userProjectDetails = [ProjectDetails]()
    static var archiveImageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserProjects()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userProjectDetails.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userProject = userProjectDetails[indexPath.row]
        let cellIdentifier = "archiveCell"
        
        // Configure the cell...
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ArchiveProjectCell {
            
            if let img = ArchiveProjectsVC.archiveImageCache.object(forKey: userProject.image as NSString) {
                cell.configureCell(userProject: userProject, img: img)
                
            } else {
                cell.configureCell(userProject: userProject)
            }
            return cell
        } else {
            return ArchiveProjectCell()
        }
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
    
    
    func getUserProjects() {
        DataService.ds.REF_USER_ARCHIVE_PROJECTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.projectid.removeAll()
                self.archiveProjects.removeAll()
                for snap in snapshot {
                    print("SNAPARCHIVE:\(snap)")
                    
                    if let projectDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let project = CurArchProjects(projectKey: key, projectData: projectDict)
                        self.archiveProjects.append(project)
                        self.projectid.append(project.projectid)
                        self.getProjectDetails()
                    }
                }
                
            }
            self.tableView.reloadData()
        })
    }
    
    
    func getProjectDetails() {
        DataService.ds.REF_PROJECTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.userProjectDetails.removeAll()
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    //If the id matches the id from projects then it will be added to userProjectsDetails Array
                    if let projectDetailDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let projectDetails = ProjectDetails(projectid: key, projectData: projectDetailDict)
                        
                        if self.projectid.contains("\(projectDetails.projectid)") {
                            self.userProjectDetails.append(projectDetails)
                        }
                    }
                }
            }
            
            self.tableView.reloadData()
        })
        
    }

}
