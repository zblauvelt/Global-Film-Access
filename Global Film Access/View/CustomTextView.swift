//
//  CustomTextView.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 5/23/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {

    override func awakeFromNib() {
        super.awakeFromNib()
        let color = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
        layer.borderColor = color
        layer.borderWidth = 0.5
        layer.cornerRadius = 5

        
    }
    


}
