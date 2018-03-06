//
//  ProfileVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 3/4/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {
    
    var userDetail = [UserType]()
    var userVideo = [UserVideos]()
    var userMovie = [UserMovies]()
    var currentUserKey = ""

    //MARK: Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var imdbRatingLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetail()
        getVideoDetail()
        getMovieDetail()
        print("ZACK: \(currentUserKey)")
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Get All User Information
    
    //Get User Basic Information
    func getUserDetail() {
        UserType.REF_CURRENT_USER_DETAILS.child(currentUserKey).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.userDetail.removeAll()
                for snap in snapshot {
                    print("SNAP:\(snap)")
                    
                    if let userDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let user = UserType(userKey: key, userData: userDict)
                        self.userDetail.append(user)
                        //Fill in Text Labels
                        self.fillInLabels()
                    }
                }
            }
        })
    }
    
    //Get user videos
    func getVideoDetail() {
        UserVideos.REF_CURRENT_USER_VIDEOS.child(currentUserKey).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.userVideo.removeAll()
                for snap in snapshot {
                    print("SNAP:\(snap)")
                    
                    if let videoDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let video = UserVideos(videoKey: key, videoData: videoDict)
                        self.userVideo.append(video)
                    }
                }
            }
        })
    }
    
    //Get user movies
    func getMovieDetail() {
        UserMovies.REF_CURRENT_USER_MOVIES.child(currentUserKey).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.userMovie.removeAll()
                for snap in snapshot {
                    print("SNAP:\(snap)")
                    
                    if let movieDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let movie = UserMovies(movieKey: key, movieData: movieDict)
                        self.userMovie.append(movie)
                    }
                }
            }
        })
    }
    
    //MARK: Get image from Firebase
    func getImageFromFirebase(img: UIImage? = nil) {
        if img != nil {
            self.profileImage.image = img
        } else {
            if let imageURL = self.userDetail[0].profileImage {
                let ref = FIRStorage.storage().reference(forURL: imageURL)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion:  { (data, error) in
                    if error != nil {
                        print("ZACK: Unable to download image from Firebase")
                        self.profileImage.image = #imageLiteral(resourceName: "ProfileImage")
                    } else {
                        print("ZACK: Successfully downloaded image.")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.profileImage.image = img
                            }
                        }
                    }
                })
            }
        }
        
    }
    
    //MARK: Text for Labels
    func fillInLabels() {
        self.getImageFromFirebase()
        fullNameLbl.text = "\(userDetail[0].firstName) \(userDetail[0].lastName)"
        imdbRatingLbl.text = userDetail[0].imdbRating
    }
    
    //MARK: Call buttons
    
    @IBAction func callButtonTapped(_ sender: Any) {
        //TODO: Add call function - Switch statement on sender.
    }
    

    
    

}
