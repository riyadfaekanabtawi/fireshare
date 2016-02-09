//
//  HomeTableViewCell.swift
//  fireshare
//
//  Created by Riyad Anabtawi on 1/6/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet var post_title_label: UILabel!
    @IBOutlet var tableView_height: NSLayoutConstraint!
    @IBOutlet var post_user_name_label: UILabel!
    @IBOutlet var timeLabel: UILabel!
    var array_comments:[Comments] = []
    @IBOutlet var commentTableView: UICollectionView!
    @IBOutlet var user_owner_avatar: UIImageView!
    
    @IBOutlet var first_user: UIImageView!
    @IBOutlet var second_user: UIImageView!
    @IBOutlet var third_user: UIImageView!
    @IBOutlet var first_User_width: NSLayoutConstraint!
    @IBOutlet var second_User_width: NSLayoutConstraint!
    @IBOutlet var third_User_width: NSLayoutConstraint!
     @IBOutlet var footerHeight: NSLayoutConstraint!
    @IBOutlet var commentCountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.first_user.layer.cornerRadius = 2
        self.first_user.layer.masksToBounds = true
        
        self.second_user.layer.cornerRadius = 2
        self.second_user.layer.masksToBounds = true
        
        self.third_user.layer.cornerRadius = 2
        self.third_user.layer.masksToBounds = true
        self.user_owner_avatar.layer.cornerRadius = 2
        self.user_owner_avatar.layer.masksToBounds = true
        self.commentCountLabel.font = UIFont(name: FONT_BOLD, size: self.commentCountLabel.font.pointSize)
        self.timeLabel.font = UIFont(name: FONT_REGULAR, size: self.timeLabel.font.pointSize)
        self.post_title_label.font = UIFont(name: FONT_REGULAR, size: self.post_title_label.font.pointSize)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func displayPost(post:Posts, atindex:NSIndexPath){
        
        if post.hours_since.integerValue <= 0 && post.minutes_since.integerValue <= 0 && post.seconds_since.integerValue > 0{
            
            self.timeLabel.text = String(format: NSLocalizedString("%@ sec ago", comment: ""), post.seconds_since)
            
        }
        
        if post.hours_since.integerValue <= 0 && post.minutes_since.integerValue > 0 && post.seconds_since.integerValue > 0{
            
            self.timeLabel.text = String(format: NSLocalizedString("%@ min ago", comment: ""), post.minutes_since)
            
        }
        
        
        if post.hours_since.integerValue > 0 && post.minutes_since.integerValue > 0 && post.seconds_since.integerValue > 0{
            
            
            
            self.timeLabel.text = String(format: NSLocalizedString("%@ hs ago", comment: ""), post.hours_since)
            
        }
        
        if post.days_since.integerValue > 0 && post.hours_since.integerValue > 0 && post.minutes_since.integerValue > 0 && post.seconds_since.integerValue > 0{
            
            
            
            self.timeLabel.text = String(format: NSLocalizedString("%@ days ago", comment: ""), post.days_since)
            
        }
        

        if (post.comments.count == 0){
        
        self.footerHeight.constant = 0
        
        }else{
        self.footerHeight.constant = 34
        
        }
        self.post_title_label.text = post.post_title
        self.post_user_name_label.text = post.post_user.name
      
    
       
        self.user_owner_avatar.image = UIImage(named: "user.png")
        self.user_owner_avatar.sd_setImageWithURL(NSURL(string: post.post_user.avatar_url)) { (image, err, SDImageCacheType, url) -> Void in
            if (image != nil){
                
                self.user_owner_avatar.image = image
                
            }else{
                self.user_owner_avatar.image = UIImage(named: "user.png")
            }
            
            
            
        }
        self.array_comments = post.comments as! [Comments]
        self.commentTableView.reloadData()
    
    
    }
 

   

 
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("comments", forIndexPath: indexPath) as! CommentCollectionViewCell
         let comment = self.array_comments[indexPath.row]
        
        
       
        if self.array_comments.count != 0{
        
            if self.array_comments.count == 3{
                self.first_User_width.constant = 20
                self.second_User_width.constant = 20
                self.third_User_width.constant = 20
                
                self.first_user.sd_setImageWithURL(NSURL(string: self.array_comments[0].user_owner.avatar_url))
                self.second_user.sd_setImageWithURL(NSURL(string: self.array_comments[1].user_owner.avatar_url))
                self.third_user.sd_setImageWithURL(NSURL(string: self.array_comments[2].user_owner.avatar_url))
                
            }else if self.array_comments.count == 2{
                self.first_User_width.constant = 20
                self.second_User_width.constant = 20
                self.third_User_width.constant = 0
                self.first_user.sd_setImageWithURL(NSURL(string: self.array_comments[0].user_owner.avatar_url))
                self.second_user.sd_setImageWithURL(NSURL(string: self.array_comments[1].user_owner.avatar_url))
                
            }else if self.array_comments.count == 1{
                self.first_User_width.constant = 20
                self.second_User_width.constant = 0
                self.third_User_width.constant = 0
                
                self.first_user.sd_setImageWithURL(NSURL(string: self.array_comments[0].user_owner.avatar_url))
                
            }else  if self.array_comments.count >= 3{
                self.first_User_width.constant = 20
                self.second_User_width.constant = 20
                self.third_User_width.constant = 20
                
                self.first_user.sd_setImageWithURL(NSURL(string: self.array_comments[0].user_owner.avatar_url))
                self.second_user.sd_setImageWithURL(NSURL(string: self.array_comments[1].user_owner.avatar_url))
                self.third_user.sd_setImageWithURL(NSURL(string: self.array_comments[2].user_owner.avatar_url))
                
            }
            
            
            self.commentCountLabel.text = "+ \(self.array_comments.count)"
            
            
            cell.displayComment(comment)
       
            if (indexPath.row == 0){
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.first_user.alpha = 1
                    self.second_user.alpha = 0.5
                    self.third_user.alpha = 0.5
                    
                    cell.fireIcon.alpha = 1
                })
            }else if (indexPath.row == 1){
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.first_user.alpha = 0.5
                    self.second_user.alpha = 1
                    self.third_user.alpha = 0.5
                    cell.fireIcon.alpha = 0
                    
                })
            }else if(indexPath.row == 2){
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.first_user.alpha = 0.5
                    self.second_user.alpha = 0.5
                    self.third_user.alpha = 1
                    cell.fireIcon.alpha = 0
                    
                })
            }else{
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    
                    cell.fireIcon.alpha = 0
                    self.first_user.alpha = 0.5
                    self.second_user.alpha = 0.5
                    self.third_user.alpha = 0.5
                })
                
            }
            

        }
        
        
        return cell
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
         return CGSizeMake(self.frame.size.width-40, 160)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
     return self.array_comments.count
        
    }
}
