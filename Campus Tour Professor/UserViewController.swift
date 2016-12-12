//
//  ViewController.swift
//  ParseQuickStartDemo
//
//  Created by Michael Rogers on 10/15/16.
//  Copyright © 2016 Michael Rogers. All rights reserved.
//

import UIKit
import Parse
import Bolts

// Handles user management -- see the back4app.com quickstart docs for details:
// https://docs.back4app.com/docs/ios/quickstart/

class UserViewController: UIViewController {
    
    //Text field for email
    @IBOutlet weak var emailTF: UITextField!
    //Text field for password
    @IBOutlet weak var passwordTF: UITextField!
    //Creating Object for storyboard
    let mystrb = UIStoryboard(name: "Main", bundle: nil)
    //Populating professors when login page is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        PopulatingProfessors.populateProfessors()

    }
    // handles login
    @IBAction func login(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(emailTF.text!, password: passwordTF.text!, block:{(user, error) -> Void in
            if error != nil{
                let errorMessage = error!.userInfo["error"] as! String
                self.displayAlertWithTitle("",message:errorMessage)
            }
                
            else {
                let emailVerified:Bool = user!["emailVerified"] as! Bool
                if (emailVerified){
                    // Everything went alright here
                    
                    let detailsVC = self.mystrb.instantiateViewControllerWithIdentifier("datavc")
                    DetailsViewController.email = self.emailTF.text
                    self.presentViewController(detailsVC, animated: true, completion: nil)
                } else {
                    self.displayAlertWithTitle("", message: "Activate Your Email")
                    PFUser.logOut()
                    
                }
                
                
                
                
            }
            }
        )
    }
    
    
    
    // TO go to registration page
    @IBAction func register(sender: AnyObject) {
        //object registration view controller
        let registerVC = self.mystrb.instantiateViewControllerWithIdentifier("registration")
        //Presenting view controller
        self.presentViewController(registerVC, animated: true, completion: nil)
    }
    //For Alert messages
    func displayAlertWithTitle(title:String, message:String){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    //Returning keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}

