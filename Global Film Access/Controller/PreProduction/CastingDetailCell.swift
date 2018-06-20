//
//  CastingDetailCell.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 6/20/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class CastingDetailCell: UITableViewCell {

    @IBOutlet weak var profileImg: CircleImage!
    @IBOutlet weak var prospectNameLbl: UILabel!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var ratingLbl: UILabel!
    let step: Float = 1
    
    var currentProspect: Prospect!
    
    func setProspect(prospect: Prospect) {
        currentProspect = prospect
        currentProspect.prospectID = prospect.prospectID
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ratingSlider.minimumValue = 1
        ratingSlider.maximumValue = 10
        ratingSlider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(prospect: Prospect, img: UIImage? = nil) {

        self.prospectNameLbl.text = "\(prospect.talentName)"
        
        if let sliderValue = Float(prospect.talentRating) {
            self.ratingSlider.value = sliderValue
            self.ratingLbl.text = "Rating: \(Int(sliderValue))"
        } else {
            ratingSlider.value = 1.0
            self.ratingLbl.text = "Rating: 1"
        }
        self.setProspect(prospect: prospect)
        
        //Image Caching
        if img != nil {
            self.profileImg.image = img
        } else {
            
            if let imageURL = prospect.talentProfileImage {
                
                let ref = FIRStorage.storage().reference(forURL: imageURL)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("ZACK: Unable to download image from Firebase Storage")
                    } else {
                        print("ZACK: Image downloaded from Firebase Storage")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.profileImg.image = img
                                SearchTalentVC.userProfileImageCache.setObject(img, forKey: imageURL as NSString)
                            }
                        }
                    }
                })
            }
        }
    }
    
    @objc func sliderValueDidChange(_ sender: UISlider) {
        print("value changed")
        let roundedStepValue = round(sender.value / step) * step
        sender.value = roundedStepValue
        print("Slider step value \(Int(roundedStepValue))")
        
        let prospectRatingUpdate: Dictionary<String, String> = [
            FIRRoleData.talentRating.rawValue: "\(roundedStepValue)"
        ]
        Cast.REF_PRE_PRODUCTION_CASTING_POSITION.child(ProjectDetailVC.currentProject).child(FIRDataCast.prospect.rawValue).child(CastingDetailVC.positionName).child(currentProspect.prospectID).updateChildValues(prospectRatingUpdate)
        self.ratingLbl.text = "Rating: \(Int(roundedStepValue))"
    }
    
}
