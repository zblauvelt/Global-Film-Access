//
//  Employees.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 1/29/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import Foundation
import Firebase

enum CreatePositionError: String, Error {
    case invalidPositionName = "Please provide a valid project"
    case invalidProjectName = "Please provide a valid position name."
    case duplicatePosition = "You have already created a position with this name. Please create a different position."
    case invalidRoleType = "Please provide a valid Role Type."
    case invalidShortDescription = "Please provide a short description of the role."
    case invalidDaysNeeded = "Please provide the amount of days this cast member will be needed."
    case invalidDailyRate = "Please provide a valid Daily Rate for this cast member."
    case invalidMinAge = "Please provide a valid minimum age requirement."
    case invalidMaxAge = "Please provide a valid maximum age requirment."
    case invalidMinHeight = "Please provide a valid minimum height requirement."
    case invalidMaxHeight = "Please provide a valid maximum height requirement."
    case invalidBodyType = "Please provide a valid Body Type."
    case invalidEyeColor = "Please provide a valid eye color."
    case invalidHairColor = "Please provide a valid hair color."
    case invalidHairLength = "Please provide a valid hair length."
    case invalidHairType = "Please provide a valid hair type."
}

enum FIRPositionData: String {
    case positionName = "positionName"
    case talentName = "talentName"
    case talentRating = "talentRating"
    case talentAccepted = "talentAccepted"
    case heightMin = "heightMin"
    case heightMax = "heightMax"
    case ageMin = "ageMin"
    case ageMax = "ageMax"
    case bodyType = "bodyType"
    case ethnicity = "ethnicity"
    case eyeColor = "eyeColor"
    case hairColor = "hairColor"
    case hairLength = "hairLength"
    case hairType = "hairType"
}

enum RoleEthnicity: String {
    case na = "N/A"
    case americanIndianAlaskanNative = "American Indian or Alaska Native"
    case asian = "Asian"
    case blackAfricanAmerican = "Black or African American"
    case hispanicLatino = "Hispanic or Latino"
    case nativeHawaiianPacificIslander = "Native Hawaiian or Other Pacific Islander"
    case white = "White"
}

enum RoleBodyType: String {
    case na = "N/A"
    case thin = "Thin"
    case athletic = "Athletic"
    case overweight = "Overweight"
    case obese = "Obese"
}

enum RoleEyeColor: String {
    case na = "N/A"
    case amber = "Amber"
    case blue = "Blue"
    case brown = "Brown"
    case gray = "Gray"
    case green = "Green"
    case hazel = "Hazel"
}

enum RoleHairColor: String {
    case na = "N/A"
    case blonde = "Blonde"
    case brown = "Brown"
    case black = "Black"
    case red = "Red"
    case strawberryblonde = "Strawberry Blonde"
    case pink = "Pink"
    case purple = "Purple"
    case other = "Other"
}

enum RoleHairLength: String {
    case na = "N/A"
    case short = "Short"
    case medium = "Medium"
    case long = "Long"
}

enum RoleHairType: String {
    case na = "N/A"
    case straight =  "Straight"
    case wavy = "Wavy"
    case curly = "Curly"
}




//MARK: Pre-Production

protocol Position {
    var positionName: String { get set }
    static var createdPositions: [String] { get set }
    static var REF_PRE_PRODUCTION_CASTING_POSITION: FIRDatabaseReference { get }
    
}

enum FIRDataCast: String {
    case cast = "cast"

}


class Cast: Position {
    
    var positionName: String = ""
    static var createdPositions = [String]()
    var heightMin: String
    var heightMax: String
    var ageMin: String
    var ageMax: String
    var bodyType: RoleBodyType?
    var ethnicity: RoleEthnicity?
    var eyeColor: RoleEyeColor?
    var hairColor: RoleHairColor?
    var hairLength: RoleHairLength?
    var hairType: RoleHairType?
    
    static var REF_PRE_PRODUCTION_CASTING_POSITION: FIRDatabaseReference = DB_BASE.child("preProductionCasting")
    
    init(heightMin: String, heightMax: String, ageMin: String, ageMax: String, bodyType: RoleBodyType, ethnicity: RoleEthnicity, eyeColor: RoleEyeColor, hairColor: RoleHairColor, hairLength: RoleHairLength, hairType: RoleHairType) {
        self.heightMin = heightMin
        self.heightMax = heightMax
        self.ageMin = ageMin
        self.ageMax = ageMax
        self.bodyType = bodyType
        self.ethnicity = ethnicity
        self.eyeColor = eyeColor
        self.hairColor = hairColor
        self.hairLength = hairLength
        self.hairType = hairType
    }
    
