//
//  HomeViewController.swift
//  fireshare
//
//  Created by Riyad Anabtawi on 1/6/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

import UIKit
import CoreLocation
class HomeViewController: GAITrackedViewController,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,SWRevealViewControllerDelegate,UIAlertViewDelegate,CLLocationManagerDelegate,HomeCellDelegate,MAActivityIndicatorViewDelegate {
    
    
    var indicatorView1 : MAActivityIndicatorView!

    var locationManager = CLLocationManager()
    var posts_array:[AnyObject] = []
    var selectedUser:Users!
    @IBOutlet var posts_tableView: UITableView!
    @IBOutlet var sigoutButton: UIButton!
    var alert = SCLAlertView()
    var LatitudeString:String!
    var LongitudeString:String!
   
    var preventAnimation = Set<NSIndexPath>()
     @IBOutlet var user_main_avatar: UIImageView!
    @IBOutlet var user_main_name: UILabel!
    @IBOutlet var send_button_post: UIButton!
    @IBOutlet var count_caracterrsLabel: UILabel!
     @IBOutlet var navView: UIImageView!
    @IBOutlet var frase_text_field: UITextView!
    var selectedPost:Posts!
   var refreshControl:UIRefreshControl!
    override func viewDidLoad() {
        
        let tracker  = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value:"Vista Home")
        let build = GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject]
        tracker.send(build)
        
     
        self.posts_tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
       
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("", comment: ""))
        self.refreshControl.addTarget(self, action: #selector(HomeViewController.callhomeService), forControlEvents: UIControlEvents.ValueChanged)
        self.posts_tableView.addSubview(refreshControl)
     
        
        self.count_caracterrsLabel.font = UIFont(name: FONT_BOLD_ITALIC, size: self.count_caracterrsLabel.font.pointSize)

        self.user_main_avatar.layer.cornerRadius = 2
        self.user_main_avatar.layer.masksToBounds = true
        self.user_main_name.font = UIFont(name: FONT_BOLD, size: self.user_main_name.font.pointSize)
        self.frase_text_field.font = UIFont(name: FONT_LIGHT, size: self.frase_text_field.font!.pointSize)
       
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
     
        super.viewDidLoad()
       
        
        self.view.layoutIfNeeded()
      
        // Do any additional setup after loading the view.
        

       
  
    }
    
    override func viewDidAppear(animated: Bool) {
        self.count_caracterrsLabel.text = NSLocalizedString("100 characters", comment:"")
        self.frase_text_field.text = NSLocalizedString("Write your phrase here...", comment:"")
        self.refresh()
        
            }
    
    
    func refresh(){
    
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let user = NSKeyedUnarchiver.unarchiveObjectWithData(defaults.objectForKey("user_main")as! NSData) as! Users
        
        
        
        
        self.user_main_avatar.image = UIImage(named: "user.png")
        self.user_main_avatar.sd_setImageWithURL(NSURL(string: user.avatar_url)) { (image, err, SDImageCacheType, url) -> Void in
            if (image != nil){
                
                self.user_main_avatar.image = image
                
            }else{
                self.user_main_avatar.image = UIImage(named: "user.png")
            }
            
            
            
        }
        
        
        
        self.user_main_name.text = user.name
        self.callhomeService()

    }
 
  
  
    
  @IBAction func psot(sender: UIButton) {
    
   
    

        let defaults = NSUserDefaults.standardUserDefaults()
        
        let user = NSKeyedUnarchiver.unarchiveObjectWithData(defaults.objectForKey("user_main")as! NSData) as! Users
    
    
    self.send_button_post.transform = CGAffineTransformMakeScale(0.01, 0.01)
    
    UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.00, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
        
        self.send_button_post.transform = CGAffineTransformMakeScale(1, 1)
        
        
        }) { (Bool) -> Void in
            
            if self.frase_text_field.text == NSLocalizedString("Write your phrase here..." , comment: "") || self.frase_text_field.text == ""{
         
                self.alert = SCLAlertView()
                self.alert.addButton("OK", target:self, selector:#selector(HomeViewController.OKSinTextPost))
              
                self.alert.hideWhenBackgroundViewIsTapped = true
                self.alert.showCloseButton = false
                self.alert.showError("Ooops", subTitle: NSLocalizedString("You have to write something before posting" , comment: ""))
                
            }else{
                
                let locManager = CLLocationManager()
                locManager.requestWhenInUseAuthorization()
                
                var currentLocation = CLLocation!()
                
                if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
                    CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Authorized){
                        
                        currentLocation = locManager.location
                        
                }
                
                if (currentLocation != nil){
                
                    let longitude :CLLocationDegrees = currentLocation.coordinate.longitude
                    let latitude :CLLocationDegrees = currentLocation.coordinate.latitude
                    
                    let location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
                    
                    
                    CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                        
                        
                        if error != nil {
                            
                            return
                        }
                        
                        if placemarks!.count > 0 {
                            let pm = placemarks![0]
                            print(pm.locality)
                            Services.createPostForUser(user.user_id, andTitleOfPost: self.frase_text_field.text + "...", andAdress: pm.locality!, andLatitude: CGFloat(currentLocation.coordinate.latitude), andLongitude: CGFloat(currentLocation.coordinate.longitude),andCountry:pm.country, andHandler: { (response) -> Void in
                                
                                
                                let tracker = GAI.sharedInstance().defaultTracker
                                
                                tracker.send(GAIDictionaryBuilder.createEventWithCategory("Post", action: "Create Post", label: "Create Post", value: nil).build() as [NSObject : AnyObject])
                                self.frase_text_field.text = ""
                                self.frase_text_field.text = NSLocalizedString("Write your phrase here...", comment:"")
                                self.frase_text_field.textColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1.0)
                                self.frase_text_field.resignFirstResponder()
                                self.count_caracterrsLabel.textColor = UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 0.5)
                                
                              
                                
                                
                              //  let arrayOfPosts = self.posts_array
                                
                                let post = response as! Posts
                                
                                let arrayMutable = NSMutableArray()
                                arrayMutable.addObject(post)
                                arrayMutable.addObjectsFromArray(self.posts_array)
                                
                                var array = [AnyObject]()
                                
                                array = arrayMutable as [AnyObject]
                                self.posts_array = array
                                self.posts_tableView.hidden = false
                                self.posts_tableView.reloadData()
                                }, orErrorHandler: { (err) -> Void in
                                    
                                    
                                    
                            })
                            
                        }
                        else {
                            
                        }
                    })
                    
                }else{
                
                    
                    self.showError()
                    self.alert = SCLAlertView()
                    self.alert.addButton(NSLocalizedString("OK",comment:""), target:self, selector:#selector(HomeViewController.OKSinTextPost))
                    
                    self.alert.hideWhenBackgroundViewIsTapped = true
                    self.alert.showCloseButton = false
                    self.alert.showWarning(NSLocalizedString("Oops",comment:""), subTitle: NSLocalizedString("There was an error while fetching your location. Please try again.",comment:""))
                
                }
              
              
            }
            

            
    }
    
    
    
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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
 

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "postDetail"{
        
        
            let controller = segue.destinationViewController as! PostDetailViewController
            
            controller.post = self.selectedPost
        }
        
        
        
        if segue.identifier == "user"{
        
        let controller = segue.destinationViewController as! ProfileViewController
            
        controller.user = self.selectedUser
        
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("home", forIndexPath: indexPath) as! HomeTableViewCell
        
        cell.delegate = self
        cell.displayPost(self.posts_array[indexPath.row] as! Posts, atindex: indexPath)
  
     
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = self.posts_array[indexPath.row] as! Posts
        
        
        if post.comments.count != 0{
            
            return 265
        }else{
            
            return 130
            
        }
     
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
  
        self.selectedPost = self.posts_array[indexPath.row]  as! Posts
     
        self.performSegueWithIdentifier("postDetail", sender: self)
        
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.posts_array.count
        
        
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
        
        return 1
    }
    
    
 
    
    
    func callhomeService(){
        
          self.posts_tableView.hidden = true
     
        
        self.alert.hideView()
        self.showLoader()
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()

        var currentLocation = CLLocation!()

        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Authorized){
                currentLocation = locManager.location
        }
        
        if (currentLocation != nil){
           
            let longitude :CLLocationDegrees = currentLocation.coordinate.longitude
            let latitude :CLLocationDegrees = currentLocation.coordinate.latitude
            
            let location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
            
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                
                
                if error != nil {
                    
                    return
                }
                
                if placemarks!.count > 0 {
                    let pm = placemarks![0]
                    print(pm.locality)
                    
            Services.getAllPostsforScope(pm.country, andAddress: pm.locality, andLatitude: CGFloat(currentLocation.coordinate.latitude), andLongitude: CGFloat(currentLocation.coordinate.longitude), andHandler: { (response) -> Void in



        
        self.hideError()
        self.posts_array = response as! [Posts]
        self.frase_text_field.resignFirstResponder()
        self.count_caracterrsLabel.textColor = UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 0.5)
        
            if self.posts_array.count != 0{
            self.refreshControl.endRefreshing()
            self.posts_tableView.hidden = false
            self.posts_tableView.reloadData()
            
        }else{
            self.alert = SCLAlertView()
            self.alert.addButton(NSLocalizedString("OK",comment:""), target:self, selector:#selector(HomeViewController.OKSinTextPost))
            self.posts_tableView.hidden = true
            self.alert.hideWhenBackgroundViewIsTapped = true
            self.alert.showCloseButton = false
            self.alert.showWarning(NSLocalizedString("Oops",comment:""), subTitle: NSLocalizedString("It seems there are no posts near you. Be the first to post a new phrase.",comment:""))
            
        }
        self.hideLoader()
        
    }) { (err) -> Void in
    self.refreshControl.endRefreshing()
    self.hideLoader()
    self.showError()
    
    }

                }
                else {
                    self.showError()
                    self.hideLoader()
                    self.refreshControl.endRefreshing()
      
                }
            })
            
        }else{
            self.refreshControl.endRefreshing()
            self.alert = SCLAlertView()
            self.alert.addButton(NSLocalizedString("OK",comment:""), target:self, selector:#selector(HomeViewController.logout))
              self.hideLoader()
            self.alert.hideWhenBackgroundViewIsTapped = true
            self.alert.showCloseButton = false
            self.alert.showWarning(NSLocalizedString("Oops",comment:""), subTitle: NSLocalizedString("There was an error while fetching your location. Please enable location services.",comment:""))
              self.hideLoader()
        }
        

      
    
    }
    
    func showError(){
        self.refreshControl.endRefreshing()
        self.alert = SCLAlertView()
        self.alert.addButton("Tap to refresh", target:self, selector:#selector(HomeViewController.callhomeService))
        
        self.alert.hideWhenBackgroundViewIsTapped = true
        self.alert.showCloseButton = false
        self.alert.showError("Ooops", subTitle: NSLocalizedString("OOPS, IT SEEMS WE HAVE A SHORT CIRCUIT. AT THIS MOMENT WE ARE UNABLE TO LOAD ANY POSTS" , comment: ""))
    
    }
    
    
    func hideError(){
           self.alert.hideView()
    
    }
    
    
    
    func selectedMenuOptionWithString(string: String) {
        
        
        
    }


    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        if textView.text == NSLocalizedString("Write your phrase here...", comment:""){
            
            textView.text = ""
      
            
            }
             return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
      
       
        let currentCharacterCount = textView.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + text.characters.count - range.length
        let variable = 100 - newLength
        
      
        if (variable < 0){
            self.count_caracterrsLabel.textColor = UIColor(red: 174.0/255.0, green: 35.0/255.0, blue: 95.0/255.0, alpha: 1)
            
            self.count_caracterrsLabel.text = NSLocalizedString("0 characters", comment:"")
        }else if(variable == 100){
    
    self.frase_text_field.textColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1.0)
         
        }else if(variable == 99){
           
            self.frase_text_field.textColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        }else{
            self.count_caracterrsLabel.textColor = UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 0.5)
            self.frase_text_field.textColor = UIColor(red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1.0)
            self.count_caracterrsLabel.text = NSLocalizedString("\(variable) characters",comment:"")
        }
        
        if text == "\n"{
            
            textView.text = NSLocalizedString("Write your phrase here...", comment:"")
            self.count_caracterrsLabel.text = NSLocalizedString("100 characters",comment:"")
            self.frase_text_field.textColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1.0)
            textView.resignFirstResponder()
        }
        return newLength <= 100
        
    }
    
    
    @IBAction func logoutTouchUpInside(sender: UIButton) {
        self.sigoutButton.transform = CGAffineTransformMakeScale(0.01, 0.01)
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.00, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            
            self.sigoutButton.transform = CGAffineTransformMakeScale(1, 1)
      
}) { (Bool) -> Void in
    
    self.alert = SCLAlertView()
    self.alert.addButton(NSLocalizedString("Yes",comment:""), target:self, selector:#selector(HomeViewController.logout))
    self.alert.addButton(NSLocalizedString("No",comment:""), target:self, selector:#selector(HomeViewController.cancelarAlertLogout))
    self.alert.hideWhenBackgroundViewIsTapped = true
    self.alert.showCloseButton = false
    self.alert.showWarning(NSLocalizedString("Exit FireShare",comment:""), subTitle: NSLocalizedString("Are you sure you want to logout?",comment:""))
    
     }
}

    func logout(){
        
        self.hideLoader()
      self.alert.hideView()
        let tracker = GAI.sharedInstance().defaultTracker
        
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Authentication", action: "Logout", label: "Logout", value: nil).build() as [NSObject : AnyObject])
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("DATE_LOGIN")
        defaults.removeObjectForKey("user_main")
        defaults.synchronize()
        self.navigationController?.popViewControllerAnimated(true)
    
    }

    
    
    func OKSinTextPost(){
    self.alert.hideView()
    
    }
    func cancelarAlertLogout(){
    
    self.alert.hideView()
    
    }
    
    
    
    func showUser(user: Users) {
        self.selectedUser = user
        
        self.performSegueWithIdentifier("user", sender: self)
    }
    
    
    @IBAction func myProfileUpInside(sender: UIButton) {
    
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let user = NSKeyedUnarchiver.unarchiveObjectWithData(defaults.objectForKey("user_main")as!NSData)as!Users
        self.selectedUser = user
        
        self.performSegueWithIdentifier("user", sender: self)
    
    }
    
    
    
    func showLoader(){
    
  
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.indicatorView1 = MAActivityIndicatorView(frame: self.view.frame)
            self.indicatorView1.defaultColor = UIColor.redColor()
            self.indicatorView1.animationDuration    = 1
            self.indicatorView1.numberOfCircles      = 10
            self.indicatorView1.maxRadius            = 40
            self.indicatorView1.delegate = self
            // self.indicatorView1.backgroundColor = UIColor.lightGrayColor()
            self.indicatorView1.startAnimating()
      
            
            
            let window = UIApplication.sharedApplication().keyWindow
         
            
            Functions.fillContainerView(window?.subviews[0], withView: self.indicatorView1)
            
        })

    
    }
    
    
   func hideLoader(){
    if self.indicatorView1 != nil{
    
     self.indicatorView1.removeFromSuperview()
    }
  
    
    }
    
    
    
    func activityIndicatorView(activityIndicatorView: MAActivityIndicatorView, circleBackgroundColorAtIndex index: NSInteger) -> UIColor {
        
        return UIColor(red: 200.0/255.0, green: 68.0/255.0, blue: 75.0/255.0, alpha: 1)
    }

}
