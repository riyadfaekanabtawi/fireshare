//
//  TermsViewController.swift
//  fireshare
//
//  Created by Riyad Anabtawi on 2/8/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {

    
    
    @IBOutlet var terms_webView: UIWebView!
    
    @IBOutlet var terms_accept_button: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.terms_accept_button.titleLabel?.font = UIFont(name: FONT_REGULAR, size: (self.terms_accept_button.titleLabel?.font.pointSize)!)
        
        self.terms_accept_button.layer.cornerRadius = self.terms_accept_button.frame.size.height/2
        self.terms_accept_button.layer.borderColor = UIColor(red: 196.0/255.0, green: 79.0/255.0, blue: 62.0/255.0, alpha: 1).CGColor
        self.terms_accept_button.layer.borderWidth = 1
        self.terms_accept_button.layer.masksToBounds = true
        
        
        self.terms_webView.loadRequest(NSURLRequest(URL: NSURL(string: BASE_URL_TERMS)!))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     @IBAction func AcceptTermsTouchUpInside(sender: UIButton) {
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject("FirstTimeTerms", forKey: "FirstTimeTerms")
        defaults.synchronize()
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
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
