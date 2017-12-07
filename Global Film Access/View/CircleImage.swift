//
//  CircleImage.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 12/4/17.
//  Copyright © 2017 Zachary Blauvelt. All rights reserved.
//

import UIKit

class CircleImage: UIImageView {

    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }

}