    //init for positions
    init(positionName: String, positionData: Dictionary <String, String>) {
        self.positionName = positionName
        
        if let positionName = positionData[FIRPositionData.positionName.rawValue] {
            self.positionName = positionName
        } else {
            self.positionName = ""
        }
        
        if let heightMin = positionData[FIRPositionData.heightMin.rawValue] {
            self.heightMin = heightMin
        } else {
            self.heightMin = ""
        }
        
        if let heightMax = positionData[FIRPositionData.heightMax.rawValue] {
            self.heightMax = heightMax
        } else {
            self.heightMax = ""
        }
        
        if let ageMin = positionData[FIRPositionData.ageMin.rawValue] {
            self.ageMin = ageMin
        } else {
            self.ageMin = ""
        }
        
        if let ageMax = positionData[FIRPositionData.ageMax.rawValue] {
            self.ageMax = ageMax
        } else {
            self.ageMax = ""
        }
        
        if let bodyType = positionData[FIRPositionData.bodyType.rawValue] {
            self.bodyType = RoleBodyType(rawValue: bodyType)
        } else {
            self.bodyType = RoleBodyType(rawValue: "")
        }
        
        if let ethnicity = positionData[FIRPositionData.ethnicity.rawValue] {
            self.ethnicity = RoleEthnicity(rawValue: ethnicity)
        } else {
            self.ethnicity = RoleEthnicity(rawValue: "")
        }
        
        if let eyeColor = positionData[FIRPositionData.eyeColor.rawValue] {
            self.eyeColor = RoleEyeColor(rawValue: eyeColor)
        } else {
            self.eyeColor = RoleEyeColor(rawValue: "")
        }

        if let hairColor = positionData[FIRPositionData.hairColor.rawValue] {
            self.hairColor = RoleHairColor(rawValue: hairColor)
        } else {
            self.hairColor = RoleHairColor(rawValue: "")
        }
        
        if let hairLength = positionData[FIRPositionData.hairLength.rawValue] {
            self.hairLength = RoleHairLength(rawValue: hairLength)
        } else {
            self.hairLength = RoleHairLength(rawValue: "")
        }
        
        if let hairType = positionData[FIRPositionData.hairType.rawValue] {
            self.hairType = RoleHairType(rawValue: hairType)
        } else {
            self.hairType = RoleHairType(rawValue: "")
        }
    }
    
    func createPosition(projectID: String, positionName: String, heightMin: String, heightMax: String, ageMin: String, ageMax: String, bodyType: RoleBodyType, ethnicity: RoleEthnicity, eyeColor: RoleEyeColor, hairColor: RoleHairColor, hairLength: RoleHairLength, hairType: RoleHairType) throws {
        guard projectID != "" else {
            throw CreatePositionError.invalidProjectName
        }
        guard positionName != "" else {
            throw CreatePositionError.invalidPositionName
        }
        
        if Cast.createdPositions.contains(positionName.lowercased()) {
            throw CreatePositionError.duplicatePosition
        }
        
        
        
        let newPosition: Dictionary <String, String> = [
            FIRPositionData.positionName.rawValue: positionName,
            FIRPositionData.heightMin.rawValue: heightMin,
            FIRPositionData.heightMax.rawValue: heightMax,
            FIRPositionData.ageMin.rawValue: ageMin,
            FIRPositionData.ageMax.rawValue: ageMax,
            FIRPositionData.bodyType.rawValue: bodyType.rawValue,
            FIRPositionData.ethnicity.rawValue: ethnicity.rawValue,
            FIRPositionData.eyeColor.rawValue: eyeColor.rawValue,
            FIRPositionData.hairColor.rawValue: hairColor.rawValue,
            FIRPositionData.hairLength.rawValue: hairLength.rawValue,
            FIRPositionData.hairType.rawValue: hairType.rawValue
        ]
        
        Cast.REF_PRE_PRODUCTION_CASTING_POSITION.child(projectID).child(FIRDataCast.cast.rawValue).child(positionName).updateChildValues(newPosition)
        
    }
    
}


class Prospect {
    var talentName: String = ""
    var talentRating: String = ""
    var talentedAccepted: String = "NO"
    var prospectID: String = ""
    
    init(talentName: String, talentRating: String, talentAccepted: String) {
        self.talentName = talentName
        self.talentRating = talentRating
        self.talentedAccepted = talentAccepted
    }
    
    //init for prospects
    init(prospectID: String, prospectData: Dictionary <String, String>) {
        self.prospectID = prospectID
        
        if let talentName = prospectData[FIRPositionData.talentName.rawValue] {
            self.talentName = talentName
        }
        
        if let talentRating = prospectData[FIRPositionData.talentRating.rawValue] {
            self.talentRating = talentRating
        }
        
        if let talentAccepted = prospectData[FIRPositionData.talentAccepted.rawValue] {
            self.talentedAccepted = talentAccepted
        }
        
    }
    
    func createProspect(prospect: Prospect, projectID: String, position: String, userID: String) {
        let prospect: Dictionary <String, String> = [
            FIRPositionData.talentName.rawValue: prospect.talentName,
            FIRPositionData.talentRating.rawValue: prospect.talentRating,
            FIRPositionData.talentAccepted.rawValue: prospect.talentedAccepted
        ]
        
        Cast.REF_PRE_PRODUCTION_CASTING_POSITION.child(projectID).child("prospect").child(position).child(userID).updateChildValues(prospect)
    }
    
    
    
}






































