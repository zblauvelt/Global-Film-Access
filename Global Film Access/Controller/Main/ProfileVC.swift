  //
//  ProfileVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 3/4/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

fileprivate let reuseIdentifier = "demoReelCell"
fileprivate let screenWidth = UIScreen.main.bounds.width

class ProfileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, XMLParserDelegate {
    
    var userDetail = [UserType]()
    var userVideo = [UserVideos]()
    var userMovie = [UserMovies]()
    var currentUserKey = ""
    //var currentParsingElement = ""
    //var imageURL = ""
    var videoID = ""

    //MARK: Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var imdbRatingLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetail()
        getVideoDetail()
        getMovieDetail()
        setupCollectionViewCells()
        
        print("ZACK: \(currentUserKey)")
        

    }

//Collection View Controller
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userVideo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let video = userVideo[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileCollectionViewCell
        
        let url = URL(string: video.videoImageURL)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf:url!)
            DispatchQueue.main.async {
                cell.demoReelThumbnail.image = UIImage(data: data!)
            }
        }

        //cell.demoReelThumbnail.image = #imageLiteral(resourceName: "ProjectFilm")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        videoID = userVideo[indexPath.row].videoID
        self.performSegue(withIdentifier: "showVideo", sender: nil)
        
    }
    
    
    //MARK: Set up Collection Views
    func setupCollectionViewCells() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        let padding: CGFloat = 10
        let itemWidth = screenWidth/3 - padding
        let itemHeight = screenWidth/3 - padding
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = layout
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
        print("VIDEOS")
        UserVideos.REF_CURRENT_USER_VIDEOS.child(currentUserKey).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.userVideo.removeAll()
                for snap in snapshot {
                    print("SNAP:\(snap)")
                    
                    if let videoDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let video = UserVideos(videoKey: key, videoData: videoDict)
                        self.userVideo.append(video)
                        print(video.videoID)
                        
                    }
                }
            }
            self.collectionView.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVideo" {
            let desVC = segue.destination as! DemoReelVC
            desVC.chosenVideoID = self.videoID
        }
    }
   
    

}
