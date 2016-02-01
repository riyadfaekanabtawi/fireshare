//
//  HomeViewController.swift
//  fireshare
//
//  Created by Riyad Anabtawi on 1/6/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,SWRevealViewControllerDelegate,SlideMenuDelegate {

    
    var posts_array:[Posts] = []
    @IBOutlet var posts_tableView: UITableView!
    
    var preventAnimation = Set<NSIndexPath>()
     @IBOutlet var user_main_avatar: UIImageView!
    @IBOutlet var user_main_name: UILabel!
    @IBOutlet var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet var scrollViewWidth: NSLayoutConstraint!
    @IBOutlet var allpostsViewWidth: NSLayoutConstraint!
    @IBOutlet var frase_text_field: UITextField!
    
   
    override func viewDidLoad() {
        
        self.user_main_avatar.layer.cornerRadius = 2
        self.user_main_avatar.layer.masksToBounds = true
        self.user_main_name.font = UIFont(name: FONT_BOLD, size: self.user_main_name.font.pointSize)
        self.frase_text_field.font = UIFont(name: FONT_LIGHT, size: self.frase_text_field.font!.pointSize)
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let user = NSKeyedUnarchiver.unarchiveObjectWithData(defaults.objectForKey("user_main")as! NSData) as! Users
        
        
        self.user_main_avatar.sd_setImageWithURL(NSURL(string: user.avatar_url))
        self.user_main_name.text = user.name
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
       
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
        self.navigationController?.navigationBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
        
        super.viewDidLoad()
        
        self.scrollViewHeight.constant  = self.view.frame.size.height - 64
        self.scrollViewWidth.constant = self.view.frame.size.width * 1
        self.allpostsViewWidth.constant = self.view.frame.size.width
       
        self.view.layoutIfNeeded()
      
        // Do any additional setup after loading the view.
        
      self.setUpNav()
       
      self.callhomeService()
    }
    
    
    
    
    
    
    func setUpNav() {
        let menuButton = UIButton(frame: CGRectMake(0, 0, 26, 11))
        
        menuButton.setImage(UIImage(named: ""), forState: UIControlState.Normal)
        
        let rerfreshButton = UIButton(frame: CGRectMake(0, 0, 34, 20))
        
        
        rerfreshButton.setImage(UIImage(named: "iconSend.png"), forState: UIControlState.Normal)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rerfreshButton)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
    
        rerfreshButton.addTarget(self, action: "post", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
  
    
    
    func post(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let user = NSKeyedUnarchiver.unarchiveObjectWithData(defaults.objectForKey("user_main")as! NSData) as! Users
        
        if self.frase_text_field.text == ""{
            let alert = UIAlertController(title: "Ooops", message: "Tienes que escribir algo antes de postear.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        
        
        }else{
        
            Services.createPostForUser(user.user_id, andTitleOfPost: self.frase_text_field.text, andHandler: { (response) -> Void in
                self.frase_text_field.text = ""
                self.callhomeService()
                
                }) { (err) -> Void in
                    
                    
                    
            }
        }
  
    
    }
    
   
     func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !preventAnimation.contains(indexPath) {
            preventAnimation.insert(indexPath)
            TipInCellAnimator.animate(cell)
        }
    }
    
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        cell.displayPost(self.posts_array[indexPath.row])
     
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (self.posts_array[indexPath.row].comments != nil){
        
            if self.posts_array[indexPath.row].comments.count != 0{
                
                return 240
            }else{
                
                return 100
                
            }
        }else{
        
        return 0
        }
       
        
     
     
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
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
        
        if self.posts_array.count != 0{
             self.posts_tableView.reloadData()
        
        }
        }) { (err) -> Void in
            
            
            
        }
    
    }
    
 
    func selectedMenuOptionWithString(string: String) {
        
        
        
    }

    
  
}
