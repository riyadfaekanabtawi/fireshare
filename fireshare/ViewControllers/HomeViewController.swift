//
//  HomeViewController.swift
//  fireshare
//
//  Created by Riyad Anabtawi on 1/6/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    var posts_array:[Posts] = []
    @IBOutlet var posts_tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // Do any additional setup after loading the view.
        
        let menuButton = UIButton(frame: CGRectMake(0, 0, 40, 26))
        menuButton.imageEdgeInsets = UIEdgeInsetsMake(6, -5, 7, 25)
        menuButton.setImage(UIImage(named: "add photo.png"), forState: UIControlState.Normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)
        
        menuButton.addTarget(self, action: "CreatePost:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.callhomeService()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc internal func CreatePost( sender : AnyObject? ) {
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let data = defaults.objectForKey("user_main") as! NSData
        let user = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Users
        
        
        
        
//        Services.createPostForUser(user.user_id, andTitleOfPost: "what everrrr", andHandler: { (response) -> Void in
//              self.callhomeService()
//            }) { (err) -> Void in
//                
//                
//                
//        }
        
        
        Services.createCommentForPost(1, byUser: user.user_id, andComment: "asddsaasddsadasads", andHandler: { (response) -> Void in
            
            
            }) { (err) -> Void in
                
                
                
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("home", forIndexPath: indexPath) as! HomeTableViewCell
        
        let post = self.posts_array[indexPath.row]
        cell.displayPost(post)
        
        return cell
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 45
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.posts_array.count
        
        
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
        
        return 1
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
        
        
    }
    
    
    
    func callhomeService(){
    
    Services.getAllPosts({ (response) -> Void in
        
        
        
        self.posts_array = response as! [Posts]
        
        if self.posts_array.count == 0{
        
        
        }else{
        
            self.posts_tableView.reloadData()
        
        }
        }) { (err) -> Void in
            
            
            
        }
    
    }

}
