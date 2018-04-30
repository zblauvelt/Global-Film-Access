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

class ProfileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, XMLParserDelegate, UITableViewDelegate, UITableViewDataSource {
    
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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var agentBtn: UIButton!
    @IBOutlet weak var managerBtn: UIButton!
    @IBOutlet weak var legalBtn: UIButton!
    @IBOutlet weak var locationLbl: UILabel!
    
    
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
    
    
    //MARK: Table View Setup
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userMovie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifierMovie = "profileMovieCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierMovie, for: indexPath)
        
        cell.textLabel?.text = userMovie[indexPath.row].movieName
        cell.detailTextLabel?.text = userMovie[indexPath.row].movieYear
        
        return cell
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let movietvHeight = CGFloat(self.userMovie.count) * CGFloat(75)
        self.tvHeightConstraint.constant = movietvHeight
        
        self.view.layoutIfNeeded()
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
            self.tableView.reloadData()
            self.viewDidLayoutSubviews()
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
        locationLbl.text = "\(userDetail[0].city), \(userDetail[0].state)"
    }
    
    //MARK: Call buttons
    
    @IBAction func callButtonTapped(_ sender: UIButton) {
        //TODO: Add call function - Switch statement on sender.
        switch sender.tag {
        case 1:
            if let agentNumber = userDetail[0].agentNumber {
                print(agentNumber)
                callContact(phoneNumber: agentNumber)
            } else {
                showAlert(message: CreateUserError.invalidNumber.rawValue)
            }
        case 2:
            if let managerNumber = userDetail[0].managerNumber {
                callContact(phoneNumber: managerNumber)
            } else {
                showAlert(message: CreateUserError.invalidNumber.rawValue)
            }
        case 3:
            if let legalNumber = userDetail[0].legalNumber {
                callContact(phoneNumber: legalNumber)
            } else {
                showAlert(message: CreateUserError.invalidNumber.rawValue)
            }
        default:
            showAlert(message: CreateUserError.invalidNumber.rawValue)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVideo" {
            let desVC = segue.destination as! DemoReelVC
            desVC.chosenVideoID = self.videoID
        } else if segue.identifier == "assignAudition" {
            let nav = segue.destination as! UINavigationController
            let desVC = nav.topViewController as! assignAuditionVC
            desVC.talentName = "\(userDetail[0].firstName) \(userDetail[0].lastName)"
            desVC.userID = "\(currentUserKey)"
        }
    }
    
    //MARK: Call Contacts
   
    func callContact(phoneNumber: String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application: UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        } else {
            showAlert(message: CreateUserError.invalidNumber.rawValue)
        }
    }
    
    //Alert message for error handling
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "" , message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { action in
            return
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func cancelToProfile(segue: UIStoryboardSegue) {}
    

}
