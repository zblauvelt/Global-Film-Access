//
//  ProjectsTabBar.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 11/28/17.
//  Copyright © 2017 Zachary Blauvelt. All rights reserved.
//

import UIKit

class ProjectsTabBar: UITabBarController {
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding button to Project tab bar
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "AddButton2"), for: .normal)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        
        view.addSubview(button)
        tabBar.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        tabBar.topAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        UITabBar.appearance().tintColor = UIColor(red: 25.0/255.0, green: 29.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        UITabBar.appearance().barTintColor = UIColor.white
    }
    
    @objc func buttonAction(sender: UIButton) {
        //TODO: Add segue here.
    }
    

}
