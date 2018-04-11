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
    var archiveProjects = [UserProjects]()
    var userProjectDetails = [ProjectType]()
    var userProjectAccess = [UserProjects]()
    static var archiveImageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserProjects()
       
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
            if let imageURL = userProject.projectImage {
                
                if let img = ArchiveProjectsVC.archiveImageCache.object(forKey: imageURL as NSString) {
                    cell.configureCell(userProject: userProject, img: img)
                    
                } else {
                    cell.configureCell(userProject: userProject)
                }
                return cell
            } else {
                return ArchiveProjectCell()
            }
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
        UserProjects.REF_USER_ARCHIVE_PROJECTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.projectid.removeAll()
                self.archiveProjects.removeAll()
                for snap in snapshot {
                    print("SNAPARCHIVE:\(snap)")
                    
                    if let projectDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let project = try! UserProjects(projectID: key, userProjectData: projectDict)
                        self.archiveProjects.append(project)
                        self.projectid.append(project.projectID)
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
                        let projectDetails = try! ProjectType(projectID: key, projectData: projectDetailDict)
                        
                        if self.projectid.contains("\(projectDetails.projectID)") {
                            self.userProjectDetails.append(projectDetails)
                        }
                    }
                }
            }
            self.tableView.reloadData()
        })
        
    }
    
    //Move row to current projects from archive.
    func moveToArchive(indexPath: IndexPath) {
        let project = userProjectDetails[indexPath.row].projectID
        let activateProject: Dictionary<String, String> = [
            FIRProjectData.projectName.rawValue: userProjectDetails[indexPath.row].projectName,
            FIRProjectData.accessLevel.rawValue: userProjectDetails[indexPath.row].userAccessLevel
        ]
        let firebaseActivateProject = UserProjects.REF_USER_CURRENT_PROJECTS.child(project)
        firebaseActivateProject.setValue(activateProject)
        
        let currentProjectAtRow = userProjectDetails[indexPath.row].projectID
        let firebaseRemoveFromArchive = UserProjects.REF_USER_ARCHIVE_PROJECTS.child(currentProjectAtRow)
        firebaseRemoveFromArchive.removeValue()
        self.getProjectDetails()
    }
    
    //Remove row
    func permanentlyDelete(indexPath: IndexPath) {
        if archiveProjects[indexPath.row].accessLevel == UserAccessLevel.admin.rawValue {
            let currentProjectAtRow = userProjectDetails[indexPath.row].projectID
            let firebaseRemoveFromGlobalProjects = DataService.ds.REF_PROJECTS.child(currentProjectAtRow)
            firebaseRemoveFromGlobalProjects.removeValue()
            deleteUserProjects(indexPath: indexPath)
            ProjectListVC.projectName = ProjectListVC.projectName.filter{$0 != userProjectDetails[indexPath.row].projectName.lowercased()}
        } else {
            deleteUserProjects(indexPath: indexPath)
        }
    }
    
    //Delete only the users projects if they are not the admin.
    func deleteUserProjects(indexPath: IndexPath) {
        let currentProjectAtRow = userProjectDetails[indexPath.row].projectID
        let firebaseRemoveFromArchive = UserProjects.REF_USER_ARCHIVE_PROJECTS.child(currentProjectAtRow)
        let firebaseRemoveFromUser = UserProjects.REF_USER_PROJECTS.child(currentProjectAtRow)
        firebaseRemoveFromArchive.removeValue()
        firebaseRemoveFromUser.removeValue()
        self.getProjectDetails()
    }
 
    
    //unwind Create Project VC
    @IBAction func clos(segue: UIStoryboardSegue) {
        
    }

}
