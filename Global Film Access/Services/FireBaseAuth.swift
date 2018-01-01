//
//  FireBaseAuth.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 1/1/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import Foundation
import UIKit
import Firebase

enum FIRAuthError: String, Error {
    case inValid = "Email and Password do not match. Please try again."
}


class FirebaseAuth {
    //checks to see if user typed a valid email
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    //checks to make sure user followed password guidelines
    func validatePassword(text : String) -> Bool{
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format: "SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: text)
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: text)
        print("\(numberresult)")
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/?]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        
        let specialresult = texttest2.evaluate(with: text)
        print("\(specialresult)")
        
        return capitalresult && numberresult && specialresult
        
    }
    ///Creates user for Firebase Auth()
    //MARK: Create FirebaseAuth() User
    func createUser(email: String, password: String) throws {
        guard validateEmail(enteredEmail: email) == true else{
            throw CreateUserError.invalidEmail
        }
        guard validatePassword(text: password) == true else {
            throw CreateUserError.invalidPassword
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print("ZACK: Unable to authenticate with Firebase user email")
            } else {
                print("ZACK: Successfully authenticated with Firebase")
            }
        })
    }
    
    ///Adds user to the Firebase database
    //MARK: Create user for DB
    func createUserDB() {
        
    }
    
    func signInUser(email: String, password: String) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                print("ZACK: Email user authenticated with Firebase")
            } else {
                let alertController = UIAlertController(title: "Authorization", message: FIRAuthError.inValid.rawValue, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel) { action in
                    return
                }
                alertController.addAction(okAction)
                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    
    func signOutUser() {
        
    }
    
    func archiveProject() {
        
    }
    
    func activateProject() {
        
    }
    
    func deleteProject() {
        
    }
}

