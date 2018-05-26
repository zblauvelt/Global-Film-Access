//
//  SearchTalentCell.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 2/7/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class SearchTalentCell: UITableViewCell {
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var talentUserName: UILabel!
    
    @IBOutlet weak var radioButton: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(user: UserType, img: UIImage? = nil) {
        self.talentUserName.text = "\(user.firstName) \(user.lastName)"
        
        if let searchSelected = user.searchSelected?.rawValue {
            if searchSelected == SearchSelected.yes.rawValue {
                self.radioButton.image = UIImage(named: "radioSelected")
            } else {
                self.radioButton.image = UIImage(named: "radioUnselected")
            }
        }
        
        
        
        //Image Caching
        if img != nil {
            self.userProfileImage.image = img
        } else {
            
            if let imageURL = user.profileImage {
                
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
    }

}
