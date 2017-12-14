//
//  UserProjects.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 11/30/17.
//  Copyright © 2017 Zachary Blauvelt. All rights reserved.
//

import Foundation

class UserProjects {
    private var _userProjects: String!
    private var _projectid: String!
    private var _admin: String!
    
    var userProjects: String {
        return _userProjects
    }
    
    var projectid: String {
        return _projectid
    }
    
    var admin: String {
        return _admin
    }
    
    init(projectid: String, admin: String) {
        self._projectid = projectid
        self._admin = admin
    }
    
    init(userProjects: String, projectData: Dictionary<String, String>) {
        self._userProjects = userProjects
        
        if let projectid = projectData["projectid"] {
            self._projectid = projectid
        }
        
        if let admin = projectData["admin"] {
            self._admin = admin
        }
    }
    
    
    
}
