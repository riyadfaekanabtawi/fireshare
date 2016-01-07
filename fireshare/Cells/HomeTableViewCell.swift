//
//  HomeTableViewCell.swift
//  fireshare
//
//  Created by Riyad Anabtawi on 1/6/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    
    @IBOutlet var post_title_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.post_title_label.font = UIFont(name: AVENIR_LIGHT, size: self.post_title_label.font.pointSize)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func displayPost(post:Posts){
    
        self.post_title_label.text = post.post_title
    
    
    
    }
}
