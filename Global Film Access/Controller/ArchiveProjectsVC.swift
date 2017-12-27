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
 

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let activate = UITableViewRowAction(style: .normal, title: "Activate") { (rowAction, indexPath) in
            self.moveToArchive(indexPath: indexPath)
        }
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            self.permanentlyDelete(indexPath: indexPath)
        }
        
        delete.backgroundColor = UIColor.red
        activate.backgroundColor = UIColor.gray
        return [activate, delete]
        
    }
    
    //Need to get info to load in ViewDidLoad and need to figure out how to get the current user's projects and access the total details.
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
                        self.projectid.append(project.projectKey)
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
    
    //Move row to current projects.
    func moveToArchive(indexPath: IndexPath) {
        let project = userProjectDetails[indexPath.row].projectid
        let activateProject: Dictionary<String, String> = [
            "projectid": project
        ]
        let firebaseActivateProject = DataService.ds.REF_USER_CURRENT_PROJECTS.child(project)
        firebaseActivateProject.setValue(activateProject)
        
        let currentProjectAtRow = userProjectDetails[indexPath.row].projectid
        let firebaseRemoveFromArchive = DataService.ds.REF_USER_ARCHIVE_PROJECTS.child(currentProjectAtRow)
        firebaseRemoveFromArchive.removeValue()
        self.getProjectDetails()
    }
    
    //Remove row
    func permanentlyDelete(indexPath: IndexPath) {
        let currentProjectAtRow = userProjectDetails[indexPath.row].projectid
        let firebaseRemoveFromArchive = DataService.ds.REF_USER_ARCHIVE_PROJECTS.child(currentProjectAtRow)
        let firebaseRemoveFromUser = DataService.ds.REF_USER_PROJECTS.child(currentProjectAtRow)
        firebaseRemoveFromArchive.removeValue()
        firebaseRemoveFromUser.removeValue()
        self.getProjectDetails()
    }
    
 
    
    //unwind Create Project VC
    @IBAction func clos(segue: UIStoryboardSegue) {
        
    }

}
