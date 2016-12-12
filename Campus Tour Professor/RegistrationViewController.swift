//
//  ConfirmRegistrationViewController.swift
//  Campus Tour Professor
//
//  Created by Chitturi,Rakesh on 11/28/16.
//  Copyright © 2016 Chitturi,Rakesh. All rights reserved.
//

import UIKit
import Parse

class RegistrationViewController: UIViewController {
    static var checkingPasscode:Int!
    //text field for email
    @IBOutlet weak var emailTF: UITextField!
    //text field for password
    @IBOutlet weak var passwordTF: UITextField!
    //text field to confirm password
    @IBOutlet weak var confirmPasswordTF: UITextField!
    // handles registration - note this assumes that we have checked the email verification box in the Email Settings
    // in our back4app.com app
    @IBAction func register(sender: AnyObject) {
        if emailTF.text?.componentsSeparatedByString("@")[1] == "nwmissouri.edu"{
            if passwordTF.text == confirmPasswordTF.text {
                let user = PFUser()
                user.password = passwordTF.text!
                user.username = emailTF.text!
                user.email = emailTF.text!
                
                // Signing up using the Parse API
                user.signUpInBackgroundWithBlock( {
                    (success, error) -> Void in
                    if let error = error as NSError? {
                        let errorString = error.userInfo["error"] as? NSString
                        // In case something went wrong, use errorString to get the error
                        self.displayAlertWithTitle("Something has gone wrong", message:"\(errorString)")
                    } else {
                        // Everything went okay
                        self.displayAlertWithTitle("Success!", message:"Registration was successful")
                        
                        
                        let emailVerified = user["emailVerified"]
                        if emailVerified != nil && (emailVerified as! Bool) == true {
                            // Everything is fine
                        }
                        else {
                            self.displayAlertWithTitle("Error", message: "Email is not verified")
                            // The email has not been verified, so logout the user
                            PFUser.logOut()
                        }
                    }
                })
            } else {
                displayAlertWithTitle("Error", message: "Passwords do not match")
            }
        } else {
            displayAlertWithTitle("Error", message: "This is only for professors")
        }
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func unwind(sender: AnyObject) {
        let mystry = UIStoryboard(name: "Main", bundle: nil)
        let vc = mystry.instantiateViewControllerWithIdentifier("login")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    //to give alert
    func displayAlertWithTitle(title:String, message:String){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    //to return keyboard when return is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
}
