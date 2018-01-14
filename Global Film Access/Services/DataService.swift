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


    //Storage references
    private var _REF_PROJECT_IMAGES = STORAGE_BASE.child("project-pics")
    
    //var REF_BASE: FIRDatabaseReference {
      //  return _REF_BASE
    //}
    
    var REF_PROJECTS: FIRDatabaseReference {
        return _REF_PROJECTS
    }
    

    
    
    //func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
      //  REF_USERS.child(uid).updateChildValues(userData)
    //}
    
    
    }

