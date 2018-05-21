//
//  Invitations.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 4/30/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import Foundation
import Firebase

enum FIREventData: String {
    case message = "message"
    case profileImage = "profileImage"
    case invitor = "invitor"
    case projectID = "projectID"
    case auditionID = "auditionID"
    case position = "position"
}

enum CreateInviteError: String, Error {
    case invalidMessage = "All invites require a message."
    case invalidInvitor = "All invites require the invitors name."
}

protocol Invite {
    var message: String {get set}
    var profileImage: String {get set}
    var invitor: String {get set}
    
}

class EventInvite: Invite {
    var message: String
    var profileImage: String
    var invitor: String
    var eventInviteKey: String = ""
    var projectID: String = ""
    var auditionID: String = ""
    var positionName: String = ""
    static var REF_EVENT_INVITE: FIRDatabaseReference = DB_BASE.child("users").child("invites")
    
    init(message: String, profileImage: String, invitor: String) {
        self.message = message
        self.profileImage = profileImage
        self.invitor = invitor
    }
    
    init(eventInviteKey: String, eventData: Dictionary <String, String>) {
        self.eventInviteKey = eventInviteKey
        
        if let message = eventData[FIREventData.message.rawValue] {
            self.message = message
        } else {
            self.message = ""
        }
        
        if let profileImage = eventData[FIREventData.profileImage.rawValue] {
            self.profileImage = profileImage
        } else {
            self.profileImage = ""
        }
        
        if let invitor = eventData[FIREventData.invitor.rawValue] {
            self.invitor = invitor
        } else {
            self.invitor = ""
        }
        
        if let projectID = eventData[FIREventData.projectID.rawValue] {
            self.projectID = projectID
        } else {
            projectID = ""
        }
        
        if let auditionID = eventData[FIREventData.auditionID.rawValue] {
            self.auditionID = auditionID
        } else {
            auditionID = ""
        }
        
        if let positionName = eventData[FIREventData.position.rawValue] {
            self.positionName = positionName
        } else {
            positionName = ""
        }
    }
    
    ///Provide the event, the person inviting, and the userKey for the user being invited. userKey is for Database. Also included is the ProjectID and Audition ID to access later for call sheet and calendar.
    func createInvite(event: EventInvite, invitorName: String, invitorProfileImage: String, inviteeKey: String, projectID: String, auditionID: String, positionName: String) throws {
        guard event.message != "" else {
            throw CreateInviteError.invalidMessage
        }
        
        guard event.invitor != "" else {
            throw CreateInviteError.invalidInvitor
        }
        

        
        let invite: Dictionary <String, String> = [
            FIREventData.message.rawValue: event.message,
            FIREventData.profileImage.rawValue: invitorProfileImage,
            FIREventData.invitor.rawValue: invitorName,
            FIREventData.projectID.rawValue: projectID,
            FIREventData.auditionID.rawValue: auditionID,
            FIREventData.position.rawValue: positionName
            
        ]
        EventInvite.REF_EVENT_INVITE.child(inviteeKey).childByAutoId().setValue(invite)
        
    }
    
    
}
