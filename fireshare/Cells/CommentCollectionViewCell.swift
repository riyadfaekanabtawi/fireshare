//
//  CommentCollectionViewCell.swift
//  fireshare
//
//  Created by Riyad Anabtawi on 2/1/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

import UIKit

class CommentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var comment_owner_name: UILabel!
    @IBOutlet var comment_owner_avatar: UIImageView!
    @IBOutlet var fireIcon: UIImageView!
    @IBOutlet var comment_content: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.comment_owner_name.font = UIFont(name: FONT_REGULAR, size: self.comment_owner_name.font.pointSize)
        self.comment_owner_avatar.layer.cornerRadius = 2
        self.comment_owner_avatar.layer.masksToBounds = true
        
        
    
    }
    
 
    
    func displayComment(comment:Comments){
        
        
        
        self.comment_owner_name.text = comment.user_owner.name;
        self.comment_owner_avatar.sd_setImageWithURL(NSURL(string: comment.user_owner.avatar_url))
        self.comment_content.text = comment.comment_content
        
        
    }

}
