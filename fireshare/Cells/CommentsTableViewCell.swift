//
//  CommentsTableViewCell.swift
//  fireshare
//
//  Created by Riyad Anabtawi on 1/12/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    
     @IBOutlet var comment_owner_name: UILabel!
     @IBOutlet var comment_owner_avatar: UIImageView!
     @IBOutlet var comment_content: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    func displayComment(comment:Comments){
    
    
    
    }
}
