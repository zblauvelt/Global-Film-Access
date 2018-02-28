//
//  User.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 11/29/17.
//  Copyright © 2017 Zachary Blauvelt. All rights reserved.
//

import Foundation
import Firebase


enum Access: String {
    case granted = "true"
    case denied = "false"
}

enum FIRUserData: String {
    case firstName = "firstName"
    case lastName = "lastName"
    case city = "city"
    case state = "state"
    case profileImage = "profileImage"
    case userName = "userName"
    case zipCode = "zipCode"
    case agentName = "agentName"
    case agentNumber = "agentNumber"
    case managerName = "managerName"
    case managerNumber = "managerNumber"
    case legalName = "legalName"
    case legalNumber = "legalNumber"
    case videoName = "videoName"
    case videoURL = "videoURL"
    case movieName = "movieName"
    case movieYear = "movieYear"
}

enum CreateUserError: String, Error {
    case invalidFirstName = "Please provide a first name."
    case invalidLastName = "Please provide a last name"
    case invalidCity = "Please provide a city."
    case invalidState = "Please provide a state."
    case invalidZipCode = "Please provide a zip code."
    case invalidProfileImage = "Please provide an image."
    case invalidUserName = "Please provide a username."

    
}
//MARK: The current Firebase User
 let userID = FIRAuth.auth()!.currentUser!.uid

protocol User {
    var firstName: String { get set }
    var lastName: String { get set }
    var city: String { get set }
    var state: String { get set }
    var zipCode: String { get set }
    var profileImage: String? { get set }
    var userName: String { get set }
    var userKey: String { get set }
    static var REF_USERS: FIRDatabaseReference { get }
    static var REF_CURRENT_USER: FIRDatabaseReference { get }
    static var REF_PROFILE_IMAGE: FIRStorageReference { get }
    
    ///Adds user to the Firebase database
    //MARK: Create user for DB
    func createUserDB(user: User, userImage: UIImage) throws
    
    
}

class UserType: User {
    
    var firstName: String
    var lastName: String
    var city: String
    var state: String
    var zipCode: String
    var profileImage: String?
    var userName: String
    var userKey: String = ""
    var agentName: String?
    var agentNumber: String?
    var managerName: String?
    var managerNumber: String?
    var legalName: String?
    var legalNumber: String?
    
    //Firebase database references
    static var REF_USERS = DB_BASE.child("users").child("allUsers")
    static var REF_CURRENT_USER = DB_BASE.child("users").child(userID)
    static var REF_CURRENT_USER_DETAILS = DB_BASE.child("users").child("details")
    static var REF_PROFILE_IMAGE = STORAGE_BASE.child("profile-pics")
    
    
    init(firstName: String, lastName: String, city: String, state: String, zipCode: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.userName = "\(firstName).\(lastName)"
        
    }
    
    init(userKey: String, userData: Dictionary <String, String>) {
        self.userKey = userKey
        
        if let firstName = userData[FIRUserData.firstName.rawValue] {
            self.firstName = firstName
        } else {
            self.firstName = ""
        }
        
        if let lastName = userData[FIRUserData.lastName.rawValue] {
           self.lastName = lastName
        } else {
            self.lastName = ""
        }
        
        if let city = userData[FIRUserData.city.rawValue] {
            self.city = city
        } else {
            self.city = ""
        }
        
        if let state = userData[FIRUserData.state.rawValue] {
            self.state = state
        } else {
            self.state = ""
        }
        
        if let zipCode = userData[FIRUserData.zipCode.rawValue] {
            self.zipCode = zipCode
        } else {
            self.zipCode = ""
        }
        
        if let userName = userData[FIRUserData.userName.rawValue] {
            self.userName = userName
        } else {
            self.userName = ""
        }
        
        if let profileImage = userData[FIRUserData.profileImage.rawValue] {
            self.profileImage = profileImage
        } else {
            self.profileImage = ""
        }
        
        if let agentName = userData[FIRUserData.agentName.rawValue] {
            self.agentName = agentName
        } else {
            self.agentName = "Agent Name"
        }
        
        if let agentNumber = userData[FIRUserData.agentNumber.rawValue] {
            self.agentNumber = agentNumber
        } else {
            self.agentNumber = "(xxx) xxx-xxxx"
        }
        
        if let managerName = userData[FIRUserData.managerName.rawValue] {
            self.managerName = managerName
        } else {
            self.managerName = "Manager Name"
        }
        
        if let managerNumber = userData[FIRUserData.managerNumber.rawValue] {
            self.managerNumber = managerNumber
        } else {
            self.managerNumber = "(xxx) xxx-xxxx"
        }
        
        if let legalName = userData[FIRUserData.legalName.rawValue] {
            self.legalName = legalName
        } else {
            self.legalName = "Legal Name"
        }
        
        if let legalNumber = userData[FIRUserData.legalNumber.rawValue] {
            self.legalNumber = legalNumber
        } else {
            self.legalNumber = "(xxx) xxx-xxxx"
        }
        
    }
    
