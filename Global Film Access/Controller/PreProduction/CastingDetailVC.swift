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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        CastingDetailVC.positionName = selectedCastPosition
    }

    



}
