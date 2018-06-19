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
    var talentName = ""
    var positionName = CastingDetailVC.positionName
    var userID = ""
    var segueTag = 0
    //received from SearchTalentVC
    var selectedTalent = [UserType]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getAuditionDetails()
        print("Selected Talent Count \(self.selectedTalent.count)")
        print(segueTag)

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if segueTag == 2 {
            print(segueTag)
            for talent in selectedTalent {
                let fullName = "\(talent.firstName) \(talent.lastName)"
                let userID = talent.userKey
                let project = ProjectDetailVC.currentProject
                let position = CastingDetailVC.positionName
                let prospect = Prospect(talentName: fullName, talentRating: "5", talentAccepted: "NO")
                prospect.createProspect(prospect: prospect, projectID: project, position: position, userID: userID)
                //let invitation = 
                
            }
            UserType.selectedTalentForSearch.removeAll()
            self.showAlert(message: "You have invited \(selectedTalent.count) people to \(auditions[indexPath.row].description). They will receive your invite in their inbox and you can now manage them on the role's page.")
            //self.dismiss(animated: true, completion: nil)
        } else {
            let talentRating = "5"
            let talentAccepted = "NO"
            
            let prospect = Prospect(talentName: talentName, talentRating: talentRating, talentAccepted: talentAccepted)
            prospect.createProspect(prospect: prospect, projectID: ProjectDetailVC.currentProject, position: positionName, userID: userID)
            performSegue(withIdentifier: "message", sender: nil)
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "" , message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { action in
            self.performSegue(withIdentifier: "unwindToCastingDetail", sender: nil)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "message" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let desVC = segue.destination as! inviteMessageVC
                desVC.inviteeName = talentName
                desVC.auditionID = auditions[indexPath.row].auditionKey
                desVC.inviteeKey = userID
            }
        } /*else if segue.identifier == "unwindToCastingDetail" {
            let desVC = segue.destination as! CastingDetailVC
            desVC.selectedCastPosition = positionName
        }*/
    }

    
    
    
    
    
    
    
    
    
}
