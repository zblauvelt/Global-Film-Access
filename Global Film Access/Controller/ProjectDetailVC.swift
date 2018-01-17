//
//  ProjectDetailVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 1/15/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit

class ProjectDetailVC: UIViewController {

    var selectedProjectKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = selectedProjectKey
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
