//
//  SearchTalentCell.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 2/7/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase



protocol SearchCellDelegate {
    
    func didTapRadioButton(userKey: String, searchSelected: String)
    
}

class SearchTalentCell: UITableViewCell {
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var talentUserName: UILabel!
    @IBOutlet weak var radioButton: UIButton!
    var currntTalent: UserType!
    var delegate: SearchCellDelegate?
    
    func setTalent(talent: UserType) {
        currntTalent = talent
        currntTalent.userKey = talent.userKey
        currntTalent.searchSelected = talent.searchSelected
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func radioButtonTapped(_ sender: Any) {
        delegate?.didTapRadioButton(userKey: currntTalent.userKey, searchSelected: currntTalent.searchSelected!.rawValue)
    }
    
    
    
    
    func configureCell(user: UserType, img: UIImage? = nil) {
        setTalent(talent: user)
        self.talentUserName.text = "\(user.firstName) \(user.lastName)"
        
        user.adjustSearchSelected(talent: user, radioButton: radioButton)
        
        
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
