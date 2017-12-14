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
        
        var currentProjects = [CurArchProjects]()
        var userProjectDetails = [ProjectDetails]()
        var projectid = [String]()
        static var imageCache: NSCache<NSString, UIImage> = NSCache()

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
                
                if let img = ProjectListVC.imageCache.object(forKey: userProject.image as NSString) {
                    cell.configureCell(userProject: userProject, img: img)

                } else {
                    cell.configureCell(userProject: userProject)
            }
                return cell
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
        
      /*  // Override to support conditional editing of the table view.
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            // Return false if you do not want the specified item to be editable.
            return true
        }*/
     

        
       /* // Override to support editing the table view.
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            
            let archive = UITableViewRowAction(style: .normal, title: "Archive") { (rowAction, indexPath) in
                self.moveToArchive(indexPath: indexPath)
            }
            archive.backgroundColor = UIColor.blue
            return [archive]
        }*/
     

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
        
        
        //Need to get info to load in ViewDidLoad and need to figure out how to get the current user's projects and access the total details.
        func getUserProjects() {
            DataService.ds.REF_USER_CURRENT_PROJECTS.observe(.value, with: { (snapshot) in
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    self.projectid.removeAll()
                    for snap in snapshot {
                        print("SNAP:\(snap)")
                        
                        if let projectDict = snap.value as? Dictionary<String, String> {
                            let key = snap.key
                            let project = CurArchProjects(projectKey: key, projectData: projectDict)
                            self.currentProjects.append(project)
                            self.projectid.append(project.projectid)
                            self.getProjectDetails()
                        }
                    }
                    
                }
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
        
        //Move row to archive
        func moveToArchive(indexPath: IndexPath) {
            let project = userProjectDetails[indexPath.row].projectid
            let archivedProject: Dictionary<String, String> = [
                "projectid": project
            ]
            let firebaseArchiveProject = DataService.ds.REF_USER_ARCHIVE_PROJECTS.childByAutoId()
            firebaseArchiveProject.setValue(archivedProject)
            
            let currentProjectAtRow = currentProjects[indexPath.row].projectKey
            let firebaseRemoveFromCurrent = DataService.ds.REF_USER_CURRENT_PROJECTS.child(currentProjectAtRow)
            firebaseRemoveFromCurrent.removeValue()
        }
        
        //unwind Create Project VC
        @IBAction func clos(segue: UIStoryboardSegue) {
            
        }
        
        

    }
