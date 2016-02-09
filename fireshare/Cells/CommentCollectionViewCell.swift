//
//  CommentCollectionViewCell.swift
//  fireshare
//
//  Created by Riyad Anabtawi on 2/1/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

import UIKit
protocol CommentDelegate{
    func CommentRefreshDetail()
    
    
}

class CommentCollectionViewCell: UICollectionViewCell {
    var delegate:CommentDelegate! = nil
    @IBOutlet var comment_owner_name: UILabel!
    @IBOutlet var date_label: UILabel!
    @IBOutlet var comment_owner_avatar: UIImageView!
    @IBOutlet var fireIcon: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var trashIcon_width: NSLayoutConstraint!
    var alert = SCLAlertView()
    @IBOutlet var unlikeButton: UIButton!
     @IBOutlet var fireIcon_width: NSLayoutConstraint!
    @IBOutlet var timeTrailing: NSLayoutConstraint!
    @IBOutlet var comment_content: UILabel!
    var current_comment:Comments!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.comment_owner_name.font = UIFont(name: FONT_REGULAR, size: self.comment_owner_name.font.pointSize)
        self.comment_owner_avatar.layer.cornerRadius = 2
        self.comment_owner_avatar.layer.masksToBounds = true
        
        if ( self.date_label != nil){
        
           self.date_label.font = UIFont(name: FONT_REGULAR, size: self.date_label.font.pointSize)
        }
     
        
    
    }
    
 
    
    func displayComment(comment:Comments){
        self.current_comment = comment
       
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let user = NSKeyedUnarchiver.unarchiveObjectWithData(defaults.objectForKey("user_main")as! NSData) as! Users
        if (self.trashIcon_width != nil){
        if user.user_id == comment.user_owner.user_id{
        
            self.trashIcon_width.constant = 34
        
        }else{
         self.trashIcon_width.constant = 0
        
        }
        }
        self.layoutIfNeeded()
        
        if (self.likeButton != nil && self.unlikeButton != nil){
            if comment.voted_string  == "voted up"{
                
                self.likeButton.selected = true
                self.unlikeButton.selected = false
                
            }else if comment.voted_string == "voted down"{
                
                self.likeButton.selected = false
                self.unlikeButton.selected = true
                
            }else{
                
                self.likeButton.selected = false
                self.unlikeButton.selected = false
            }
            
        
        }
     
        if ( self.date_label != nil){
        if comment.hours_since.integerValue <= 0 && comment.minutes_since.integerValue <= 0 && comment.seconds_since.integerValue > 0{
            
            self.date_label.text = String(format: NSLocalizedString("%@ sec ago", comment: ""), comment.seconds_since)
            
            
        }
        
        if comment.hours_since.integerValue <= 0 && comment.minutes_since.integerValue > 0 && comment.seconds_since.integerValue > 0{
            
            self.date_label.text = String(format: NSLocalizedString("%@ min ago", comment: ""), comment.minutes_since)
            
        }
        
        
        if comment.hours_since.integerValue > 0 && comment.minutes_since.integerValue > 0 && comment.seconds_since.integerValue > 0{
            
            
            
            self.date_label.text = String(format: NSLocalizedString("%@ hs ago", comment: ""), comment.hours_since)
            
        }
        
        if comment.days_since.integerValue > 0 && comment.hours_since.integerValue > 0 && comment.minutes_since.integerValue > 0 && comment.seconds_since.integerValue > 0{
            
            
            
            self.date_label.text = String(format: NSLocalizedString("%@ days ago", comment: ""), comment.days_since)
            
        }
        
        }
        
        self.comment_owner_name.text = comment.user_owner.name;
        self.comment_owner_avatar.image = UIImage(named: "user.png")
        self.comment_owner_avatar.sd_setImageWithURL(NSURL(string: comment.user_owner.avatar_url)) { (image, err, SDImageCacheType, url) -> Void in
            if (image != nil){
            
                self.comment_owner_avatar.image = image
            
            }else{
            self.comment_owner_avatar.image = UIImage(named: "user.png")
            }
        
            
            
        }
        self.comment_owner_avatar.sd_setImageWithURL(NSURL(string: comment.user_owner.avatar_url))
        self.comment_content.text = comment.comment_content
        
        
    }
    
    
    
    
    @IBAction func LikeTouchUpInside(sender: UIButton) {
        
        
        self.likeButton.transform = CGAffineTransformMakeScale(0.01, 0.01)
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.00, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            
            self.likeButton.transform = CGAffineTransformMakeScale(1, 1)
            
            
            }) { (Bool) -> Void in
                
                let defaults = NSUserDefaults.standardUserDefaults()
                let user = NSKeyedUnarchiver.unarchiveObjectWithData(defaults.objectForKey("user_main")as! NSData) as! Users
                
                Services.AddLikeForComment(user.user_id, commentID: self.current_comment.comment_id, andHandler: { (response) -> Void in
                    
                   self.delegate.CommentRefreshDetail()
                    }) { (err) -> Void in
                        
                        
                        
                }
                
        }

       
    }
    
    
    @IBAction func unLikeTouchUpInside(sender: UIButton) {
        self.unlikeButton.transform = CGAffineTransformMakeScale(0.01, 0.01)
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.00, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            
            self.unlikeButton.transform = CGAffineTransformMakeScale(1, 1)
            
            
            }) { (Bool) -> Void in
                
                let defaults = NSUserDefaults.standardUserDefaults()
                let user = NSKeyedUnarchiver.unarchiveObjectWithData(defaults.objectForKey("user_main")as! NSData) as! Users
                Services.removeLikeFromComment(user.user_id, commentID: self.current_comment.comment_id, andHandler: { (response) -> Void in
                    
                     self.delegate.CommentRefreshDetail()
                    
                    }) { (err) -> Void in
                        
                        
                        
                }

                
        }

          }

    
    @IBAction func denounceTouchUpInside(sender: UIButton) {
     
        self.alert = SCLAlertView()
        self.alert.addButton(NSLocalizedString("Yes",comment:""), target:self, selector:Selector("denunciar"))
        self.alert.addButton(NSLocalizedString("No",comment:""), target:self, selector:Selector("cancelarDenounce"))
        self.alert.hideWhenBackgroundViewIsTapped = true
        self.alert.showCloseButton = false
   
        
        self.alert.showWarning(NSLocalizedString("Denounce",comment:""), subTitle: String(format: NSLocalizedString("Are you sure you want to denounce %@ for commenting: '%@' ?", comment: ""),self.current_comment.user_owner.name ,self.current_comment.comment_content))
        
    }
    
    func denunciar(){
    
        self.alert.hideView()
        Services.denounceComment(self.current_comment.comment_id, andHandler: { (response) -> Void in
            
            self.alert = SCLAlertView()
            self.alert.addButton(NSLocalizedString("OK",comment:""), target:self, selector:Selector("cancelarDenounce"))
            self.alert.hideWhenBackgroundViewIsTapped = true
            self.alert.showCloseButton = false
            self.alert.showSuccess(NSLocalizedString("Success",comment:""), subTitle: String(format: NSLocalizedString("You have succesfully denounced %@ for commenting: '%@'", comment: ""), self.current_comment.user_owner.name,self.current_comment.comment_content))
            
            
            }) { (err) -> Void in
                
                
                
        }
    
    }
    
    
    func cancelarDenounce(){
    
    self.alert.hideView()
    
    }
    @IBAction func deleteTouchUpInside(sender: UIButton) {
        
        Functions.shakeView(sender)
        Services.deleteComment(self.current_comment.comment_id, andHandler: { (response) -> Void in
            self.delegate.CommentRefreshDetail()
            
            }) { (err) -> Void in
                
                
                
        }
    }
}
