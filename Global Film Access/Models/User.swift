//
//  User.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 11/29/17.
//  Copyright © 2017 Zachary Blauvelt. All rights reserved.
//

import Foundation
import Firebase


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
    case agentName = "agentName"
    case agentNumber = "agentNumber"
    case managerName = "managerName"
    case managerNumber = "managerNumber"
    case legalName = "legalName"
    case legalNumber = "legalNumber"
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
    var state: String { get set }
    var zipCode: String { get set }
    var profileImage: String? { get set }
    var userName: String { get set }
    var userKey: String { get set }
    static var REF_USERS: FIRDatabaseReference { get }
    static var REF_CURRENT_USER: FIRDatabaseReference { get }
    static var REF_PROFILE_IMAGE: FIRStorageReference { get }
    
    ///Adds user to the Firebase database
    //MARK: Create user for DB
    func createUserDB(user: User, userImage: UIImage) throws
    
    
}

class UserType: User {
    
    var firstName: String
    var lastName: String
    var city: String
    var state: String
    var zipCode: String
    var profileImage: String?
    var userName: String
    var userKey: String = ""
    var agentName: String?
    var agentNumber: String?
    var managerName: String?
    var managerNumber: String?
    var legalName: String?
    var legalNumber: String?
    
    //Firebase database references
    static var REF_USERS = DB_BASE.child("users").child("allUsers")
    static var REF_CURRENT_USER = DB_BASE.child("users").child(userID)
    static var REF_CURRENT_USER_DETAILS = DB_BASE.child("users").child("details")
    static var REF_PROFILE_IMAGE = STORAGE_BASE.child("profile-pics")
    
    
    init(firstName: String, lastName: String, city: String, state: String, zipCode: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.userName = "\(firstName).\(lastName)"
        
    }
    
    init(userKey: String, userData: Dictionary <String, String>) {
        self.userKey = userKey
        
        if let firstName = userData[FIRUserData.firstName.rawValue] {
            self.firstName = firstName
        } else {
            self.firstName = ""
        }
        
        if let lastName = userData[FIRUserData.lastName.rawValue] {
           self.lastName = lastName
        } else {
            self.lastName = ""
        }
        
        if let city = userData[FIRUserData.city.rawValue] {
            self.city = city
        } else {
            self.city = ""
        }
        
        if let state = userData[FIRUserData.state.rawValue] {
            self.state = state
        } else {
            self.state = ""
        }
        
        if let zipCode = userData[FIRUserData.zipCode.rawValue] {
            self.zipCode = zipCode
        } else {
            self.zipCode = ""
        }
        
        if let userName = userData[FIRUserData.userName.rawValue] {
            self.userName = userName
        } else {
            self.userName = ""
        }
        
        if let profileImage = userData[FIRUserData.profileImage.rawValue] {
            self.profileImage = profileImage
        } else {
            self.profileImage = ""
        }
        
        if let agentName = userData[FIRUserData.agentName.rawValue] {
            self.agentName = agentName
        } else {
            self.agentName = "Agent Name"
        }
        
        if let agentNumber = userData[FIRUserData.agentNumber.rawValue] {
            self.agentNumber = agentNumber
        } else {
            self.agentNumber = "(xxx) xxx-xxxx"
        }
        
        if let managerName = userData[FIRUserData.managerName.rawValue] {
            self.managerName = managerName
        } else {
            self.managerName = "Manager Name"
        }
        
        if let managerNumber = userData[FIRUserData.managerNumber.rawValue] {
            self.managerNumber = managerNumber
        } else {
            self.managerNumber = "(xxx) xxx-xxxx"
        }
        
        if let legalName = userData[FIRUserData.legalName.rawValue] {
            self.legalName = legalName
        } else {
            self.legalName = "Legal Name"
        }
        
        if let legalNumber = userData[FIRUserData.legalNumber.rawValue] {
            self.legalNumber = legalNumber
        } else {
            self.legalNumber = "(xxx) xxx-xxxx"
        }
        
    }
    
    func createUserDB(user: User, userImage: UIImage) throws {
        guard user.firstName != "" else {
            throw CreateUserError.invalidFirstName
        }
        guard user.lastName != "" else {
            throw CreateUserError.invalidLastName
        }
        guard user.city != "" else {
            throw CreateUserError.invalidCity
        }
        guard user.state != "" else {
            throw CreateUserError.invalidState
        }
        guard user.zipCode != "" else {
            throw CreateUserError.invalidZipCode
        }
        
        let img = userImage
        
        //Save image to profile pics folder in Firebase Storage
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            UserType.REF_PROFILE_IMAGE.child(imgUid).put(imgData, metadata: metaData) { (metaData, error) in
                if error != nil {
                    print("ZACK: Unable to upload to Firebase Storage")
                } else {
                    print("ZACK: Successfully uploaded image")
                    let downloadURL = metaData?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        let newUser: Dictionary<String, String> = [
                            FIRUserData.firstName.rawValue: user.firstName,
                            FIRUserData.lastName.rawValue: user.lastName,
                            FIRUserData.userName.rawValue: "\(user.firstName).\(user.lastName)",
                            FIRUserData.city.rawValue: user.city,
                            FIRUserData.state.rawValue: user.state,
                            FIRUserData.zipCode.rawValue: user.zipCode,
                            FIRUserData.profileImage.rawValue: url,
                        ]
                        
                        let newAllUser: Dictionary<String, String> = [
                            FIRUserData.firstName.rawValue: user.firstName,
                            FIRUserData.lastName.rawValue: user.lastName,
                            FIRUserData.profileImage.rawValue: url
                        ]
                       
                        //MARK: Post to Firebase Database
                        UserType.REF_CURRENT_USER_DETAILS.child(userID).setValue(newUser)
                        UserType.REF_USERS.child(userID).setValue(newAllUser)
                    }
                }
            }
            
        }
    }
    
 
}

