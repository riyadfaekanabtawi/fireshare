//
//  RegisterViewController.swift
//  RecipeApp
//
//  Created by Riyad Anabtawi on 12/28/15.
//  Copyright © 2015 Riyad Anabtawi. All rights reserved.
//

import UIKit

class RegisterViewController: GAITrackedViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
   
    let imagePicker = UIImagePickerController()
    @IBOutlet var user_avatar: UIImageView!
    var isUpdating = false
    @IBOutlet var avatar_placeholder: UIImageView!
    @IBOutlet var user_name_text_field: UITextField!
    @IBOutlet var user_email_text_field: UITextField!
    @IBOutlet var user_password_text_field: UITextField!
    @IBOutlet var user_password_confirmation_text_field: UITextField!
    @IBOutlet var registerUIButton: UIView!
    @IBOutlet var registerLabel: UILabel!
    @IBOutlet var goBackButton: UIButton!
    
    var alert:SCLAlertView!
    var userUpdating:Users!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
     
        
        
        if self.isUpdating{
            let tracker  = GAI.sharedInstance().defaultTracker
            tracker.set(kGAIScreenName, value:"Vista Actualizar Info")
            let build = GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject]
            tracker.send(build)
            self.user_avatar.sd_setImageWithURL(NSURL(string: self.userUpdating.avatar_url.stringByReplacingOccurrencesOfString("original", withString: "small", options: NSStringCompareOptions.LiteralSearch, range: nil)))
            self.user_email_text_field.text = self.userUpdating.email
            self.user_name_text_field.text = self.userUpdating.name
            self.user_password_text_field.placeholder = NSLocalizedString("password", comment: "")
            self.user_password_confirmation_text_field.placeholder = NSLocalizedString("confirm password", comment: "")
            self.registerLabel.text = NSLocalizedString("Update", comment: "")
        }else{
            let tracker  = GAI.sharedInstance().defaultTracker
            tracker.set(kGAIScreenName, value:"Vista Registro")
            let build = GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject]
            tracker.send(build)
            
            self.user_email_text_field.text = ""
            self.user_name_text_field.text = ""
            self.user_email_text_field.placeholder = NSLocalizedString("email", comment: "")
            self.user_name_text_field.placeholder = NSLocalizedString("username", comment: "")
            self.user_password_text_field.placeholder = NSLocalizedString("password", comment: "")
            self.user_password_confirmation_text_field.placeholder = NSLocalizedString("confirm password", comment: "")
            self.registerLabel.text = NSLocalizedString("Register", comment: "")
        
        }
        
        
        
        imagePicker.delegate = self
        self.registerUIButton.layer.cornerRadius = 2
        self.registerUIButton.layer.masksToBounds = true
        self.avatar_placeholder.layer.cornerRadius = 2
        self.avatar_placeholder.layer.masksToBounds = true
        
        self.registerLabel.font = UIFont(name: FONT_BOLD_ITALIC, size: (self.registerLabel.font?.pointSize)!)
    self.user_avatar.contentMode = UIViewContentMode.Center
        
         self.user_name_text_field.font = UIFont(name: FONT_BOLD_ITALIC, size: (self.user_name_text_field.font?.pointSize)!)
         self.user_email_text_field.font = UIFont(name: FONT_BOLD_ITALIC, size: (self.user_email_text_field.font?.pointSize)!)
         self.user_password_confirmation_text_field.font = UIFont(name: FONT_BOLD_ITALIC, size: (self.user_password_confirmation_text_field.font?.pointSize)!)
         self.user_password_text_field.font = UIFont(name: FONT_BOLD_ITALIC, size: (self.user_password_text_field.font?.pointSize)!)
        self.user_avatar.layer.cornerRadius = 2
        self.user_avatar.layer.masksToBounds = true
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.user_avatar.contentMode = UIViewContentMode.ScaleAspectFill
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
        self.avatar_placeholder.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.30, initialSpringVelocity: 6.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            self.avatar_placeholder.transform = CGAffineTransformIdentity;
            
            }) { (Bool) -> Void in
                
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .PhotoLibrary
                
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
                
                
        }
        
 
        
    }
       @IBAction func registerUserTouchUpInside(sender: UIButton) {
        
        
        self.registerUIButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.30, initialSpringVelocity: 6.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
               self.registerUIButton.transform = CGAffineTransformIdentity;
            
            }) { (Bool) -> Void in
                
                
                
                
        }
     
        
        if (self.user_email_text_field.text == "" || self.user_name_text_field.text == "" || self.user_password_confirmation_text_field.text == "" || self.user_password_text_field.text == "" || self.user_avatar.image == nil){
       
            
            
            self.alert = SCLAlertView()
            self.alert.addButton(NSLocalizedString("OK",comment:""), target:self, selector:Selector("OKSinTextPost"))
            
            self.alert.hideWhenBackgroundViewIsTapped = true
            self.alert.showCloseButton = false
            
            if self.isUpdating{
             self.alert.showError(NSLocalizedString("Oops",comment:""), subTitle: NSLocalizedString("You have to type iin your password and confirm it befor updating.",comment:""))
            }else{
             self.alert.showError(NSLocalizedString("Oops",comment:""), subTitle: NSLocalizedString("You have to fill all the fields and choose a profile picturre to finish Registration",comment:""))
            
            }
           
        
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
                if self.isUpdating{
                    Services.UpdateUserWithUsername(self.user_name_text_field.text, andPassword: self.user_password_text_field.text, andPasswordConfirmation: self.user_password_confirmation_text_field.text, andEmailAddress: self.user_email_text_field.text, andPicture: base64String, andDeviceToken:device_token, andID:self.userUpdating.user_id,andHandler: { (response) -> Void in
                        let tracker = GAI.sharedInstance().defaultTracker
                        
                        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Aunthentication", action: "Update", label: "Update", value: nil).build() as [NSObject : AnyObject])
                        
                        self.user_email_text_field.text = ""
                        self.user_name_text_field.text = ""
                        self.user_password_confirmation_text_field.text = ""
                        self.user_password_text_field.text = ""
                        self.navigationController?.popViewControllerAnimated(true)
                        
                        
                        }, orErrorHandler: { (err) -> Void in
                            
                      
                            
                    })
                }else{
                    Services.RegisterUserWithUsername(self.user_name_text_field.text, andPassword: self.user_password_text_field.text, andPasswordConfirmation: self.user_password_confirmation_text_field.text, andEmailAddress: self.user_email_text_field.text, andPicture: base64String, andDeviceToken:device_token, andHandler: { (response) -> Void in
                        
                        if ((response as? String) != nil){
                            self.alert = SCLAlertView()
                            self.alert.addButton(NSLocalizedString("OK",comment:""), target:self, selector:Selector("OKSinTextPost"))
                            
                            self.alert.hideWhenBackgroundViewIsTapped = true
                            self.alert.showCloseButton = false
                            self.alert.showWarning(NSLocalizedString("Oops",comment:""), subTitle: NSLocalizedString("A user with the same email already exists, please try another email",comment:""))
                        
                        }else{
                        
                            let tracker = GAI.sharedInstance().defaultTracker
                            
                            tracker.send(GAIDictionaryBuilder.createEventWithCategory("Aunthentication", action: "Register", label: "Register", value: nil).build() as [NSObject : AnyObject])
                            
                            
                            let defaults = NSUserDefaults.standardUserDefaults()
                            
                            let user = response as! Users
                            
                            let dataUser = NSKeyedArchiver.archivedDataWithRootObject(user)
                            
                            defaults.setObject(dataUser, forKey: "user_main")
                            
                            defaults.synchronize()
                            self.user_email_text_field.text = ""
                            self.user_name_text_field.text = ""
                            self.user_password_confirmation_text_field.text = ""
                            self.user_password_text_field.text = ""
                            self.performSegueWithIdentifier("home", sender: self)
                        }
                      
                        
                        
                        }, orErrorHandler: { (err) -> Void in
                            
                            
                            
                            
                            self.alert = SCLAlertView()
                            self.alert.addButton(NSLocalizedString("OK",comment:""), target:self, selector:Selector("OKSinTextPost"))
                            
                            self.alert.hideWhenBackgroundViewIsTapped = true
                            self.alert.showCloseButton = false
                            self.alert.showWarning(NSLocalizedString("Oops",comment:""), subTitle: NSLocalizedString("A user with the same email already exists, please try another email",comment:""))
                            
                    })
                
                }
             

            
            }else{
                
                self.alert = SCLAlertView()
                self.alert.addButton(NSLocalizedString("OK",comment:""), target:self, selector:Selector("OKSinTextPost"))
                
                self.alert.hideWhenBackgroundViewIsTapped = true
                self.alert.showCloseButton = false
                self.alert.showError(NSLocalizedString("Oops",comment:""), subTitle: NSLocalizedString("Your email is not a valid email, please try a proper email address",comment:""))
                
                
                
     
            
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
        
        self.goBackButton.transform = CGAffineTransformMakeScale(0.01, 0.01)
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.00, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            
            self.goBackButton.transform = CGAffineTransformMakeScale(1, 1)
            
            
            }) { (Bool) -> Void in
                
                self.navigationController?.popViewControllerAnimated(true)
                
        }
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y = 0
            
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    func OKSinTextPost(){
    
    self.alert.hideView()
    }
}
