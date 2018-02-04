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
                try createAccount.createUser(email: email, password: password, confirmedPassword: confirmedPassword, topVC: self)
            } catch FIRAuthError.invalidEmail {
                let alertController = UIAlertController(title: "Invalid Email", message: FIRAuthError.invalidEmail.rawValue, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel) { action in
                    return
                }
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            } catch FIRAuthError.invalidPassword {
                let alertController = UIAlertController(title: "Invalid Password", message: FIRAuthError.invalidPassword.rawValue, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel) { action in
                    return
                }
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            } catch FIRAuthError.passwordsDoNotMatch {
                let alertController = UIAlertController(title: "Passwords do not match", message: FIRAuthError.passwordsDoNotMatch.rawValue, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel) { action in
                    return
                }
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            } catch let error {
                print("\(error)")
            }
         }
        

    }


}
