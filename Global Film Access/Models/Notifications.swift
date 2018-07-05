//
//  Invitations.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 4/30/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import Foundation
import Firebase

enum EventLabel: String {
    case na = "N/A"
    case audition = "audition"
    case event = "event"
    
}

enum CreateNotificationError: String, Error {
    case invalidMessage = "Invalid Message"
    case invalidLabel = "Invalid Label"
    case invalidProfileImage = "Invalid Image"
    case invalidInviteeUserId = "invalid Invitee User ID"
    case invalidProjectID = "Invalid ProjectID"
    case invalidAuditionID = "Invalid Audition ID"
    case invalidRoleID = "Invalid Role ID"

}

enum FIREventData: String {
    case message = "message"
    case label = "label"
    case inviterProfileImage = "inviterProfileImage"
    case inviterUserID = "inviterUserID"
    case projectID = "projectID"
    case eventID = "eventID"
    case roleID = "roleID"
}

class Notifications {
    var message = ""
    var label: EventLabel
    var inviterProfileImage: String
    var inviterUserID: String
    var notificatoinKey: String = ""
    static var REF_NOTIFICATION = DB_BASE.child("users").child("notifications")
    //ID from database to specify project
    var projectID: String?
    //ID From database to get detail
    var eventID: String?
    //ID from database fo get role Detail
    var roleID: String?
    
    init(label: EventLabel, inviterProfileImage: String, projectID: String?, eventID: String?, roleID: String?) {
        self.inviterUserID = userID
        self.label = label
        self.inviterProfileImage = inviterProfileImage
        self.projectID = projectID
        self.eventID = eventID
        self.roleID = roleID
    }
    
    init(notificationKey: String, notificationData: Dictionary<String, String>) {
        self.notificatoinKey = notificationKey
        
        if let message = notificationData[FIREventData.message.rawValue] {
            self.message = message
        } else {
            self.message = ""
        }
        
        if let label = notificationData[FIREventData.label.rawValue] {
            if let eventHandler = EventLabel(rawValue: label) {
                self.label = eventHandler
            } else {
                self.label = EventLabel.na
            }
        } else {
            self.label = EventLabel(rawValue: "")!
        }
        
        if let inviterProfileImage = notificationData[FIREventData.inviterProfileImage.rawValue] {
            self.inviterProfileImage = inviterProfileImage
        } else {
            self.inviterProfileImage = ""
        }
        
        if let inviterUserID = notificationData[FIREventData.inviterUserID.rawValue] {
            self.inviterUserID = inviterUserID
        } else {
            self.inviterUserID = ""
        }
        
        if let projectID = notificationData[FIREventData.projectID.rawValue] {
            self.projectID = projectID
        } else {
            self.projectID = ""
        }
        
        if let eventID = notificationData[FIREventData.eventID.rawValue] {
            self.eventID = eventID
        } else {
            self.eventID = ""
        }
        
        if let roleID = notificationData[FIREventData.roleID.rawValue] {
            self.roleID = roleID
        } else {
            self.roleID = ""
        }
        
    }
    
    func createAuditionNotification(notification: Notifications, userKey: String) throws {
        
       
        
        notification.message = "You have been invited to audition."
        
        guard notification.label != .na else {
            throw CreateNotificationError.invalidLabel
        }
        
        guard notification.inviterProfileImage != "" else {
            throw CreateNotificationError.invalidProfileImage
        }
        
        guard let project = notification.projectID else {
            throw CreateNotificationError.invalidProjectID
        }
        
        guard let event = notification.eventID else {
            throw CreateNotificationError.invalidAuditionID
        }
        
        guard let role = notification.roleID else {
            throw CreateNotificationError.invalidRoleID
        }
        
        print("Create Notification")
        
        let notification: Dictionary <String, String> = [
            FIREventData.message.rawValue: notification.message,
            FIREventData.label.rawValue: notification.label.rawValue,
            FIREventData.inviterProfileImage.rawValue: notification.inviterProfileImage,
            FIREventData.inviterUserID.rawValue: notification.inviterUserID,
            FIREventData.projectID.rawValue: project,
            FIREventData.roleID.rawValue: role,
            FIREventData.eventID.rawValue: event
        ]
        
        Notifications.REF_NOTIFICATION.child(userKey).childByAutoId().setValue(notification)
    }
    
    
    
}
    
    
    

