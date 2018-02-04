//
//  ProjectDetailVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 1/15/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit

class ProjectDetailVC: UIViewController {

    var selectedProjectName = ""
    var selectProjectID = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Customize Navbar
        self.navigationItem.title = selectedProjectName
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:.plain, target: nil, action: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPreProductionDashboard" {
            let viewController = segue.destination as! PreProductionDashboardVC
            viewController.selectedProjectID = self.selectProjectID
        }
    }
    

}
