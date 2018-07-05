//
//  NotificationCell.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 7/5/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class NotificationCell: UITableViewCell {
    
    
    @IBOutlet weak var inviterProfileImage: CircleImage!
    @IBOutlet weak var notificationMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(notification: Notifications, img: UIImage? = nil) {
        
        self.notificationMessage.text = "\(notification.message)"
        print("\(notification.inviterProfileImage)")
        //Image Caching
        if img != nil {
            self.inviterProfileImage.image = img
        } else {
            
            let imageURL = notification.inviterProfileImage
                
                let ref = FIRStorage.storage().reference(forURL: imageURL)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("ZACK: Unable to download image from Firebase Storage")
                    } else {
                        print("ZACK: Image downloaded from Firebase Storage")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.inviterProfileImage.image = img
                                SearchTalentVC.userProfileImageCache.setObject(img, forKey: imageURL as NSString)
                            }
                        }
                    }
                })
        }
    }
    

}
