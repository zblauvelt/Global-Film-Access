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
import CoreLocation

//Project Errors
enum CreateProjectError: String, Error {
    case inValidProjectName = "Please provide a valid name for your project."
    case invalideProjectImage = "Please provide an image for your project."
    case invalidProjectDate = "Please provide a date for your project."
    case invalidProjectAccessLevel = "Please provide a correct access level."
    case duplicateName = "You're already a part of a project with this name. Please give the project a unique name."
    case invalidAccessCode = "Please provide a valid access code."
    case invalidProductionCompany = "Please provide a valid Production Company."
}

//Firebase DB References
enum FIRProjectData: String {
    case projectName = "projectName"
    case image = "image"
    case releaseDate = "releaseDate"
    case accessLevel = "accessLevel"
    case accessCode = "accessCode"
    case productionCompany = "productionCompany"
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
    var projectAccessCode: String { get set }
    var projectID: String { get set }
    var userAccessLevel: String { get set }
    static var REF_PROJECT: FIRDatabaseReference { get }
    static var REF_PROJECT_IMG_STORAGE: FIRStorageReference { get }
    
    func createProjectDB(project: ProjectType, image: UIImage) throws
    
    
}

class ProjectType: Project {
    
    
    var projectName: String
    var projectImage: String?
    var projectReleaseDate: String
    var projectAccessCode: String
    var projectID: String = ""
    var productionCompany: String
    var userAccessLevel: String = UserAccessLevel.admin.rawValue
    static var REF_PROJECT: FIRDatabaseReference = DB_BASE.child("projects")
    static var REF_PROJECT_IMG_STORAGE: FIRStorageReference = STORAGE_BASE.child("project-pics")
    
    init(projectName: String, projectReleaseDate: String, projectAccessCode: String, productionCompany: String) {
        self.projectName = projectName
        self.projectReleaseDate = projectReleaseDate
        self.projectAccessCode = projectAccessCode
        self.productionCompany = productionCompany
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
        
        if let projectAccessCode = projectData[FIRProjectData.accessCode.rawValue] {
            self.projectAccessCode = projectAccessCode
        } else {
            throw CreateProjectError.invalidAccessCode
        }
        
        if let productionCompany = projectData[FIRProjectData.productionCompany.rawValue] {
            self.productionCompany = productionCompany
        } else {
            throw CreateProjectError.invalidProductionCompany
        }
        
    }
    
    
    func createProjectDB(project: ProjectType, image: UIImage) throws {
        guard project.projectName != "" else {
            throw CreateProjectError.inValidProjectName
        }
        
        if ProjectListVC.projectName.contains(project.projectName.lowercased()) {
            throw CreateProjectError.duplicateName
        }
        
        guard project.projectReleaseDate != "" else {
            throw CreateProjectError.invalidProjectDate
        }
        
        guard project.productionCompany != "" else {
            throw CreateProjectError.invalidProductionCompany
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
                            FIRProjectData.accessCode.rawValue: self.projectAccessCode,
                            FIRProjectData.productionCompany.rawValue: self.productionCompany,
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
    
    func updateProject(project: ProjectType, image: UIImage, projectID: String, currentProjectName: String, imageChanged: Bool) throws {
        guard project.projectName != "" else {
            throw CreateProjectError.inValidProjectName
        }
        
        if project.projectName.lowercased() != currentProjectName {
            if ProjectListVC.projectName.contains(project.projectName.lowercased()) {
                throw CreateProjectError.duplicateName
            }
        }
        
        guard project.projectReleaseDate != "" else {
            throw CreateProjectError.invalidProjectDate
        }
        
        guard project.productionCompany != "" else {
            throw CreateProjectError.invalidProductionCompany
        }
        
        if imageChanged {
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
                            let Globalproject: Dictionary <String, String> = [
                                FIRProjectData.projectName.rawValue: self.projectName,
                                FIRProjectData.releaseDate.rawValue: self.projectReleaseDate,
                                FIRProjectData.accessCode.rawValue: self.projectAccessCode,
                                FIRProjectData.productionCompany.rawValue: self.productionCompany,
                                FIRProjectData.image.rawValue: url
                            ]
                            let currentProject: Dictionary <String, String> = [
                                FIRProjectData.projectName.rawValue: self.projectName,
                                FIRProjectData.accessLevel.rawValue: self.userAccessLevel
                            ]
                            
                            ProjectType.REF_PROJECT.child(projectID).updateChildValues(Globalproject)
                            UserProjects.REF_USER_CURRENT_PROJECTS.child("\(projectID)").updateChildValues(currentProject)
                            UserProjects.REF_USER_PROJECTS.child("\(projectID)").updateChildValues(currentProject)
                            
                        }
                    }
                }
            }
        } else {
            let Globalproject: Dictionary <String, String> = [
                FIRProjectData.projectName.rawValue: self.projectName,
                FIRProjectData.releaseDate.rawValue: self.projectReleaseDate,
                FIRProjectData.accessCode.rawValue: self.projectAccessCode
            ]
            let currentProject: Dictionary <String, String> = [
                FIRProjectData.projectName.rawValue: self.projectName,
                FIRProjectData.accessLevel.rawValue: self.userAccessLevel
            ]
            
            ProjectType.REF_PROJECT.child(projectID).updateChildValues(Globalproject)
            UserProjects.REF_USER_CURRENT_PROJECTS.child("\(projectID)").updateChildValues(currentProject)
            UserProjects.REF_USER_PROJECTS.child("\(projectID)").updateChildValues(currentProject)
        }
    }
}

