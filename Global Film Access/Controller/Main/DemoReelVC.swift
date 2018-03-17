//
//  DemoReelVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 3/15/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit

class DemoReelVC: UIViewController {
    
    var chosenVideoID = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("CHOSEN ID: \(chosenVideoID)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
