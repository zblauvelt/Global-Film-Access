//
//  CastingDetailCell.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 6/20/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit

class CastingDetailCell: UITableViewCell {

    @IBOutlet weak var profileImg: CircleImage!
    @IBOutlet weak var prospectNameLbl: UILabel!
    @IBOutlet weak var ratingSlider: UISlider!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(prospect: Prospect, img: UIImage? = nil) {

        self.prospectNameLbl.text = "\(prospect.talentName)"
        
        
        //Image Caching
        /*if img != nil {
            self.profileImg.image = img
        } else {
            
            if let imageURL = prospect {
                
                let ref = FIRStorage.storage().reference(forURL: imageURL)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("ZACK: Unable to download image from Firebase Storage")
                    } else {
                        print("ZACK: Image downloaded from Firebase Storage")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.userProfileImage.image = img
                                SearchTalentVC.userProfileImageCache.setObject(img, forKey: imageURL as NSString)
                            }
                        }
                    }
                })
            }
        }
    }*/

}
