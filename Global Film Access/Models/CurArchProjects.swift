//
//  CurArchProjects.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 12/13/17.
//  Copyright © 2017 Zachary Blauvelt. All rights reserved.
//

import Foundation
//Model for Current and Archived user projects
class CurArchProjects {
    
private var _projectKey: String!
private var _projectid: String!


var projectKey: String {
    return _projectKey
}

var projectid: String {
    return _projectid
}


init(projectid: String) {
    self._projectid = projectid
    
}

init(projectKey: String, projectData: Dictionary<String, String>) {
    self._projectKey = projectKey
    
    if let projectid = projectData["projectid"] {
        self._projectid = projectid
    }
    
    }
}
