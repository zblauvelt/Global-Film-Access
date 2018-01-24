//
//  Project.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 1/11/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import Foundation
import UIKit
import Firebase

//Project Errors
enum CreateProjectError: String, Error {
    case inValidProjectName = "Please provide a valid name for your project."
    case invalideProjectImage = "Please provide an image for your project."
    case invalidProjectDate = "Please provide a date for your project."
    case invalidProjectAccessLevel = "Please provide a correct access level."
    case duplicateName = "You're already a part of a project with this name. Please give the project a unique name."
}

//Firebase DB References
enum FIRProjectData: String {
    case projectName = "projectName"
    case image = "image"
    case releaseDate = "releaseDate"
    case accessLevel = "accessLevel"
}

//this enum should be used for projects
enum UserAccessLevel: String {
    case unknown = "Unknown"
    case admin = "Admin"
    case executiveProducer = "Executive Producer"
    case topTierProducer = "Top Tier Producer"
    case lowTierProducer = "Low Tier Producer"
    case crew = "Crew Member"
    case vendor = "Vendor"
    case talent = "Talent"
 }

protocol Project {
    var projectName: String { get set }
    var projectImage: String? { get set }
    var projectReleaseDate: String { get set }
    var projectID: String { get set }
    var userAccessLevel: String { get set }
    static var REF_PROJECT: FIRDatabaseReference { get }
    static var REF_PROJECT_IMG_STORAGE: FIRStorageReference { get }
    
    func createProjectDB(project: Project, image: UIImage) throws
    
    
}

class ProjectType: Project {
    
    var projectName: String
    var projectImage: String?
    var projectReleaseDate: String
    var projectID: String = ""
    var userAccessLevel: String = UserAccessLevel.admin.rawValue
    static var REF_PROJECT: FIRDatabaseReference = DB_BASE.child("projects")
    static var REF_PROJECT_IMG_STORAGE: FIRStorageReference = STORAGE_BASE.child("project-pics")
    
    init(projectName: String, projectReleaseDate: String) {
        self.projectName = projectName
        self.projectReleaseDate = projectReleaseDate
    }
    
    init(projectID: String, projectData: Dictionary <String, String>) throws {
        self.projectID = projectID
        
        if let projectName = projectData[FIRProjectData.projectName.rawValue] {
            self.projectName = projectName
        } else {
            throw CreateProjectError.inValidProjectName
        }
        
        if let projectImage = projectData[FIRProjectData.image.rawValue] {
            self.projectImage = projectImage
        } else {
            throw CreateProjectError.invalideProjectImage
        }
        
        if let projectReleaseDate = projectData[FIRProjectData.releaseDate.rawValue] {
            self.projectReleaseDate = projectReleaseDate
        } else {
            throw CreateProjectError.invalidProjectDate
        }
        
    }
    
    
    func createProjectDB(project: Project, image: UIImage) throws {
        guard project.projectName != "" else {
            throw CreateProjectError.inValidProjectName
        }
        
        if ProjectListVC.projectName.contains(project.projectName.lowercased()) {
            throw CreateProjectError.duplicateName
        }
        
        guard project.projectReleaseDate != "" else {
            throw CreateProjectError.invalidProjectDate
        }
        
        let img = image
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            ProjectType.REF_PROJECT_IMG_STORAGE.child(imgUid).put(imgData, metadata: metaData) { (metaData, error) in
                if error != nil {
                    print("ZACK: Unable to upload to Firebase Storage") //TODO: send alert to user
                } else {
                    print("ZACK: Successfully uploaded image")
                    let downloadURL = metaData?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        let project: Dictionary <String, String> = [
                            FIRProjectData.projectName.rawValue: self.projectName,
                            FIRProjectData.releaseDate.rawValue: self.projectReleaseDate,
                            FIRProjectData.image.rawValue: url
                        ]
                        let currentProject: Dictionary <String, String> = [
                            FIRProjectData.projectName.rawValue: self.projectName,
                            FIRProjectData.accessLevel.rawValue: self.userAccessLevel
                        ]
                        
                        let globalProject = ProjectType.REF_PROJECT.childByAutoId()
                        globalProject.setValue(project)
                        
                        UserProjects.REF_USER_CURRENT_PROJECTS.child("\(globalProject.key)").setValue(currentProject)
                        UserProjects.REF_USER_PROJECTS.child("\(globalProject.key)").setValue(currentProject)
                        
                    }
                }
            }
            
        }
    }
}


