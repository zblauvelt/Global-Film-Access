//
//  Employees.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 1/29/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import Foundation
import Firebase

enum CreateRoleError: String, Error {
    case invalidRoleName = "Please provide a valid project"
    case invalidRoleType = "Please provide a type for this role."
    case invalidShortDescription = "Please provide a short description for this role."
    case invalidDetailDescription = "Please provide a detailed description for this role."
    case invalidProjectName = "Please provide a valid position name."
    case duplicatePosition = "You have already created a position with this name. Please create a different position."
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

enum FIRRoleData: String {
    case roleName = "roleName"
    case talentName = "talentName"
    case roleType = "roleType"
    case shortDescription = "shortDescription"
    case detailDescription = "detailDescription"
    case talentRating = "talentRating"
    case talentAccepted = "talentAccepted"
    case heightMin = "heightMin"
    case heightMax = "heightMax"
    case ageMin = "ageMin"
    case ageMax = "ageMax"
    case daysNeeded = "daysNeeded"
    case dailyRate = "dailyRate"
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
    var roleName: String { get set }
    static var createdRoles: [String] { get set }
    static var REF_PRE_PRODUCTION_CASTING_POSITION: FIRDatabaseReference { get }
    
}

enum FIRDataCast: String {
    case cast = "cast"

}


class Cast: Position {
    
    var roleName: String
    static var createdRoles = [String]()
    var roleType: String
    var shortDescription: String
    var detailDescription: String
    var heightMin: String?
    var heightMax: String?
    var ageMin: String?
    var ageMax: String?
    var daysNeeded: String?
    var dailyRate: String?
    var bodyType: RoleBodyType?
    var ethnicity: RoleEthnicity?
    var eyeColor: RoleEyeColor?
    var hairColor: RoleHairColor?
    var hairLength: RoleHairLength?
    var hairType: RoleHairType?
    
    static var REF_PRE_PRODUCTION_CASTING_POSITION: FIRDatabaseReference = DB_BASE.child("preProductionCasting")
    
    init(roleName: String, roleType: String, shortDescription: String, detailDescription: String) {
        self.roleName = roleName
        self.roleType = roleType
        self.shortDescription = shortDescription
        self.detailDescription = detailDescription
    }
    
    //init for positions
    init(roleName: String, roleData: Dictionary <String, String>) {
        self.roleName = roleName
        
        if let roleName = roleData[FIRRoleData.roleName.rawValue] {
            self.roleName = roleName
        } else {
            self.roleName = ""
        }
        
        if let roleType = roleData[FIRRoleData.roleType.rawValue] {
            self.roleType = roleType
        } else {
            self.roleType = ""
        }
        
        if let shortDescription = roleData[FIRRoleData.shortDescription.rawValue] {
            self.shortDescription = shortDescription
        } else {
            self.shortDescription = ""
        }
        
        if let detailDescription = roleData[FIRRoleData.detailDescription.rawValue] {
            self.detailDescription = detailDescription
        } else {
            self.detailDescription = ""
        }
        
        if let daysNeeded = roleData[FIRRoleData.daysNeeded.rawValue] {
            self.daysNeeded = daysNeeded
        } else {
            self.daysNeeded = ""
        }
        
        if let dailyRate = roleData[FIRRoleData.dailyRate.rawValue] {
            self.dailyRate = dailyRate
        } else {
            self.dailyRate = ""
        }
        
        if let heightMin = roleData[FIRRoleData.heightMin.rawValue] {
            self.heightMin = heightMin
        } else {
            self.heightMin = ""
        }
        
        if let heightMax = roleData[FIRRoleData.heightMax.rawValue] {
            self.heightMax = heightMax
        } else {
            self.heightMax = ""
        }
        
        if let ageMin = roleData[FIRRoleData.ageMin.rawValue] {
            self.ageMin = ageMin
        } else {
            self.ageMin = ""
        }
        
        if let ageMax = roleData[FIRRoleData.ageMax.rawValue] {
            self.ageMax = ageMax
        } else {
            self.ageMax = ""
        }
        
        if let bodyType = roleData[FIRRoleData.bodyType.rawValue] {
            self.bodyType = RoleBodyType(rawValue: bodyType)
        } else {
            self.bodyType = RoleBodyType(rawValue: "")
        }
        
        if let ethnicity = roleData[FIRRoleData.ethnicity.rawValue] {
            self.ethnicity = RoleEthnicity(rawValue: ethnicity)
        } else {
            self.ethnicity = RoleEthnicity(rawValue: "")
        }
        
        if let eyeColor = roleData[FIRRoleData.eyeColor.rawValue] {
            self.eyeColor = RoleEyeColor(rawValue: eyeColor)
        } else {
            self.eyeColor = RoleEyeColor(rawValue: "")
        }

        if let hairColor = roleData[FIRRoleData.hairColor.rawValue] {
            self.hairColor = RoleHairColor(rawValue: hairColor)
        } else {
            self.hairColor = RoleHairColor(rawValue: "")
        }
        
        if let hairLength = roleData[FIRRoleData.hairLength.rawValue] {
            self.hairLength = RoleHairLength(rawValue: hairLength)
        } else {
            self.hairLength = RoleHairLength(rawValue: "")
        }
        
        if let hairType = roleData[FIRRoleData.hairType.rawValue] {
            self.hairType = RoleHairType(rawValue: hairType)
        } else {
            self.hairType = RoleHairType(rawValue: "")
        }
    }
    
