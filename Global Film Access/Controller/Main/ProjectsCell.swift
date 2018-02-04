//
//  ProjectsCell.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 12/3/17.
//  Copyright © 2017 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class ProjectsCell: UITableViewCell {
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var projectNameLbl: UILabel!
    @IBOutlet weak var projectReleaseDate: UILabel!
    
    //var userProject: ProjectDetails!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(userProject: ProjectType, img: UIImage? = nil) {
        self.projectNameLbl.text = userProject.projectName
        self.projectReleaseDate.text = userProject.projectReleaseDate
        
        //Image Caching
        if img != nil {
            self.projectImage.image = img
        } else {
            
            if let imageURL = userProject.projectImage {
                
                let ref = FIRStorage.storage().reference(forURL: imageURL)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("ZACK: Unable to download image from Firebase Storage")
                    } else {
                        print("ZACK: Image downloaded from Firebase Storage")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.projectImage.image = img
                                ProjectListVC.imageCache.setObject(img, forKey: imageURL as NSString)
                            }
                        }
                    }
                })
            } 
        }
    }

}
