//
//  CircleButton.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 12/6/17.
//  Copyright © 2017 Zachary Blauvelt. All rights reserved.
//

import UIKit

class CircleButton: UIButton {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.cornerRadius = 0.5 * layer.bounds.size.width
        clipsToBounds = true
        
    }
}
