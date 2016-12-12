//
//  ForgotPasswordViewController.swift
//  Campus Tour Professor
//
//  Created by Chitturi,Rakesh on 11/19/16.
//  Copyright © 2016 Chitturi,Rakesh. All rights reserved.
//

import UIKit
import Parse
import Bolts

class ForgotPasswordViewController: UIViewController {
    //Array of professors
    var professors:[Professor]!
    //Email to be sent
    @IBOutlet weak var emailTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Forgot Password"
        // Do any additional setup after loading the view.
    }
    
  
    
  //  Function called when it comes from source view controller
    @IBAction func unwind(sender: AnyObject) {
        let mystry = UIStoryboard(name: "Main", bundle: nil)
        let vc = mystry.instantiateViewControllerWithIdentifier("login")
        self.presentViewController(vc, animated: true, completion: nil)
    }

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    @IBAction func retrivePassword(sender: AnyObject?) {
        let text = emailTF.text
        
        PFUser.requestPasswordResetForEmailInBackground(text!){
            (success,error)-> Void in
            if error == nil{
                let successMessage = "Email was sent successfully"
                self.displayMessage(successMessage)
                
            }
            
            else {
                let errorMessage = error!.userInfo["error"] as! String
                self.displayMessage(errorMessage)
            }
        }
                
        
    }
    //To give alert
    func displayMessage(message:String) {
        let alert = UIAlertController(title: "", message: message,
                                      preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title:"OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert,animated:true, completion:nil)
    }
    //To return keyboard when dismiss is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
