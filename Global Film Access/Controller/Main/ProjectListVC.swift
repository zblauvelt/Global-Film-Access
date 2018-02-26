    //
    //  ProjectListVC.swift
    //  Global Film Access
    //
    //  Created by Zachary Blauvelt on 11/30/17.
    //  Copyright © 2017 Zachary Blauvelt. All rights reserved.
    //

    import UIKit
    import Firebase

    class ProjectListVC: UITableViewController {
        
        var currentProjects = [UserProjects]()
        var userProjectDetails = [ProjectType]()
        static var projectid = [String]()
        static var projectName = [String]()
        static var projectImageCache: NSCache<NSString, UIImage> = NSCache()
        
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
            let cellIdentifier = "ProjectsCell"

            // Configure the cell...
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProjectsCell {
                if let imageURL = userProject.projectImage {
                    if let img = ProjectListVC.projectImageCache.object(forKey: imageURL as NSString) {
                        cell.configureCell(userProject: userProject, img: img)
                        
                    } else {
                        cell.configureCell(userProject: userProject)
                    }
                    return cell
                } else {
                    return ProjectsCell()
                }
                } else {
                    return ProjectsCell()
                }
    }

        override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let archive = UITableViewRowAction(style: .normal, title: "Archive") { (rowAction, indexPath) in
                self.moveToArchive(indexPath: indexPath)
                
            }
            archive.backgroundColor = UIColor.blue
            return [archive]
            
        }
        
        
        //Need to get info to load in ViewDidLoad and need to figure out how to get the current user's projects and access the total details.
        func getUserProjects() {
            UserProjects.REF_USER_CURRENT_PROJECTS.observe(.value, with: { (snapshot) in
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    ProjectListVC.projectid.removeAll()
                    self.currentProjects.removeAll()
                    for snap in snapshot {
                        print("SNAP:\(snap)")
                        
                        if let projectDict = snap.value as? Dictionary<String, String> {
                            let key = snap.key
                            let project = try! UserProjects(projectID: key, userProjectData: projectDict)
                            self.currentProjects.append(project)
                            ProjectListVC.projectid.append(project.projectID)
                            self.getProjectDetails()
                        }
                    }
                    
                }
                self.tableView.reloadData()
            })
        }
        
        
        func getProjectDetails() {
            ProjectType.REF_PROJECT.observe(.value, with: { (snapshot) in
                    if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        self.userProjectDetails.removeAll()
                        for snap in snapshot {
                            print("SNAP: \(snap)")
                           
                          //If the id matches the id from projects then it will be added to userProjectsDetails Array
                            if let projectDetailDict = snap.value as? Dictionary<String, String> {
                                let key = snap.key
                                let projectDetails = try! ProjectType(projectID: key, projectData: projectDetailDict)
                                if ProjectListVC.projectid.contains("\(projectDetails.projectID)") {
                                    self.userProjectDetails.append(projectDetails)
                                    ProjectListVC.projectName.append(projectDetails.projectName.lowercased())
                                    print("Project Names: \(ProjectListVC.projectName)")
                            }
                        }
                    }
                }

                self.tableView.reloadData()
            })
            
        }
        
        //Move row to archive
        func moveToArchive(indexPath: IndexPath) {
            let projectid = userProjectDetails[indexPath.row].projectID
            let archivedProject: Dictionary<String, String> = [
                FIRProjectData.projectName.rawValue: userProjectDetails[indexPath.row].projectName,
                FIRProjectData.accessLevel.rawValue: userProjectDetails[indexPath.row].userAccessLevel
            ]
            let firebaseArchiveProject = UserProjects.REF_USER_ARCHIVE_PROJECTS.child(projectid)
            firebaseArchiveProject.setValue(archivedProject)
            
            let currentProjectAtRow = userProjectDetails[indexPath.row].projectID
            let firebaseRemoveFromCurrent = UserProjects.REF_USER_CURRENT_PROJECTS.child(currentProjectAtRow)
            firebaseRemoveFromCurrent.removeValue()
            self.getProjectDetails()
        }
        
        
        
        //unwind Create Project VC
        @IBAction func clos(segue: UIStoryboardSegue) {
            
        }
        
        //Pass data through Segue
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "goToProjectDetail" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let tabCtrl = segue.destination as! UITabBarController
                    let nav = tabCtrl.viewControllers!.first as! UINavigationController
                    let destinationController = nav.viewControllers.first as! ProjectDetailVC
                    destinationController.selectedProjectName = userProjectDetails[indexPath.row].projectName
                    destinationController.selectProjectID = userProjectDetails[indexPath.row].projectID
                }
            }
        }
        
        
        
        

    }
