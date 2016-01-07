//
//  RegisterViewController.swift
//  RecipeApp
//
//  Created by Riyad Anabtawi on 12/28/15.
//  Copyright © 2015 Riyad Anabtawi. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
   
    let imagePicker = UIImagePickerController()
    @IBOutlet var user_avatar: UIImageView!
    @IBOutlet var user_name_text_field: UITextField!
    @IBOutlet var user_email_text_field: UITextField!
    @IBOutlet var user_password_text_field: UITextField!
    @IBOutlet var user_password_confirmation_text_field: UITextField!
    @IBOutlet var registerUIButton: UIButton!
    
    @IBOutlet var selectFotoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.registerUIButton.layer.cornerRadius = self.registerUIButton.frame.size.height/2
        self.registerUIButton.layer.masksToBounds = true
        
        self.registerUIButton.titleLabel?.font = UIFont(name: AVENIR_LIGHT, size: (self.registerUIButton.titleLabel?.font.pointSize)!)
        self.selectFotoLabel.font = UIFont(name: AVENIR_LIGHT, size: (self.selectFotoLabel.font?.pointSize)!)
        
         self.user_name_text_field.font = UIFont(name: AVENIR_LIGHT, size: (self.user_name_text_field.font?.pointSize)!)
         self.user_email_text_field.font = UIFont(name: AVENIR_LIGHT, size: (self.user_email_text_field.font?.pointSize)!)
         self.user_password_confirmation_text_field.font = UIFont(name: AVENIR_LIGHT, size: (self.user_password_confirmation_text_field.font?.pointSize)!)
         self.user_password_text_field.font = UIFont(name: AVENIR_LIGHT, size: (self.user_password_text_field.font?.pointSize)!)
        self.user_avatar.layer.cornerRadius = self.user_avatar.frame.size.width/2
        self.user_avatar.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.user_avatar.image = pickedImage
       
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func selectUserImageTouchUpInside(sender: UIButton) {
        
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(self.imagePicker, animated: true, completion: nil)
        
    }
       @IBAction func registerUserTouchUpInside(sender: UIButton) {
        
        
     
        
        if (self.user_email_text_field.text == "" || self.user_name_text_field.text == "" || self.user_password_confirmation_text_field.text == "" || self.user_password_text_field.text == ""){
            let alert = UIAlertController(title: "Ooops!", message: "Missing fields", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        
        }else{
            
            if Functions.NSStringIsValidEmail(self.user_email_text_field.text){
                
                let imageData = UIImageJPEGRepresentation(self.user_avatar.image!, 0.1)
                let base64String = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                
                let defults = NSUserDefaults.standardUserDefaults()
                var device_token = ""
                if (defults.objectForKey("device_token") != nil){
                    device_token = defults.objectForKey("device_token") as! String
                }else{
                    device_token = "0"
                    
                }
                
                Services.RegisterUserWithUsername(self.user_name_text_field.text, andPassword: self.user_password_text_field.text, andPasswordConfirmation: self.user_password_confirmation_text_field.text, andEmailAddress: self.user_email_text_field.text, andPicture: base64String, andDeviceToken:device_token, andHandler: { (response) -> Void in
                  
                    
                    self.user_email_text_field.text = ""
                    self.user_name_text_field.text = ""
                    self.user_password_confirmation_text_field.text = ""
                    self.user_password_text_field.text = ""
                    self.performSegueWithIdentifier("home", sender: self)
                  
                    
                    }, orErrorHandler: { (err) -> Void in
                        
                      
                        
                        let alert = UIAlertController(title: "Ooops!", message: "A user with the same email already exists, please try another email", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                        
                })

            
            }else{
                let alert = UIAlertController(title: "Ooops!", message: "Your email is not a valid email, please try a proper email address", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            
            }
            
        }
     
        
        
        
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.user_name_text_field {
            self.user_email_text_field.becomeFirstResponder()
        }
        
        if textField == self.user_email_text_field {
            self.user_password_text_field.becomeFirstResponder()
        }
        
        if textField == self.user_password_text_field {
            self.user_password_confirmation_text_field.becomeFirstResponder()
        }else{
        
        textField.resignFirstResponder()
        }
        
        return true
    }
    
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    
    
    @IBAction func goBackTouchUpInside(sender: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
}
