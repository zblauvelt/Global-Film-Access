//
//  UserProjects.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 11/30/17.
//  Copyright © 2017 Zachary Blauvelt. All rights reserved.
//

import Foundation
import Firebase

class UserProjects {
    var projectID: String = ""
    var projectName: String = ""
    var accessLevel: String
    static var REF_USER_PROJECTS: FIRDatabaseReference = DB_BASE.child("users").child(userID).child("userProjects")
    static var REF_USER_CURRENT_PROJECTS = DB_BASE.child("users").child(userID).child("currentProjects")
    static var REF_USER_ARCHIVE_PROJECTS = DB_BASE.child("users").child(userID).child("archiveProjects")
    
    
    init(accessLevel: String) {
        self.accessLevel = accessLevel
    }
    
    init(projectID: String, userProjectData: Dictionary <String, String>) throws {
        self.projectID = projectID
        
        if let projectName = userProjectData[FIRProjectData.projectName.rawValue] {
            self.projectName = projectName
        } else {
            throw CreateProjectError.inValidProjectName
        }
        
        if let accessLevel = userProjectData[FIRProjectData.accessLevel.rawValue] {
            self.accessLevel = accessLevel
        } else {
            throw CreateProjectError.invalidProjectAccessLevel
        }
    }
}
