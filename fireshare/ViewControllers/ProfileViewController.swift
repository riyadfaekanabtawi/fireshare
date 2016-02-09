//
//  ProfileViewController.swift
//  fireshare
//
//  Created by Riyad Anabtawi on 2/9/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  
    
 
    
    @IBOutlet var viewTitle: UILabel!
    var alert:SCLAlertView!
    @IBOutlet var posts_tableView: UITableView!
    @IBOutlet var go_back_Button: UIButton!
    @IBOutlet var navView: UIImageView!
    @IBOutlet var post_user_avatar: UIImageView!
    @IBOutlet var post_user_name: UILabel!
    @IBOutlet var frasesCountLabel: UILabel!
    var preventAnimation = Set<NSIndexPath>()
    var user:Users!
    var posts_array:[Posts]=[]
    var selectedPost:Posts!
    
    override func viewDidAppear(animated: Bool) {
        self.callUserProfileService()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tracker  = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value:"Vista Detalle Usuario")
        let build = GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject]
        tracker.send(build)
        
   
        self.frasesCountLabel.font = UIFont(name: FONT_LIGHT, size: self.frasesCountLabel.font.pointSize)
        self.viewTitle.font = UIFont(name: FONT_BOLD, size: self.viewTitle.font.pointSize)
        self.callUserProfileService()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRectMake(0, -20, self.view.frame.size.width, 64)
        gradientLayer.colors = [UIColor(red: 174.0/255.0, green: 35.0/255.0, blue: 95.0/255.0, alpha: 1),UIColor(red: 209.0/255.0, green: 104.0/255.0, blue: 43.0/255.0, alpha: 1)].map{$0.CGColor}
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        
        self.post_user_avatar.layer.cornerRadius = 3
        self.post_user_avatar.layer.masksToBounds = true
        // Render the gradient to UIImage
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Set the UIImage as background property
        self.navView.image = image
        
        
       
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !preventAnimation.contains(indexPath) {
            preventAnimation.insert(indexPath)
            TipInCellAnimator.animate(cell)
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("home", forIndexPath: indexPath) as! HomeTableViewCell
        cell.displayPost(self.posts_array[indexPath.row], atindex: indexPath)
        
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if self.posts_array[indexPath.row].comments.count != 0{
            
            return 260
        }else{
            
            return 100
            
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedPost = self.posts_array[indexPath.row]
        
        self.performSegueWithIdentifier("postDetail", sender: self)
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.posts_array.count
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "postDetail"{
        
        let controller = segue.destinationViewController as! PostDetailViewController
        controller.post = self.selectedPost
        
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        
        return 1
    }
    

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func callUserProfileService(){
    self.alert.hideView()
    Services.getUserInfoWithId(self.user.user_id, andHandler: { (response) -> Void in
        
        self.user = response as! Users
        
        
        self.post_user_name.text = self.user.name
        self.viewTitle.text = self.user.name
        self.frasesCountLabel.text = String(format: NSLocalizedString("%d phrases", comment: ""), self.user.recipes.count)
        self.post_user_avatar.image = UIImage(named: "user.png")
        self.post_user_avatar.sd_setImageWithURL(NSURL(string: self.user.avatar_url)) { (image, err, SDImageCacheType, url) -> Void in
            if (image != nil){
                
                self.post_user_avatar.image = image
                
            }else{
                self.post_user_avatar.image = UIImage(named: "user.png")
            }
            
            
            
        }
        
        
        
        self.posts_array = self.user.recipes as! [Posts]
        
        if (self.posts_array.count != 0){
        
            self.posts_tableView.reloadData()
        
        }
        
        }) { (err) -> Void in
            
            
            
            
        }
    
    }
    
    func showError(){
        self.alert = SCLAlertView()
        self.alert.addButton("Tap to refresh", target:self, selector:Selector("callUserProfileService"))
        
        self.alert.hideWhenBackgroundViewIsTapped = true
        self.alert.showCloseButton = false
        self.alert.showError("Ooops", subTitle: NSLocalizedString("OOPS, IT SEEMS WE HAVE A SHORT CIRCUIT. AT THIS MOMENT WE ARE UNABLE TO LOAD ANY POSTS" , comment: ""))
        
    }
    
    
    func hideError(){
        self.alert.hideView()
        
    }
    
    
    
    
    @IBAction func goBackTouchUpInside(sender: UIButton) {
            
        self.go_back_Button.transform = CGAffineTransformMakeScale(0.01, 0.01)
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.00, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            
            self.go_back_Button.transform = CGAffineTransformMakeScale(1, 1)
            
            
            }) { (Bool) -> Void in
                
                self.navigationController?.popViewControllerAnimated(true)
                
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

}