    func createRole(projectID: String, role: Cast, daysNeeded: String, dailyRate: String, ageMin: String, ageMax: String, heightMinFeet: String, heightMinInches: String, heightMaxFeet: String, heightMaxInches: String,bodyType: BodyType.RawValue, eyeColor: EyeColor.RawValue, hairColor: HairColor.RawValue, hairLength: HairLength.RawValue, hairType: HairType.RawValue, ethnicity: Ethnicity.RawValue, update: Bool) throws {
        guard projectID != "" else {
            throw CreateRoleError.invalidProjectName
        }
        guard role.roleName != "" else {
            throw CreateRoleError.invalidRoleName
        }
        
        guard role.roleType != "" else {
            throw CreateRoleError.invalidRoleType
        }
        
        guard role.shortDescription != "" else {
            throw CreateRoleError.invalidShortDescription
        }
        
        guard role.detailDescription != "" else {
            throw CreateRoleError.invalidDetailDescription
        }
        
        if update {
            print("updating role...")
        } else {
            if Cast.createdRoles.contains(roleName.lowercased()) {
                throw CreateRoleError.duplicatePosition
            }
        }
        
        
        
        var daysNeededInt = 0
        if daysNeeded == "" {
            print("Days needed not entered")
        } else {
            if let daysNeededConverted = Int(daysNeeded) {
                daysNeededInt = daysNeededConverted
            } else {
                throw CreateRoleError.invalidDaysNeeded
            }
        }
        
        var dailyRateInt = 0
        if dailyRate == "" {
            print("Daily rate not entered")
        } else {
            if let dailyRateConverted = Int(dailyRate) {
                dailyRateInt = dailyRateConverted
            } else {
                throw CreateRoleError.invalidDailyRate
            }
        }
        
        var ageMinInt = 0
        if ageMin == "" {
            print("Age min not entered")
        } else {
            if let ageMinConverted = Int(ageMin) {
                ageMinInt = ageMinConverted
            } else {
                throw CreateRoleError.invalidMinAge
            }
        }
        
        var ageMaxInt = 0
        if ageMax == "" {
            print("Age min not entered")
        } else {
            if let ageMaxConverted = Int(ageMax) {
                ageMaxInt = ageMaxConverted
            } else {
                throw CreateRoleError.invalidMaxAge
            }
        }
        
        //Convert Minimum Height
        var heightMinFeetInt = 0
        var heightMinInchesInt = 0
        if heightMinFeet == "" {
            print("height min not entered")
        } else {
            if let heightMinFeetConverted = Int(heightMinFeet) {
                if heightMinFeetConverted < 12 && heightMinFeetConverted >= 0 {
                    heightMinFeetInt = heightMinFeetConverted
                } else {
                    throw CreateRoleError.invalidMinHeight
                }
            } else {
                throw CreateRoleError.invalidMinHeight
            }
        }
        
        if heightMinInches == "" {
            print("Did not enter Inches Min")
        } else {
            if let heightMinInchesConverted = Int(heightMinInches) {
                if heightMinInchesConverted < 12 && heightMinInchesConverted >= 0 {
                    heightMinInchesInt = heightMinInchesConverted
                } else {
                    throw CreateRoleError.invalidMinHeight
                }
            } else {
                throw CreateRoleError.invalidMinHeight
            }
        }

        let heightMinTotal = (heightMinFeetInt * 12) + heightMinInchesInt

            //Convert Maximum Height
            var heightMaxFeetInt = 0
            var heightMaxInchesInt = 0
        
        if heightMaxFeet == "" {
            print("height min not entered")
        } else {
            if let heightMaxFeetConverted = Int(heightMaxFeet) {
                if heightMaxFeetConverted < 12 && heightMaxFeetConverted >= 0 {
                    heightMaxFeetInt = heightMaxFeetConverted
                } else {
                    throw CreateRoleError.invalidMaxHeight
                }
            } else {
                throw CreateRoleError.invalidMaxHeight
            }
        }
        
        if heightMaxInches == "" {
            print("Did not enter Inches Min")
        } else {
            if let heightMaxInchesConverted = Int(heightMaxInches) {
                if heightMaxInchesConverted < 12 && heightMaxInchesConverted >= 0 {
                    heightMaxInchesInt = heightMaxInchesConverted
                } else {
                    throw CreateRoleError.invalidMaxHeight
                }
            } else {
                throw CreateRoleError.invalidMaxHeight
            }
        }
        
            let heightMaxTotal = (heightMaxFeetInt * 12) + heightMaxInchesInt
        
        let newRole: Dictionary <String, String> = [
            FIRRoleData.roleName.rawValue: role.roleName,
            FIRRoleData.roleType.rawValue: role.roleType,
            FIRRoleData.shortDescription.rawValue: role.shortDescription,
            FIRRoleData.detailDescription.rawValue: role.detailDescription,
            FIRRoleData.daysNeeded.rawValue: "\(daysNeededInt)",
            FIRRoleData.dailyRate.rawValue: "\(dailyRateInt)",
            FIRRoleData.heightMin.rawValue: "\(heightMinTotal)",
            FIRRoleData.heightMax.rawValue: "\(heightMaxTotal)",
            FIRRoleData.ageMin.rawValue: "\(ageMinInt)",
            FIRRoleData.ageMax.rawValue: "\(ageMaxInt)",
            FIRRoleData.bodyType.rawValue: bodyType,
            FIRRoleData.ethnicity.rawValue: ethnicity,
            FIRRoleData.eyeColor.rawValue: eyeColor,
            FIRRoleData.hairColor.rawValue: hairColor,
            FIRRoleData.hairLength.rawValue: hairLength,
            FIRRoleData.hairType.rawValue: hairType
        ]
        
        Cast.REF_PRE_PRODUCTION_CASTING_POSITION.child(projectID).child(FIRDataCast.cast.rawValue).child(roleName).updateChildValues(newRole)
        
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
        
        if let talentName = prospectData[FIRRoleData.talentName.rawValue] {
            self.talentName = talentName
        }
        
        if let talentRating = prospectData[FIRRoleData.talentRating.rawValue] {
            self.talentRating = talentRating
        }
        
        if let talentAccepted = prospectData[FIRRoleData.talentAccepted.rawValue] {
            self.talentedAccepted = talentAccepted
        }
        
    }
    
    func createProspect(prospect: Prospect, projectID: String, position: String, userID: String) {
        let prospect: Dictionary <String, String> = [
            FIRRoleData.talentName.rawValue: prospect.talentName,
            FIRRoleData.talentRating.rawValue: prospect.talentRating,
            FIRRoleData.talentAccepted.rawValue: prospect.talentedAccepted
        ]
        
        Cast.REF_PRE_PRODUCTION_CASTING_POSITION.child(projectID).child("prospect").child(position).child(userID).updateChildValues(prospect)
    }
    
    
    
    }
    






































