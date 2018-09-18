//
//  LoginViewController.swift
//  TinderClone
//
//  Created by Vu Duong on 9/17/18.
//  Copyright © 2018 Vu Duong. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginSignUpButton: UIButton!
    @IBOutlet weak var changeLoginSignUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var signupMode = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
    }
    
    @IBAction func loginSignupTapped(_ sender: Any) {
        if signupMode {
            let user = PFUser()
            user.username = usernameTextField.text
            user.password = passwordTextField.text
            user.signUpInBackground { (success, error) in
                
                if error != nil {
                    var errorMessage = "Sign Up Failed - Try Again"
                    if let newError = error as NSError? {
                        if let detailedError = newError.userInfo["error"] as? String {
                            errorMessage = detailedError
                        }
                    }
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = errorMessage
                } else {
                    print("Sign Up Successful")
                    self.performSegue(withIdentifier: "profileUpdateSegue", sender: nil)
                }
            }
            
        } else {
            
            if let username = usernameTextField.text {
                if let password = passwordTextField.text {
                    PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
                        if error != nil {
                            var errorMessage = "Login Failed - Try Again"
                            if let newError = error as NSError? {
                                if let detailedError = newError.userInfo["error"] as? String {
                                    errorMessage = detailedError
                                }
                            }
                            self.errorLabel.isHidden = false
                            self.errorLabel.text = errorMessage
                        } else {
                            print("Login Successful")
                            
                            if user? ["isFemale"] != nil {
                                self.performSegue(withIdentifier: "loginToSwipingSegue", sender: nil)
                            } else {
                                self.performSegue(withIdentifier: "profileUpdateSegue", sender: nil)
                            }
                            
                            self.performSegue(withIdentifier: "profileUpdateSegue", sender: nil)
                        }
                    }
                }
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            
            if PFUser.current()?["isFemale"] != nil {
                self.performSegue(withIdentifier: "loginToSwipingSegue", sender: nil)
            } else {
                self.performSegue(withIdentifier: "profileUpdateSegue", sender: nil)
            }
        }
    }
    
    @IBAction func changeLoginSignUpTapped(_ sender: Any) {
        
        if signupMode {
            loginSignUpButton.setTitle("Login", for: .normal)
            changeLoginSignUpButton.setTitle("SignUp", for: .normal)
            signupMode = false
        } else {
            loginSignUpButton.setTitle("Signup", for: .normal)
            changeLoginSignUpButton.setTitle("Login", for: .normal)
            signupMode = true
        }
    }
    
}
