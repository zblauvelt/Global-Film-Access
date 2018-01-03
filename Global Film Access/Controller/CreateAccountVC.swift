//
//  CreateAccountVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 1/1/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    let createAccount = FirebaseAuth()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transparentNavBar(viewController: self)
        emailTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        confirmPasswordTextField.setBottomBorder()
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text, let confirmedPassword = confirmPasswordTextField.text {
            do {
                try createAccount.createUser(email: email, password: password, confirmedPassword: confirmedPassword)
            } catch FIRAuthError.invalidEmail {
                print("\(FIRAuthError.invalidEmail.rawValue)")
            } catch FIRAuthError.invalidPassword {
                print("\(FIRAuthError.invalidPassword.rawValue)")
            } catch FIRAuthError.passwordsDoNotMatch {
                print("\(FIRAuthError.passwordsDoNotMatch.rawValue)")
            } catch let error {
                print("\(error)")
            }
         }
        

    }


}