    func createUserDB(user: User, userImage: UIImage) throws {
        guard user.firstName != "" else {
            throw CreateUserError.invalidFirstName
        }
        guard user.lastName != "" else {
            throw CreateUserError.invalidLastName
        }
        guard user.city != "" else {
            throw CreateUserError.invalidCity
        }
        guard user.state != "" else {
            throw CreateUserError.invalidState
        }
        guard user.zipCode != "" else {
            throw CreateUserError.invalidZipCode
        }
        
        let img = userImage
        
        //Save image to profile pics folder in Firebase Storage
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            UserType.REF_PROFILE_IMAGE.child(imgUid).put(imgData, metadata: metaData) { (metaData, error) in
                if error != nil {
                    print("ZACK: Unable to upload to Firebase Storage")
                } else {
                    print("ZACK: Successfully uploaded image")
                    let downloadURL = metaData?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        let newUser: Dictionary<String, String> = [
                            FIRUserData.firstName.rawValue: user.firstName,
                            FIRUserData.lastName.rawValue: user.lastName,
                            FIRUserData.userName.rawValue: "\(user.firstName).\(user.lastName)",
                            FIRUserData.city.rawValue: user.city,
                            FIRUserData.state.rawValue: user.state,
                            FIRUserData.zipCode.rawValue: user.zipCode,
                            FIRUserData.profileImage.rawValue: url,
                        ]
                        
                        let newAllUser: Dictionary<String, String> = [
                            FIRUserData.firstName.rawValue: user.firstName,
                            FIRUserData.lastName.rawValue: user.lastName,
                            FIRUserData.profileImage.rawValue: url
                        ]
                       
                        //MARK: Post to Firebase Database
                        UserType.REF_CURRENT_USER_DETAILS.child(userID).setValue(newUser)
                        UserType.REF_USERS.child(userID).setValue(newAllUser)
                    }
                }
            }
            
        }
    }
    
    func updateProfileInfo(user: UserType, userImage: UIImage, userAgentName: String, userAgentNumber: String, userManagerName: String, userManagerNumber: String, userLegalName: String, userLegalNumber: String) throws {
        let defualtNumber = "(xxx) xxx-xxxx"
        guard user.firstName != "" else {
            throw CreateUserError.invalidFirstName
        }
        guard user.lastName != "" else {
            throw CreateUserError.invalidLastName
        }
        guard user.city != "" else {
            throw CreateUserError.invalidCity
        }
        guard user.state != "" else {
            throw CreateUserError.invalidState
        }
        guard user.zipCode != "" else {
            throw CreateUserError.invalidZipCode
        }
        
        var agentName: String {
            if userAgentName != "" {
                return userAgentName
            } else {
                return "Agent Name"
            }
        }
        var agentNumber: String {
            if userAgentNumber != "" {
                return userAgentNumber
            } else {
                return defualtNumber
            }
        }
        var managerName: String {
            if userManagerName != "" {
                return userManagerName
            } else {
                return "Manager Name"
            }
        }
        var managerNumber: String {
            if userManagerNumber != "" {
                return userManagerNumber
            } else {
                return defualtNumber
            }
        }
        var legalName: String {
            if userLegalName != "" {
                return userLegalName
            } else {
                return "Legal Name"
            }
        }
        var legalNumber: String {
            if userLegalNumber != "" {
                return userLegalNumber
            } else {
                return defualtNumber
            }
        }
        
        
        
        let img = userImage
        
        //Save image to profile pics folder in Firebase Storage
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            UserType.REF_PROFILE_IMAGE.child(imgUid).put(imgData, metadata: metaData) { (metaData, error) in
                if error != nil {
                    print("ZACK: Unable to upload to Firebase Storage")
                } else {
                    print("ZACK: Successfully uploaded image")
                    let downloadURL = metaData?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        let updateUser: Dictionary<String, String> = [
                            FIRUserData.firstName.rawValue: user.firstName,
                            FIRUserData.lastName.rawValue: user.lastName,
                            FIRUserData.userName.rawValue: "\(user.firstName).\(user.lastName)",
                            FIRUserData.city.rawValue: user.city,
                            FIRUserData.state.rawValue: user.state,
                            FIRUserData.zipCode.rawValue: user.zipCode,
                            FIRUserData.profileImage.rawValue: url,
                            FIRUserData.agentName.rawValue: agentName,
                            FIRUserData.agentNumber.rawValue: agentNumber,
                            FIRUserData.managerName.rawValue: managerName,
                            FIRUserData.managerNumber.rawValue: managerNumber,
                            FIRUserData.legalName.rawValue: legalName,
                            FIRUserData.legalNumber.rawValue: legalNumber
                            ]
                        
                        let updateAllUser: Dictionary<String, String> = [
                            FIRUserData.firstName.rawValue: user.firstName,
                            FIRUserData.lastName.rawValue: user.lastName,
                            FIRUserData.profileImage.rawValue: url
                        ]
                        
                        //MARK: Post to Firebase Database
                        UserType.REF_CURRENT_USER_DETAILS.child(userID).updateChildValues(updateUser)
                        UserType.REF_USERS.child(userID).updateChildValues(updateAllUser)
                    }
                }
            }
            
        }
    }
}

