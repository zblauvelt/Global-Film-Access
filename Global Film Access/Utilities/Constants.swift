//
//  Constants.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 11/26/17.
//  Copyright © 2017 Zachary Blauvelt. All rights reserved.
//


import UIKit
import Firebase


let SHADOW_GRAY: CGFloat = 120.0/255

let userID = FIRAuth.auth()!.currentUser!.uid

/// Making Navigation Bar Transparent
func transparentNavBar(viewController: UIViewController) {
    viewController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    viewController.navigationController?.navigationBar.shadowImage = UIImage()
    viewController.navigationController?.navigationBar.isTranslucent = true
}


