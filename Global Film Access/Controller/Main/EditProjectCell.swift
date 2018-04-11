//
//  EditProjectCell.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 4/5/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit

class EditProjectCell: UITableViewCell {

    @IBOutlet weak var auditionDescription: UILabel!
    @IBOutlet weak var auditionTime: UILabel!
    @IBOutlet weak var auditionDate: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var initialLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureAuditionCell(audition: Auditions) {
        self.auditionDescription.text = audition.description
        self.auditionTime.text = "\(audition.startTime) to \(audition.endTime)"
        self.auditionDate.text = audition.day
        self.address.text = audition.address
        
        let str = audition.description.uppercased()
        let index = str.index(str.startIndex, offsetBy: 0)
        self.initialLbl.text = "\(str[index])"
    }
    

}
