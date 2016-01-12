//
//  HomeTableViewCell.swift
//  fireshare
//
//  Created by Riyad Anabtawi on 1/6/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet var post_title_label: UILabel!
    @IBOutlet var timeLabel: UILabel!
    var array_comments:[Comments] = []
    @IBOutlet var commentTableView: UITableView!
    @IBOutlet var user_owner_avatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.post_title_label.font = UIFont(name: FONT_REGULAR, size: self.post_title_label.font.pointSize)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func displayPost(post:Posts){
    
        self.post_title_label.text = post.post_title
        
        self.array_comments = post.comments as! [Comments]
    
    
        if self.array_comments.count == 0{
        
        
        }else{
        
        self.commentTableView.reloadData()
        
        }
    
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("comment", forIndexPath: indexPath) as! CommentsTableViewCell
        
        
        let comment = self.array_comments[indexPath.row]
        cell.displayComment(comment)
        
        return cell
        
    }
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return self.array_comments.count
    }
}
