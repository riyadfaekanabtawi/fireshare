//
//  PostDetailViewController.swift
//  fireshare
//
//  Created by Riyad Anabtawi on 2/1/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

import UIKit

class PostDetailViewController: GAITrackedViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,CommentDelegate {

    @IBOutlet var denounceButton: UIButton!
    
    @IBOutlet var comments_tableView: UICollectionView!
    @IBOutlet var go_back_Button: UIButton!
    @IBOutlet var navView: UIImageView!
    @IBOutlet var post_title: UILabel!
    @IBOutlet var deletecon_width: NSLayoutConstraint!
    @IBOutlet var post_user_avatar: UIImageView!
    @IBOutlet var post_user_name: UILabel!
    @IBOutlet var send_commentButton: UIButton!
    @IBOutlet var commentTextField: UITextField!
    
    var alert:SCLAlertView!
    var array_of_comments:[AnyObject] = []
    var post:Posts!
    
    override func viewDidLoad() {
        
        
        let tracker  = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value:"Vista Detalle Post")
        let build = GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject]
        tracker.send(build)
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PostDetailViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PostDetailViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        self.commentTextField.placeholder = NSLocalizedString("Write your comment", comment: "")
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRectMake(0, -20, self.view.frame.size.width, 64)
        gradientLayer.colors = [UIColor(red: 174.0/255.0, green: 35.0/255.0, blue: 95.0/255.0, alpha: 1),UIColor(red: 209.0/255.0, green: 104.0/255.0, blue: 43.0/255.0, alpha: 1)].map{$0.CGColor}
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        // Render the gradient to UIImage
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Set the UIImage as background property
        self.navView.image = image
        
        
        self.post_title.text = self.post.post_title
        self.post_user_avatar.layer.cornerRadius = 3
        self.post_user_avatar.layer.masksToBounds = true
        
        self.post_user_avatar.image = UIImage(named: "user.png")
        self.post_user_avatar.sd_setImageWithURL(NSURL(string: self.post.post_user.avatar_url)) { (image, err, SDImageCacheType, url) -> Void in
            if (image != nil){
                
                self.post_user_avatar.image = image
                
            }else{
                self.post_user_avatar.image = UIImage(named: "user.png")
            }
            
            
            
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let user = NSKeyedUnarchiver.unarchiveObjectWithData(defaults.objectForKey("user_main")as! NSData) as! Users
        
        if self.post.post_user.user_id == user.user_id{
        self.denounceButton.hidden = true
        self.deletecon_width.constant = 20
            
        }else{
        self.denounceButton.hidden = false
        self.deletecon_width.constant = 0
        }

        
        self.view.layoutIfNeeded()
        
        
        self.post_user_name.text = self.post.post_user.name
        
        self.post_user_name.font = UIFont(name: FONT_REGULAR, size: self.post_user_name.font.pointSize)
        
        self.commentTextField.font = UIFont(name: FONT_REGULAR, size: self.commentTextField.font!.pointSize)
        
        self.post_title.font = UIFont(name: FONT_REGULAR, size: self.post_title.font.pointSize)
        
   
        self.refresh()
        
    }
 
    
    func refresh (){
        
        Services.getPostDetailWithID(self.post.post_id, andHandler: { (response) -> Void in
            
            self.post = response as! Posts
            self.array_of_comments = self.post.comments as! [Comments]
            
            
            self.comments_tableView.reloadData()
            }) { (err) -> Void in
                
                
                
        }
    
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return self.array_of_comments.count
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        return CGSizeMake(self.view.frame.size.width-20, 100)
        
        
    }


    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("comments", forIndexPath: indexPath) as! CommentCollectionViewCell
        cell.delegate = self
        if indexPath.row == 0{
            cell.fireIcon_width.constant = 14
            cell.timeTrailing.constant = 10
             cell.layoutIfNeeded()
        }else{
            cell.timeTrailing.constant = 0
            cell.fireIcon_width.constant = 0
            cell.layoutIfNeeded()
        }
        cell.displayComment(self.array_of_comments[indexPath.row] as! Comments)
        
        return cell
    }
    
    

  @IBAction func comment(sender: UIButton) {
    
    self.send_commentButton.transform = CGAffineTransformMakeScale(0.01, 0.01)
    UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.00, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
        
        self.send_commentButton.transform = CGAffineTransformMakeScale(1, 1)
        
        
        }) { (Bool) -> Void in
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            let user = NSKeyedUnarchiver.unarchiveObjectWithData(defaults.objectForKey("user_main")as! NSData) as! Users
            
            if self.commentTextField.text == ""{
              
                
                self.alert = SCLAlertView()
                self.alert.addButton("OK", target:self, selector:#selector(PostDetailViewController.OKSinTextPost))
                
                self.alert.hideWhenBackgroundViewIsTapped = true
                self.alert.showCloseButton = false
                self.alert.showError("Ooops", subTitle: NSLocalizedString("You have to write something before commenting." , comment: ""))

                
                
            }else{
                
                
                Services.createCommentForPost(self.post.post_id, byUser: user.user_id, andComment: self.commentTextField.text, andHandler: { (response) -> Void in
                    let tracker = GAI.sharedInstance().defaultTracker
                    
                    tracker.send(GAIDictionaryBuilder.createEventWithCategory("Post", action: "Comment Post", label: "Comment Post", value: nil).build() as [NSObject : AnyObject])
                    self.commentTextField.text = ""
                    self.commentTextField.placeholder = NSLocalizedString("Write your comment", comment: "")
                    self.commentTextField.resignFirstResponder()
                    
                    let post = response as! Comments
                    
                    let arrayMutable = NSMutableArray()
                    arrayMutable.addObject(post)
                    arrayMutable.addObjectsFromArray(self.array_of_comments)
                    
                    var array = [AnyObject]()
                    
                    array = arrayMutable as [AnyObject]
                    self.array_of_comments = array
                    
                    self.comments_tableView.reloadData()
                    
                    
                    
               
                    
                    
                    }) { (err) -> Void in
                        
                        
                        
                }
            }
            

            
    }

    
    
    
    }
    
  
    
    
    
    @IBAction func goBack(sender: UIButton) {
        self.go_back_Button.transform = CGAffineTransformMakeScale(0.01, 0.01)
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.00, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            
            self.go_back_Button.transform = CGAffineTransformMakeScale(1, 1)
            
            
            }) { (Bool) -> Void in
                
              self.navigationController?.popViewControllerAnimated(true)
                
        }

  
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 25
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    func CommentRefreshDetail() {
        self.refresh()
    }
    
    
     @IBAction func deleteTouchUpnside(sender: UIButton) {
     
        Functions.shakeView(sender)
        Services.deletePost(self.post.post_id, andHandler: { (response) -> Void in
            let tracker = GAI.sharedInstance().defaultTracker
            
            tracker.send(GAIDictionaryBuilder.createEventWithCategory("Post", action: "Delete Post", label: "Delete Post", value: nil).build() as [NSObject : AnyObject])
            
            self.navigationController?.popViewControllerAnimated(true)
            }) { (err) -> Void in
                
                
                
        }
        
    }
    
    @IBAction func denounceTouchUpInside(sender: UIButton) {
        self.denounceButton.transform = CGAffineTransformMakeScale(0.01, 0.01)
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.00, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            
            self.denounceButton.transform = CGAffineTransformMakeScale(1, 1)
            
            
            }) { (Bool) -> Void in
        self.alert = SCLAlertView()
        self.alert.addButton(NSLocalizedString("Yes",comment:""), target:self, selector:#selector(PostDetailViewController.denunciar))
        self.alert.addButton(NSLocalizedString("No",comment:""), target:self, selector:#selector(PostDetailViewController.cancelarDenounce))
        self.alert.hideWhenBackgroundViewIsTapped = true
        self.alert.showCloseButton = false
        self.alert.showWarning(NSLocalizedString("Denounce",comment:""), subTitle: String(format: NSLocalizedString("Are you sure you want to denounce %@ for posting: '%@' ?", comment: ""), self.post.post_user.name,self.post.post_title))
        }
    }
    
    func denunciar(){
        
        self.alert.hideView()
        Services.denouncePost(self.post.post_id, andHandler: { (response) -> Void in
            let tracker = GAI.sharedInstance().defaultTracker
            
            tracker.send(GAIDictionaryBuilder.createEventWithCategory("Post", action: "Denounce Post", label: "Denounce Post", value: nil).build() as [NSObject : AnyObject])
            self.alert = SCLAlertView()
            self.alert.addButton(NSLocalizedString("OK",comment:""), target:self, selector:#selector(PostDetailViewController.cancelarDenounce))
            self.alert.hideWhenBackgroundViewIsTapped = true
            self.alert.showCloseButton = false
            self.alert.showSuccess(NSLocalizedString("Success",comment:""), subTitle: String(format: NSLocalizedString("You have succesfully denounced %@ for posting: '%@'", comment: ""), self.post.post_user.name,self.post.post_title))
            
            
            }) { (err) -> Void in
                
                
                
        }
        
    }
    
    
    func cancelarDenounce(){
        
        self.alert.hideView()
        
    }
    func OKSinTextPost(){
        self.alert.hideView()
        
    }
}
