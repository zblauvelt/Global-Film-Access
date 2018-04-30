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
}

enum FiRPositionData: String {
    case positionName = "positionName"
    case talentName = "talentName"
    case talentRating = "talentRating"
    case talentAccepted = "talentAccepted"
}



//MARK: Pre-Production

protocol Position {
    var positionName: String { get set }
    static var createdPositions: [String] { get set }
    static var REF_PRE_PRODUCTION_CASTING_POSITION: FIRDatabaseReference { get }
    
    func createPosition(projectID: String, positionName: String) throws
}

enum FIRDataCast: String {
    case cast = "cast"
}


class Cast: Position {
    var positionName: String = ""
    static var createdPositions = [String]()
    
    
    static var REF_PRE_PRODUCTION_CASTING_POSITION: FIRDatabaseReference = DB_BASE.child("preProductionCasting")
    
    init() {}
    
    //init for positions
    init(positionName: String, positionData: Dictionary <String, String>) {
        self.positionName = positionName
        
        if let positionName = positionData[FiRPositionData.positionName.rawValue] {
            self.positionName = positionName
        }
        

        

    }
    
    func createPosition(projectID: String, positionName: String) throws {
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
            FiRPositionData.positionName.rawValue: positionName,
            
        ]
        
        Cast.REF_PRE_PRODUCTION_CASTING_POSITION.child(projectID).child(FIRDataCast.cast.rawValue).child(positionName).setValue(newPosition)
        
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
        
        if let talentName = prospectData[FiRPositionData.talentName.rawValue] {
            self.talentName = talentName
        }
        
        if let talentRating = prospectData[FiRPositionData.talentRating.rawValue] {
            self.talentRating = talentRating
        }
        
        if let talentAccepted = prospectData[FiRPositionData.talentAccepted.rawValue] {
            self.talentedAccepted = talentAccepted
        }
        
    }
    
    func createProspect(prospect: Prospect, projectID: String, position: String, userID: String) {
        let prospect: Dictionary <String, String> = [
            FiRPositionData.talentName.rawValue: prospect.talentName,
            FiRPositionData.talentRating.rawValue: prospect.talentRating,
            FiRPositionData.talentAccepted.rawValue: prospect.talentedAccepted
        ]
        
        Cast.REF_PRE_PRODUCTION_CASTING_POSITION.child(projectID).child("prospect").child(position).child(userID).updateChildValues(prospect)
    }
    
    
    
}






































