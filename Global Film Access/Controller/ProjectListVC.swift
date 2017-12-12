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
        
        var projects = [String]()
        var userProjectDetails = [ProjectDetails]()
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
        
        
        //Need to get info to load in ViewDidLoad and need to figure out how to get the current user's projects and access the total details.
        func getUserProjects() {
            DataService.ds.REF_USER_PROJECTS.observe(.value, with: { (snapshot) in
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    self.projects.removeAll()
                    for snap in snapshot {
                        print("SNAP:\(snap)")
                        
                        if let projectDict = snap.value as? Dictionary<String, String> {
                            let key = snap.key
                            let project = UserProjects(userProjects: key, projectData: projectDict)
                            self.projects.append(project.projectid)
                            print("COUNT: \(self.projects.count)")
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
                                
                                if self.projects.contains("\(projectDetails.projectid)") {
                                    self.userProjectDetails.append(projectDetails)
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            })
            
        }
        
        //unwind Create Project VC
        @IBAction func clos(segue: UIStoryboardSegue) {
            
        }
        
        

    }
