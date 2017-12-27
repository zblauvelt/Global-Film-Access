//
//  ArchiveProjectCell.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 12/26/17.
//  Copyright © 2017 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class ArchiveProjectCell: UITableViewCell {
    
    @IBOutlet weak var archiveProjectImage: UIImageView!
    @IBOutlet weak var acrchiveNameLbl: UILabel!
    @IBOutlet weak var archiveDateLbl: UILabel!
    
    //var archiveProject: ProjectDetails!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(userProject: ProjectDetails, img: UIImage? = nil) {
        self.acrchiveNameLbl.text = userProject.name
        self.archiveDateLbl.text = userProject.date
        
        //Image Caching
        if img != nil {
            self.archiveProjectImage.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: userProject.image)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("ZACK: Unable to download image from Firebase Storage")
                } else {
                    print("ZACK: Image downloaded from Firebase Storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.archiveProjectImage.image = img
                            ArchiveProjectsVC.archiveImageCache.setObject(img, forKey: userProject.image as NSString)
                        }
                    }
                }
            })
            
        }
    }

}
