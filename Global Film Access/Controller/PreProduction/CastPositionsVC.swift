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
        
        cell.textLabel?.text = castingPostions[indexPath.row].positionName
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            self.deletePosition(indexPath: indexPath)
            
        }
        delete.backgroundColor = UIColor.red
        return [delete]
        
    }

    //MARK: add a position row
    @IBAction func addPositionTapped(_ sender: Any) {
        //1. Create the alert controller.
        /*let alertController = UIAlertController(title: "Add Position", message: "Enter a name of your new cast member.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { alert -> Void in
            return
        }))
        
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let positionNameField = alertController.textFields![0] as UITextField
            
            if let castName = positionNameField.text {
                
                let createCastName = Cast()
                
                if castName == "" {
                    
                    let alertController = UIAlertController(title: "" , message: "Please provide a valid name.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .cancel) { action in
                        return
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                } else if Cast.createdPositions.contains(castName.lowercased()) {
                    
                    let alertController = UIAlertController(title: "" , message: "You have already created a position with this name. Please create a different position.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .cancel) { action in
                        return
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                } else {
                    try! createCastName.createPosition(projectID: self.projectID, positionName: castName)
                }
            }
            
        }))
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Position Name"
            textField.textAlignment = .center
        })
        
        // 4. Present the alert.
        self.present(alertController, animated: true, completion: nil)*/
    }
    
    
    //MARK: Get the Positions for project
    func getCastingPositions() {
        Cast.REF_PRE_PRODUCTION_CASTING_POSITION.child(projectID).child(FIRDataCast.cast.rawValue).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                Cast.createdPositions.removeAll()
                self.castingPostions.removeAll()
                for snap in snapshot {
                    print("SNAP:\(snap)")
                    
                    if let positionDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let position = Cast(positionName: key, positionData: positionDict)
                        self.castingPostions.append(position)
                        Cast.createdPositions.append(position.positionName.lowercased())
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
                Cast.REF_PRE_PRODUCTION_CASTING_POSITION.child(self.projectID).child(self.castingPostions[indexPath.row].positionName).removeValue()
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
        if segue.identifier == "goToCast" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! CastingDetailVC
                destinationController.selectedCastPosition = castingPostions[indexPath.row].positionName
            }
        }
    }
    
}
