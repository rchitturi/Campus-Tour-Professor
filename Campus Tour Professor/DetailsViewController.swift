//
//  ViewController.swift
//  Campus Tour Professor
//
//  Created by Chitturi,Rakesh on 11/19/16.
//  Copyright © 2016 Chitturi,Rakesh. All rights reserved.
//

import UIKit
import Parse
import Bolts
//View Controller for Details
class DetailsViewController: UIViewController,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //Professors to store data which was downloaded from cloud
    var professors:[Professor]! = []
    //Array of departments
    var listOfDepartments = ["Fine and Performing Arts","Humanities and Social Sciences","Language, Literature and Writing","Mathematics and Statistics","Natural Sciences","Agricultural Sciences","Melvin D. & Valorie G. Booth School of Business","Communication and Mass Media","Computer Science and Information Systems","School of Education","Health Science and Wellness"]
    //Array of buildings
    var listOfBuildings = ["Colden Hall","Wells Hall","Valk Center","Ron Houston","Admin Building","Owens Library","Student Union"]
    //To check whether data is in cloud or not
    var inDatabase = false
    //Email to store from login credentials
    static var email:String!
    //Text field for first name
    @IBOutlet weak var firstNameTF: UITextField!
    //Text field for middle name
    @IBOutlet weak var middleNameTF: UITextField!
    //Text field for last name
    @IBOutlet weak var lastNameTF: UITextField!
    //Text field for department
    @IBOutlet weak var departmentTF: UITextField!
    //Text field for email
    @IBOutlet weak var emailTF: UITextField!
    //Text field for phone number
    @IBOutlet weak var phoneNoTF: UITextField!
    //Text field for building
    @IBOutlet weak var buildingTF: UITextField!
    //Text field for office
    @IBOutlet weak var officeTF: UITextField!
    //Text view for office hours
    @IBOutlet weak var officeHoursTV: UITextView!
    
    @IBOutlet weak var professorImage: UIImageView!
    //Picker to select deartment
    @IBOutlet weak var departmentPicker: UIPickerView!
    //Picker to select building
    @IBOutlet weak var buildingPicker: UIPickerView!
    
    
    //Loads once view controller loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //To sort the list
        listOfDepartments.sortInPlace()
        listOfBuildings.sortInPlace()
        //To have a placeholder for table view
        officeHoursTV.text = "Ex: MWF - 2:30P.M - 3:30P.M \n      TR - 10:00A.M - 3:00P.M"
        officeHoursTV.textColor = UIColor.lightGrayColor()
        //Title for view controller
        self.title = "Enter Details"
        
        // fetching professors from cloud
        PopulatingProfessors.populateProfessors()
        //Assigning professors to professors variable
        self.professors = PopulatingProfessors.professors
        //Iterating through professors
        self.departmentPicker.hidden = true
        self.buildingPicker.hidden = true
        for professor in professors{
            //If professor is in cloud
            if professor.email == DetailsViewController.email{
                
                inDatabase = true
                //Assigning values to text fields
                officeHoursTV.textColor = UIColor.blackColor()
                firstNameTF.text = professor.firstName
                middleNameTF.text = professor.middleName
                lastNameTF.text = professor.lastName
                emailTF.text = professor.email
                phoneNoTF.text = professor.phoneNumber
                buildingTF.text = professor.building
                officeTF.text = professor.office
                officeHoursTV.text = professor.officeHours
                departmentTF.text = professor.specalization
                let image1 = professor.image
                image1.getDataInBackgroundWithBlock({(imageData:NSData?,error:NSError?)-> Void in
                    if (error == nil){
                        self.professorImage.image = UIImage(data: imageData!)
                    }
                })
            }
        }
        
    }
    
    //To upload image
    @IBAction func uploadImage(sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(image, animated: true, completion: nil)
    }
    //To show selected image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        professorImage.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //To insert edited values into cloud
    @IBAction func InsertingIntoCloud(sender: AnyObject) {
        //Checking conditions
        if (phoneNoTF.text?.characters.count == 10 && Int64(phoneNoTF.text!) != nil) {
            
        
        if emailTF.text == DetailsViewController.email{
            if firstNameTF.text?.characters.count != 0 {
                if middleNameTF.text != nil {
                    if lastNameTF.text?.characters.count != 0 {
                        if emailTF.text?.characters.count != 0 {
                            if phoneNoTF.text?.characters.count != 0 {
                                if officeHoursTV.text?.characters.count != 0 {
                                    if departmentTF.text?.characters.count != 0 {
                                        if officeTF.text?.characters.count != 0 {
                                            if buildingTF.text?.characters.count != 0 {
                                                if !(professorImage.image == nil){
                                                    if inDatabase == false {
                                                        
                                                        let professor = PFObject(className: "Professor")
                                                        professor["firstName"] = firstNameTF.text
                                                        professor["middleName"] = middleNameTF.text
                                                        professor["lastName"] = lastNameTF.text
                                                        professor["email"] = emailTF.text
                                                        professor["phoneNumber"] = phoneNoTF.text
                                                        professor["officeHours"] = officeHoursTV.text
                                                        professor["specalization"] = departmentTF.text
                                                        professor["office"] = officeTF.text
                                                        professor["building"] = buildingTF.text
                                                        let imageData = UIImagePNGRepresentation(professorImage.image!)
                                                        if imageData?.length > 50000 {
                                                            displayMessage("Image size should be less than 50KB")
                                                        }
                                                        else {
                                                            let imageFile = PFFile(name:firstNameTF.text , data: imageData!)
                                                            
                                                            professor["image"] = imageFile
                                                            
                                                            
                                                            professor.saveInBackgroundWithBlock({ (success, error) -> Void in
                                                                if success {
                                                                    self.displayMessage("Uploaded Succesfully")
                                                                } else {
                                                                    print(error)
                                                                }
                                                            })
                                                        }
                                                    } else {
                                                        let professor = PFObject(className: "Professor")
                                                        professor["firstName"] = firstNameTF.text
                                                        professor["middleName"] = middleNameTF.text
                                                        professor["lastName"] = lastNameTF.text
                                                        professor["email"] = emailTF.text
                                                        professor["phoneNumber"] = phoneNoTF.text
                                                        professor["officeHours"] = officeHoursTV.text
                                                        professor["specalization"] = departmentTF.text
                                                        professor["office"] = officeTF.text
                                                        professor["building"] = buildingTF.text
                                                        
                                                        let imageData = UIImagePNGRepresentation(professorImage.image!)
                                                        
                                                        let imageFile = PFFile(name:firstNameTF.text , data: imageData!)
                                                        
                                                        professor["image"] = imageFile
                                                        let query = PFQuery(className: "Professor")
                                                        query.whereKey("email", equalTo: DetailsViewController.email)
                                                        query.findObjectsInBackgroundWithBlock {
                                                            (objectis: [PFObject]?, error: NSError?) -> Void in
                                                            for object in objectis! {
                                                                object.deleteEventually()
                                                            }
                                                        }
                                                        professor.saveInBackgroundWithBlock({ (success, error) -> Void in
                                                            if success {
                                                                self.displayMessage("Updated Succesfully")
                                                            } else {
                                                                print(error)
                                                            }
                                                        })
                                                    }
                                                } else {
                                                    displayMessage("Upload Image")
                                                }
                                                
                                            } else {
                                                displayMessage("Enter Your office building")
                                            }
                                        } else {
                                            displayMessage("Enter your office Number")
                                        }
                                    } else {
                                        displayMessage("Enter your department")
                                    }
                                } else {
                                    displayMessage("Enter Office Hours")
                                }
                            } else {
                                displayMessage("Enter Phone Number")
                            }
                        } else {
                            displayMessage("Enter Emai Id")
                        }
                    } else {
                        displayMessage("Enter last Name")
                    }
                } else {
                    displayMessage("Enter Middle Name")
                }
            } else {
                displayMessage("Enter First Name")
            }
        } else {
            displayMessage("You can edit only your details")
        }
        } else {
            displayMessage("Number should be of 10 digits")
        }
        
    }
    //Number of components in picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //number of rows in component based on picker
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == departmentPicker{
            return listOfDepartments.count
        } else {
            return listOfBuildings.count
        }
    }
    //Assigning title for each row
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        
        if pickerView == departmentPicker{
            return listOfDepartments[row]
        } else {
            return listOfBuildings[row]
        }
    }
    //Action when a row is selected
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == departmentPicker{
            departmentTF.text = listOfDepartments[row]
            self.departmentPicker.hidden = true
        } else {
            buildingTF.text = listOfBuildings[row]
            self.buildingPicker.hidden = true
        }
        
        
    }
    //If cancel is pressed
    @IBAction func cancel(sender: AnyObject) {
        firstNameTF.text = ""
        middleNameTF.text = ""
        lastNameTF.text = ""
        departmentTF.text = ""
        emailTF.text = ""
        phoneNoTF.text = ""
        buildingTF.text = ""
        officeTF.text = ""
        officeHoursTV.text = ""
    }
    //When logout is pressed user is logged out
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        let mystry = UIStoryboard(name: "Main", bundle: nil)
        let vc = mystry.instantiateViewControllerWithIdentifier("login")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    //To resign keyboard when return is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //Alert
    func displayMessage(message:String) {
        let alert = UIAlertController(title: "", message: message,
                                      preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title:"OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert,animated:true, completion:nil)
    }
    //When user touchs any where on screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    //For placeholder of table view
    func textViewDidBeginEditing(textView: UITextView) {
        
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    //After getting cursor onto text field
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == departmentTF{
            departmentPicker.hidden = false
            departmentPicker.backgroundColor = UIColor.whiteColor()
        } else if textField == buildingTF {

            self.buildingPicker.hidden = false
            buildingPicker.backgroundColor = UIColor.whiteColor()
            
        }
    }
    
    
    
    
    
}

