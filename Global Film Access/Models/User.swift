//
//  User.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 11/29/17.
//  Copyright © 2017 Zachary Blauvelt. All rights reserved.
//

import Foundation
import Firebase

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
    case invalidEmail = "Please provide a valid email"
    case invalidPassword = "Passwords must be atleast 6 characters, contain one uppercase letter, and one of the following !&^%$#@()/?"
    
}

protocol User {
    var firstName: String { get set }
    var lastName: String { get set }
    var city: String { get set }
    var state: USAState { get set }
    var zipCode: String { get set }
    var profileImage: String { get set }
    var userName: String { get set }
}

class UserType: User {
    var firstName: String
    var lastName: String
    var city: String
    var state: USAState
    var zipCode: String
    var profileImage: String
    var userName: String
    
    init(firstName: String, lastName: String, city: String, state: USAState, profileImage: String, zipCode: String) {
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
            self.profileImage = profileImage as! String
        } else {
            throw CreateUserError.invalidProfileImage
        }
        
    }

    
    
 
}

