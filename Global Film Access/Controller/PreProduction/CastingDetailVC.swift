//
//  CastingDetailVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 2/7/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit

class CastingDetailVC: UIViewController {
    
    var selectedCastPosition: String = ""
    static var positionName: String = ""
    var selectedRole = [Cast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        CastingDetailVC.positionName = selectedCastPosition
        self.title = selectedCastPosition
        print(CastingDetailVC.positionName)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchTalent" {
            let desVC = segue.destination as! SearchTalentVC
            desVC.searchingRole.append(selectedRole[0])
        }
    }



}
