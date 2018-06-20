//
//  SearchTalentCell.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 2/7/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

protocol SearchTalentCellDelegate: class {
    func radioButtonTapped(_ sender: SearchTalentCell)
}

class SearchTalentCell: UITableViewCell {
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var talentUserName: UILabel!
    @IBOutlet weak var selectedImg: UIImageView!
    @IBOutlet weak var inviteSentImg: UIImageView!
    var prospectRef: FIRDatabaseReference!
    var currentTalent: UserType!
    weak var delegate: SearchTalentCellDelegate?
    
    func setTalent(talent: UserType) {
        currentTalent = talent
        currentTalent.userKey = talent.userKey
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectTapped))
        tap.numberOfTapsRequired = 1
        selectedImg.addGestureRecognizer(tap)
        selectedImg.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configureCell(user: UserType, img: UIImage? = nil) {
        prospectRef = Cast.REF_PRE_PRODUCTION_CASTING_POSITION.child(ProjectDetailVC.currentProject).child(FIRDataCast.prospect.rawValue).child(CastingDetailVC.positionName).child(user.userKey)
        setTalent(talent: user)
        self.talentUserName.text = "\(user.firstName) \(user.lastName)"

        prospectRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.inviteSentImg.isHidden = true
            } else {
                self.inviteSentImg.image = UIImage(named: "inviteSent")
                self.inviteSentImg.isHidden = false
            }
        })
        if UserType.selectedTalentForSearch.contains(currentTalent.userKey) {
            selectedImg.image = UIImage(named: "radioSelected")
            
        } else {
            selectedImg.image = UIImage(named: "radioUnselected")
            
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
    
    @objc func selectTapped(sender: UITapGestureRecognizer) {
        if UserType.selectedTalentForSearch.contains(currentTalent.userKey) {
            selectedImg.image = UIImage(named: "radioUnselected")
            UserType.selectedTalentForSearch = UserType.selectedTalentForSearch.filter{$0 != currentTalent.userKey}
            print("Keys: \(UserType.selectedTalentForSearch)")
            self.delegate?.radioButtonTapped(self)
            
        } else {
            selectedImg.image = UIImage(named: "radioSelected")
            UserType.selectedTalentForSearch.append(currentTalent.userKey)
            print("Keys: \(UserType.selectedTalentForSearch)")
            self.delegate?.radioButtonTapped(self)
        }

        
    }
    
    @objc func selectAllTapped(sender: UIBarButtonItem) {
        //TODO
    }
  
}