enum FIRDataAuditions: String {
    case day = "day"
    case description = "description"
    case startTime = "startTime"
    case endTime = "endTime"
    case longitude = "longitude"
    case latitude = "latitude"
    case address = "address"
    case notes = "notes"
}

enum CreateAudtionError: String, Error {
    case invalideDescription = "Please provide a valid description."
    case invalidStartTime = "Please provide a valid start time."
    case invalideEndTime = "Please provide a valid end time."
    case invalidDay = "Please provide a valid day."
    case invalidAddress = "Please provide a valid address."
}

class Auditions {
    var description: String
    var startTime: String
    var endTime: String
    var day: String
    var address: String
    var auditionKey: String = ""
    var notes: String
    var longitude: String?
    var newLongitude = 0.0
    var latitude: String?
    var newLatitude = 0.0
    static var REF_AUDTIONS: FIRDatabaseReference = DB_BASE.child("auditions")
    
    lazy var geoCoder = CLGeocoder()
    
    init(description: String, startTime: String, endTime: String, day: String, address: String, notes: String) {
        self.description = description
        self.startTime = startTime
        self.endTime = endTime
        self.day = day
        self.address = address
        
        if notes == "" {
            self.notes = "No notes available"
        } else {
            self.notes = notes
        }
    }
    
    init(auditionKey: String, auditionData: Dictionary<String, String>) {
        self.auditionKey = auditionKey
        
        if let description = auditionData[FIRDataAuditions.description.rawValue] {
            self.description = description
        } else {
            self.description = "No description specified."
        }
        
        if let startTime = auditionData[FIRDataAuditions.startTime.rawValue] {
            self.startTime = startTime
        } else {
            self.startTime = "N/A"
        }
        
        if let endTime = auditionData[FIRDataAuditions.endTime.rawValue] {
            self.endTime = endTime
        } else{
            self.endTime = "N/A"
        }
        
        if let day = auditionData[FIRDataAuditions.day.rawValue] {
            self.day = day
        } else {
            self.day = "N/A"
        }
        
        if let notes = auditionData[FIRDataAuditions.notes.rawValue] {
            self.notes = notes
        } else{
            self.notes = "No notes available."
        }
        
        if let longitude = auditionData[FIRDataAuditions.longitude.rawValue] {
            self.longitude = longitude
        } else {
            self.longitude = "N/A"
        }
        
        if let latitude = auditionData[FIRDataAuditions.latitude.rawValue] {
            self.latitude = latitude
        } else {
            self.latitude = "N/A"
        }
        
        if let address = auditionData[FIRDataAuditions.address.rawValue] {
            self.address = address
        } else {
            self.address = "N/A"
        }
    }
    
    
    func createAuditionDB(audition: Auditions, projectID: String, auditionKey: String, isEditing: Bool) throws {
        guard audition.description != "" else {
            throw CreateAudtionError.invalideDescription
        }
        
        guard audition.day != "" else {
            throw CreateAudtionError.invalidDay
        }
        
        guard audition.startTime != "" else {
            throw CreateAudtionError.invalidStartTime
        }
        
        guard audition.endTime != "" else {
            throw CreateAudtionError.invalideEndTime
        }
        
        guard audition.address != "" else {
            throw CreateAudtionError.invalidAddress
        }
        
        
        
        let address = audition.address
        
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
            
            let newAudtion: Dictionary<String, String> = [
                FIRDataAuditions.description.rawValue: audition.description,
                FIRDataAuditions.day.rawValue: audition.day,
                FIRDataAuditions.startTime.rawValue: audition.startTime,
                FIRDataAuditions.endTime.rawValue: audition.endTime,
                FIRDataAuditions.address.rawValue: audition.address,
                FIRDataAuditions.notes.rawValue: audition.notes,
                FIRDataAuditions.latitude.rawValue: "\(self.newLatitude)",
                FIRDataAuditions.longitude.rawValue: "\(self.newLongitude)"
            ]
            
            if isEditing {
                Auditions.REF_AUDTIONS.child(projectID).child(auditionKey).updateChildValues(newAudtion)
            } else {
                Auditions.REF_AUDTIONS.child(projectID).childByAutoId().updateChildValues(newAudtion)
            }
            

        }
        
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
        } else {
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                newLatitude = coordinate.latitude
                newLongitude = coordinate.longitude
                print("LONGITUDE: \(newLongitude) LATITUDE: \(newLatitude)")
            } else {
                print("No Matching Location Found.")
            }
        }
    }
    

    
    
}























