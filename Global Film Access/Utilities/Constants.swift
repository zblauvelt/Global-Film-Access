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



/// Making Navigation Bar Transparent
func transparentNavBar(viewController: UIViewController) {
    viewController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    viewController.navigationController?.navigationBar.shadowImage = UIImage()
    viewController.navigationController?.navigationBar.isTranslucent = true
}


extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}


extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}



extension BinaryInteger{
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}


