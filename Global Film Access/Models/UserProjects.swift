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
    
    var userProjects: String {
        return _userProjects
    }
    
    var projectid: String {
        return _projectid
    }
    
    init(projectid: String) {
        self._projectid = projectid
    }
    
    init(userProjects: String, projectData: Dictionary<String, String>) {
        self._userProjects = userProjects
        
        if let projectid = projectData["projectid"] {
            self._projectid = projectid
        }
    }
    
    
    
}
