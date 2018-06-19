//
//  CastPositionsVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 2/1/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class CastPositionsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var positionName: String = ""
    //For editing Role
    var roleNameID: String = ""
    var projectID: String = ""
    var castingPostions = [Cast]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getCastingPositions()
        
    }
    
    
    //MARK: Table Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return castingPostions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier =  "castPositionCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = castingPostions[indexPath.row].roleName
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            self.deletePosition(indexPath: indexPath)
            
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            self.roleNameID = self.castingPostions[indexPath.row].roleName
            print("Role ID Name: \(self.roleNameID)")
            self.performSegue(withIdentifier: "updateRole", sender: nil)
        }
        delete.backgroundColor = UIColor.red
        edit.backgroundColor = UIColor.blue
        return [delete, edit]
        
    }

    //MARK: add a position row
    @IBAction func addPositionTapped(_ sender: Any) {}
    
    
    //MARK: Get the Positions for project
    func getCastingPositions() {
        Cast.REF_PRE_PRODUCTION_CASTING_POSITION.child(projectID).child(FIRDataCast.cast.rawValue).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                Cast.createdRoles.removeAll()
                self.castingPostions.removeAll()
                for snap in snapshot {
                    print("SNAP:\(snap)")
                    
                    if let positionDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let position = Cast(roleName: key, roleData: positionDict)
                        self.castingPostions.append(position)
                        Cast.createdRoles.append(position.roleName.lowercased())
                    }
                }
                
            }
            self.tableView.reloadData()
        })
    }
    
    
    
    //MARK: Delete a cast row
    func deletePosition(indexPath: IndexPath) {
        //1. Create the alert controller.
        let alertController = UIAlertController(title: "Warning", message: "Please type the word DELETE in all capital letters to confirm you want to delete this position. By doing so all information will be deleted related to this position.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { alert -> Void in
            return
        }))
        
        alertController.addAction(UIAlertAction(title: "Delete", style: .default, handler: { alert -> Void in
            let deleteField = alertController.textFields![0] as UITextField
            
            if deleteField.text == "DELETE" {
                Cast.REF_PRE_PRODUCTION_CASTING_POSITION.child(self.projectID).child(self.castingPostions[indexPath.row].roleName).removeValue()
                return
            } else {
                let alertController = UIAlertController(title: "" , message: "Position was not deleted. Please make sure you spell DELETE in all capital letters.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel) { action in
                    return
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }))
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "DELETE"
            textField.textAlignment = .center
        })
        
        // 4. Present the alert.
        self.present(alertController, animated: true, completion: nil)
        self.getCastingPositions()
    }
    
    //MARK: Passing cast selected to Cast Detail vc
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "goToCast":
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! CastingDetailVC
                destinationController.selectedCastPosition = castingPostions[indexPath.row].roleName
                destinationController.selectedRole.append(castingPostions[indexPath.row])
            }
        case "updateRole":
                let nav = segue.destination as! UINavigationController
                let destinationController = nav.topViewController as! addRoleVC
                destinationController.roleNameID = self.roleNameID
                destinationController.update = true
        case "addRole":
                let nav = segue.destination as! UINavigationController
                let destinationController = nav.topViewController as! addRoleVC
                destinationController.update = false
            
        default:
            print("no segue")
        }
    }
    
    @IBAction func cancelAddRole(segue: UIStoryboardSegue) {}
}