enum CreateVideoError: String, Error {
    case invalidVideoName = "Please provide a valid video name."
    case invalidVideoURL = "Please provide a valid vimeo URL."
}

class UserVideos {
    var videoName: String
    var videoURL: String
    var videoKey: String = ""
    static var REF_CURRENT_USER_VIDEOS = DB_BASE.child("users").child("videos")
    
    
    init(videoName: String, videoURL: String) {
        self.videoName = videoName
        self.videoURL = videoURL
    }
    
    init(videoKey: String, videoData: Dictionary<String, String>) {
        self.videoKey = videoKey
        
        if let videoName = videoData[FIRUserData.videoName.rawValue] {
            self.videoName = videoName
        } else {
            self.videoName = ""
        }
        
        if let videoURL = videoData[FIRUserData.videoURL.rawValue] {
            self.videoURL = videoURL
        } else {
            self.videoURL = ""
        }
    }
    
    //Validate that a correct url was entered
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    func createNewVideo(video: UserVideos) throws {
        guard video.videoName != "" else {
            throw CreateVideoError.invalidVideoName
        }
        guard self.verifyUrl(urlString: video.videoURL) else {
            throw CreateVideoError.invalidVideoURL
        }
        let newVideo: Dictionary<String, String> = [
            FIRUserData.videoName.rawValue: videoName,
            FIRUserData.videoURL.rawValue: videoURL
        ]
        UserVideos.REF_CURRENT_USER_VIDEOS.child(userID).childByAutoId().setValue(newVideo)
    }
}

enum CreateMovieError: String, Error {
    case invalidMovieName = "Please provide a valid movie name."
    case invalidMovieYear = "Please provide the year you were apart of this movie."
}

class UserMovies {
    var movieName: String
    var movieYear: String
    var movieKey: String = ""
    static var REF_CURRENT_USER_MOVIES = DB_BASE.child("users").child("movies")
    
    init(movieName: String, movieYear: String) {
        self.movieName = movieName
        self.movieYear = movieYear
    }
    
    init(movieKey: String, movieData: Dictionary<String, String>) {
        self.movieKey = movieKey
        
        if let movieName = movieData[FIRUserData.movieName.rawValue] {
            self.movieName = movieName
        } else {
            self.movieName = ""
        }
        
        if let movieYear = movieData[FIRUserData.movieYear.rawValue] {
            self.movieYear = movieYear
        } else {
            self.movieYear = ""
        }
    }
    
    func createNewMovie(movie: UserMovies) throws {
        guard movie.movieName != "" else {
            throw CreateMovieError.invalidMovieName
        }
        guard movie.movieYear != "" else {
            throw CreateMovieError.invalidMovieYear
        }
        
        let newMovie: Dictionary<String, String> = [
            FIRUserData.movieName.rawValue: movieName,
            FIRUserData.movieYear.rawValue: movieYear
        ]
        
        UserMovies.REF_CURRENT_USER_MOVIES.child(userID).childByAutoId().setValue(newMovie)
        }
    }
    





















