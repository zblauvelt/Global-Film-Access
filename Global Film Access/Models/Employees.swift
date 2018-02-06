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
    case prospects = "prospects"
}



//MARK: Pre-Production

protocol Position {
    var positionName: String { get set }
    static var createdPositions: [String] { get set }
    static var prospects: [String] { get set }
    static var REF_PRE_PRODUCTION_CASTING_POSITION: FIRDatabaseReference { get }
    
    func createPosition(projectID: String, positionName: String) throws
}

class Cast: Position {
    var positionName: String = ""
    static var createdPositions = [String]()
    static var prospects: [String] = ["No Prospects"]
    static var REF_PRE_PRODUCTION_CASTING_POSITION: FIRDatabaseReference = DB_BASE.child("preProductionCasting")
    
    init() {}
    
    init(positionName: String, positionData: Dictionary <String, Any>) {
        self.positionName = positionName
        
        if let positionName = positionData[FiRPositionData.positionName.rawValue] {
            self.positionName = positionName as! String
        }
        
        if let prospects = positionData[FiRPositionData.prospects.rawValue] {
            Cast.prospects = prospects as! [String]
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
        
        let newPosition: Dictionary <String, Any> = [
            FiRPositionData.positionName.rawValue: positionName,
            FiRPositionData.prospects.rawValue: Cast.prospects
        ]
        
        Cast.REF_PRE_PRODUCTION_CASTING_POSITION.child(projectID).child(positionName).setValue(newPosition)
        
    }
    
}



