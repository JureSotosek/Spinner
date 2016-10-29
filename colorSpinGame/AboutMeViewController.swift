//
//  AboutMeViewController.swift
//  colorSpinGame
//
//  Created by Jure Sotosek on 23/04/16.
//  Copyright © 2016 Jure Sotosek. All rights reserved.
//

import UIKit

class AboutMeViewController: UIViewController {
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var mainBackView: MainBackView!
    @IBOutlet weak var rotateScrollView: RotateScrollView!
    @IBOutlet weak var rotateScrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var myTexyView: UITextView!
    
    let defaults = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.setAnimationsEnabled(false)
        
        let buttonColor = UIColor(red: 0.75, green: 0.75, blue: 0.7, alpha: 1)
        menuView.backgroundColor = UIColor(red: 0.85, green: 0.8, blue: 0.65, alpha: 1)
        mainBackView.backgroundColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        backButton.backgroundColor = buttonColor
        myTexyView.backgroundColor = UIColor(white: 0, alpha: 0)
        
    }
    override func viewDidLayoutSubviews() {
        if defaults.boolForKey("Normal Controlls") == true {
            rotateScrollViewHeight.constant = 302
            rotateScrollView.backgroundColor = UIColor(white: 1, alpha: 0)
        }else{
            rotateScrollViewHeight.constant = 70
            rotateScrollView.backgroundColor = UIColor.darkGrayColor()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "AboutMeScreen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
}
