//
//  MenuViewController.swift
//  fireshare
//
//  Created by Riyad Anabtawi on 1/27/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

import UIKit
protocol SlideMenuDelegate{
    func selectedMenuOptionWithString(string:String)
    
    
}

class MenuViewController: UIViewController {
    var delegate:SlideMenuDelegate! = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
