//
//  DataService.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 11/27/17.
//  Copyright © 2017 Zachary Blauvelt. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    //DB references
    private var _REF_BASE = DB_BASE
    private var _REF_PROJECTS = DB_BASE.child("projects")
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_CURRENT_USER = DB_BASE.child("users").child(userID)
    private var _REF_USER_PROJECTS = DB_BASE.child("users").child(userID).child("userProjects")
    private var _REF_USER_CURRENT_PROJECTS = DB_BASE.child("users").child(userID).child("currentProjects")
    private var _REF_USER_ARCHIVE_PROJECTS = DB_BASE.child("users").child(userID).child("archiveProjects")

    //Storage references
    private var _REF_PROJECT_IMAGES = STORAGE_BASE.child("project-pics")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_PROJECTS: FIRDatabaseReference {
        return _REF_PROJECTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_CURRENT_USER: FIRDatabaseReference {
        return _REF_CURRENT_USER
    }
    
    var REF_USER_PROJECTS: FIRDatabaseReference {
        return _REF_USER_PROJECTS
    }
    
    var REF_USER_CURRENT_PROJECTS: FIRDatabaseReference {
        return _REF_USER_CURRENT_PROJECTS
    }
    
    var REF_USER_ARCHIVE_PROJECTS: FIRDatabaseReference {
        return _REF_USER_ARCHIVE_PROJECTS
    }
    
    var REF_PROJECT_IMAGES: FIRStorageReference {
        return _REF_PROJECT_IMAGES 
    }
    

    
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
    }

