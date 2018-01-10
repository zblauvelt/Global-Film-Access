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
    case invalidEmail = "Please provide a valid email"
    case invalidPassword = "Passwords must be atleast 6 characters, contain one uppercase letter, and one of the following !&^%$#@()/?"
    case passwordsDoNotMatch = "Passwords do not match."
    case emailExists = "This email address already exists."
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
    func createUser(email: String, password: String, confirmedPassword: String, topVC: UIViewController) throws {
        let rootVC = topVC
        guard validateEmail(enteredEmail: email) == true else{
            throw FIRAuthError.invalidEmail
        }
        guard validatePassword(text: password) == true else {
            throw FIRAuthError.invalidPassword
        }
        guard password == confirmedPassword else {
            throw FIRAuthError.passwordsDoNotMatch
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                
                    let alertController = UIAlertController(title: "Email Exists", message: FIRAuthError.emailExists.rawValue, preferredStyle: .alert)
                    let signIn = UIAlertAction(title: "Sign In", style: .default, handler: { action in
                        rootVC.performSegue(withIdentifier: "cancelCreateUser", sender: self)
                    })
                    
                    let okAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                        return
                    }
                    alertController.addAction(signIn)
                    alertController.addAction(okAction)
                    rootVC.present(alertController, animated: true, completion: nil)
                
            } else {
                rootVC.performSegue(withIdentifier: "createProfile", sender: self)
                print("ZACK: Successfully authenticated with Firebase")
            }
        })
    }
    

    ///Sign user into the app 
    func signInUser(email: String, password: String) {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                print("ZACK: Email user authenticated with Firebase")
                if let vc = rootVC {
                    vc.performSegue(withIdentifier: "signIn", sender: nil)
                }
            } else {
                let alertController = UIAlertController(title: "Authorization", message: FIRAuthError.inValid.rawValue, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel) { action in
                    return
                }
                alertController.addAction(okAction)
                if let vc = rootVC {
                  vc.present(alertController, animated: true, completion: nil)
                }
                
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

