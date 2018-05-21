//
//  addRoleVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 5/21/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit

class addRoleVC: UIViewController {

    @IBOutlet weak var roleNameLbl: UITextField!
    @IBOutlet weak var roleTypeLbl: UITextField!
    @IBOutlet weak var shortDescriptionLbl: UITextField!
    @IBOutlet weak var totalBudgetLbl: UILabel!
    @IBOutlet weak var daysNeededLbl: UITextField!
    @IBOutlet weak var dailyRateLbl: UITextField!
    @IBOutlet weak var ageMinimum: UITextField!
    @IBOutlet weak var ageMaximum: UITextField!
    @IBOutlet weak var heightMinFeet: UITextField!
    @IBOutlet weak var heightMinInches: UITextField!
    @IBOutlet weak var heightMaxFeet: UITextField!
    @IBOutlet weak var heightMaxInches: UITextField!
    @IBOutlet weak var ethnicityLbl: UITextField!
    @IBOutlet weak var bodyTypeLbl: UITextField!
    @IBOutlet weak var eyeColorLbl: UITextField!
    @IBOutlet weak var hairColorLbl: UITextField!
    @IBOutlet weak var hairLengthLbl: UITextField!
    @IBOutlet weak var hairTypeLbl: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func saveBtnTapped(_ sender: Any) {
    }
    

}
