//
//  RndButton.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 11/26/17.
//  Copyright © 2017 Zachary Blauvelt. All rights reserved.
//

import UIKit

class RndButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.cornerRadius = 2.0
        
    }
    


}
