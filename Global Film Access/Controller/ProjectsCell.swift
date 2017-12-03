//
//  ProjectsCell.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 12/3/17.
//  Copyright © 2017 Zachary Blauvelt. All rights reserved.
//

import UIKit

class ProjectsCell: UITableViewCell {
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var projectNameLbl: UILabel!
    @IBOutlet weak var projectReleaseDate: UILabel!
    
    var userProject: ProjectDetails!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(userProject: ProjectDetails) {
        self.projectNameLbl.text = userProject.name
        self.projectImage.image = UIImage(named: userProject.image)
        self.projectReleaseDate.text = userProject.date
        
    }

}
