//
//  ViewController.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 11/21/17.
//  Copyright © 2017 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    @IBOutlet weak var email: CustomTextField!
    @IBOutlet weak var password: CustomTextField!
    let firebaseAuth = FirebaseAuth()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FIXME: remove when done app
        email.text = "zblauvelt@hotmail.com"
        password.text = "Hockey4842?"
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Authenticate with Email
    @IBAction func signInButtonTapped(_ sender: Any) {
        if let email = email.text, let password = password.text {
            self.firebaseAuth.signInUser(email: email, password: password)
        }
    }
    
    //unwind back to login
    @IBAction func cancel(segue: UIStoryboardSegue) {}
    @IBAction func cancelCreateUser(segue: UIStoryboardSegue) {}
    
    
}

