//
//  CreateProjectVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 12/6/17.
//  Copyright © 2017 Zachary Blauvelt. All rights reserved.
//

import UIKit

class CreateProjectVC: UIViewController {
    @IBOutlet weak var containerView: CustomView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.transform = CGAffineTransform.init(scaleX: 0, y:0)
    }
  
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform.identity
        })
    }



}
