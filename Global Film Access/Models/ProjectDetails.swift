//
//  ProjectDetails.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 11/30/17.
//  Copyright © 2017 Zachary Blauvelt. All rights reserved.
//

import Foundation

class ProjectDetails {
    private var _image: String!
    private var _name: String!
    private var _date: String! 
    private var _projectid: String!
    
    var image: String {
        return _image
    }
    
    var name: String {
        return _name
    }
    
    var date: String {
        return _date
    }
    
    var projectid: String {
        return _projectid
    }
    
    init(image: String, name: String, date: String) {
        self._image = image
        self._name = name
        self._projectid = date
    }
    
    init(projectid: String, projectData: Dictionary<String, String>) {
        self._projectid = projectid
        
        if let image = projectData["image"] {
            self._image = image
        }
        
        if let name = projectData["name"] {
            self._name = name
        }
        
        if let date = projectData["startDate"] {
            self._date = date
        }
    }
    
    
}
