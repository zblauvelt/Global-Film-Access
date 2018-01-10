//
//  User.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 11/29/17.
//  Copyright © 2017 Zachary Blauvelt. All rights reserved.
//

import Foundation
import Firebase
//this enum should be used for projects
/*enum UserAccessLevel: String {
    case unknown = "Unknown"
    case executiveProducer = "Executive Producer"
    case topTierProducer = "Top Tier Producer"
    case lowTierProducer = "Low Tier Producer"
    case crew = "Crew Member"
    case vendor = "Vendor"
    case talent = "Talent"
}*/

enum Access: String {
    case granted = "true"
    case denied = "false"
}

enum FIRUserData: String {
    case firstName = "firstName"
    case lastName = "lastName"
    case city = "city"
    case state = "state"
    case profileImage = "profileImage"
    case userName = "userName"
    case zipCode = "zipCode"
}

enum CreateUserError: String, Error {
    case invalidFirstName = "Please provide a first name."
    case invalidLastName = "Please provide a last name"
    case invalidCity = "Please provide a city."
    case invalidState = "Please provide a state."
    case invalidZipCode = "Please provide a zip code."
    case invalidProfileImage = "Please provide an image."
    case invalidUserName = "Please provide a username."

    
}
//MARK: The current Firebase User
 let userID = FIRAuth.auth()!.currentUser!.uid

protocol User {
    var firstName: String { get set }
    var lastName: String { get set }
    var city: String { get set }
    var state: USAState { get set }
    var zipCode: String { get set }
    var profileImage: UIImage { get set }
    var userName: String { get set }
    var REF_USERS: FIRDatabaseReference { get }
    var REF_CURRENT_USER: FIRDatabaseReference { get }
    var REF_USER_PROJECTS: FIRDatabaseReference { get }
    var REF_USER_CURRENT_PROJECTS: FIRDatabaseReference { get }
    var REF_USER_ARCHIVE_PROJECTS: FIRDatabaseReference { get }
    var REF_PROFILE_IMAGE: FIRStorageReference { get }
    
    ///Adds user to the Firebase database
    //MARK: Create user for DB
    func createUserDB(firstName: String, lastName: String, city: String, State: USAState, zipCode: String, profileImage: UIImage?) throws
    
    
}

class UserType: User {
    
    var firstName: String
    var lastName: String
    var city: String
    var state: USAState
    var zipCode: String
    var profileImage: UIImage
    var userName: String
    //Firebase database references
   
    var REF_USERS = DB_BASE.child("users")
    var REF_CURRENT_USER = DB_BASE.child("users").child(userID)
    var REF_USER_PROJECTS = DB_BASE.child("users").child(userID).child("userProjects")
    var REF_USER_CURRENT_PROJECTS = DB_BASE.child("users").child(userID).child("currentProjects")
    var REF_USER_ARCHIVE_PROJECTS = DB_BASE.child("users").child(userID).child("archiveProjects")
    var REF_PROFILE_IMAGE = STORAGE_BASE.child("profile-pics")
    
    
    init(firstName: String, lastName: String, city: String, state: USAState, profileImage: UIImage, zipCode: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.profileImage = profileImage
        self.userName = "\(firstName).\(lastName)"
    }
    
    init(userName: String, userData: Dictionary <String, Any>) throws {
        self.userName = userName
        
        if let firstName = userData[FIRUserData.firstName.rawValue] {
            self.firstName = firstName as! String
        } else {
            throw CreateUserError.invalidFirstName
        }
        
        if let lastName = userData[FIRUserData.lastName.rawValue] {
           self.lastName = lastName as! String
        } else {
            throw CreateUserError.invalidLastName
        }
        
        if let city = userData[FIRUserData.city.rawValue] {
            self.city = city as! String
        } else {
            throw CreateUserError.invalidCity
        }
        
        if let state = userData[FIRUserData.state.rawValue] {
            self.state = state as! USAState
        } else {
            throw CreateUserError.invalidState
        }
        
        if let zipCode = userData[FIRUserData.zipCode.rawValue] {
            self.zipCode = zipCode as! String
        } else {
            throw CreateUserError.invalidZipCode
        }
        
        if let profileImage = userData[FIRUserData.profileImage.rawValue] {
            self.profileImage = profileImage as! UIImage
        } else {
            throw CreateUserError.invalidProfileImage
        }
        
    }
    
    func createUserDB(firstName: String, lastName: String, city: String, State: USAState, zipCode: String, profileImage: UIImage?) throws {
        guard firstName != "" else {
            throw CreateUserError.invalidFirstName
        }
        guard lastName != "" else {
            throw CreateUserError.invalidLastName
        }
        guard city != "" else {
            throw CreateUserError.invalidCity
        }
        guard state != .unknown else {
            throw CreateUserError.invalidState
        }
        guard zipCode != "" else {
            throw CreateUserError.invalidZipCode
        }
        guard let img = profileImage else {
            throw CreateUserError.invalidProfileImage
        }
        
        //Save image to profile pics folder in Firebase Storage
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            REF_PROFILE_IMAGE.child(imgUid).put(imgData, metadata: metaData) { (metaData, error) in
                if error != nil {
                    print("ZACK: Unable to upload to Firebase Storage")
                } else {
                    print("ZACK: Successfully uploaded image")
                    let downloadURL = metaData?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        let user: Dictionary<String, String> = [
                            "firstName": firstName,
                            "lastName": lastName,
                            "userName": "\(firstName).\(lastName)",
                            "city": city,
                            "state": self.state.rawValue,
                            "zipCode": zipCode,
                            "profileImageURL": url
                        ]
                        //MARK: Post to Firebase Database
                        self.REF_USERS.setValue(user)
                    }
                }
            }
            
        }
    }
    
 
}

