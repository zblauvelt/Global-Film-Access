//
//  PreProductionDashboardVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 1/20/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit

class PreProductionDashboardVC: UIViewController {
    
    var selectedProjectID: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        //Remove the title of back button
        print("\(selectedProjectID)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            self.performSegue(withIdentifier: "PreProductionCastingPositions", sender: nil)
        default:
            print("no segue")
        }
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PreProductionCastingPositions" {
            let viewController = segue.destination as! CastPositionsVC
            viewController.projectID = self.selectedProjectID
        }
    }
    
    
    @IBAction func unwindtoPreProductionDashboard(segue: UIStoryboardSegue) {}
    
    

    
    


}
