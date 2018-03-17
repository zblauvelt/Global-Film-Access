//
//  DemoReelVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 3/15/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit

class DemoReelVC: UIViewController {
    
    
    @IBOutlet weak var videoWebView: UIWebView!
    
    
    var fullURL = ""
    var chosenVideoID: String!
    var url = "https://player.vimeo.com/video/"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("CHOSEN ID: \(chosenVideoID)")
        
        let requestURL = NSURL(string: getVideoURL(url: url, id: chosenVideoID))
        let request = NSURLRequest(url: requestURL! as URL)
        
        videoWebView.loadRequest(request as URLRequest)
        
        
    }


    
    func getVideoURL(url: String, id: String) -> String {
        if let video = chosenVideoID {
            fullURL = "\(url)\(video)"
            print("FULL URL: \(fullURL)")
        }
        return fullURL
    }
    
    
    

}
