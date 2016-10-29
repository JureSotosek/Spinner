//
//  MenuViewController.swift
//  colorSpinGame
//
//  Created by Jure Sotosek on 23/12/15.
//  Copyright © 2015 Jure Sotosek. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBAction func unwindToMVC(segue: UIStoryboardSegue){
    }
    
    @IBOutlet weak var menuBackView: MenuBackView!
    @IBOutlet weak var rotateScrollView: RotateScrollView!
    
    @IBOutlet weak var rotateScrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var blureView: UIView!
    
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var statsButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var moreFromUsButton: UIButton!
    @IBOutlet weak var upgradeButton: UIButton!
    
    @IBOutlet weak var volumeDisplay: UILabel!
    @IBAction func volumeButton(sender: UIButton) {
        if volumeDisplay.text == "ON" {
            volumeDisplay.text = "OFF"
        }else{
            volumeDisplay.text = "ON"
        }
    }
    let defaults = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.setAnimationsEnabled(false)
        
        let buttonColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        menuBackView.backgroundColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        //blureView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        //menuView.backgroundColor = UIColor(red: 0.85, green: 0.8, blue: 0.65, alpha: 1)
        playButton.backgroundColor = buttonColor
        settingsButton.backgroundColor = buttonColor
        leaderboardButton.backgroundColor = buttonColor
        statsButton.backgroundColor = buttonColor
        aboutButton.backgroundColor = buttonColor
        //rateButton.backgroundColor = buttonColor
        //upgradeButton.backgroundColor = buttonColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        if defaults.objectForKey("Normal Controlls") == nil{
//            defaults.setBool(true, forKey: "Normal Controlls")
//            rotateScrollViewHeight.constant = 302
//            rotateScrollView.backgroundColor = UIColor(white: 1, alpha: 0)
//        }else if defaults.boolForKey("Normal Controlls") == true {
//            rotateScrollViewHeight.constant = 302
//            rotateScrollView.backgroundColor = UIColor(white: 1, alpha: 0)
//        }else{
//            rotateScrollViewHeight.constant = 70
//            rotateScrollView.backgroundColor = UIColor.darkGrayColor()
//        }
        
        titleViewHeight.constant = menuBackView.circleCenter.y-40
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "MenuScreen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        if defaults.integerForKey("difficulty") == 0 {
            playButton.setTitle("Play Easy!", forState: UIControlState.Normal )
        }else if defaults.integerForKey("difficulty") == 1 {
            playButton.setTitle("Play Normal!", forState: UIControlState.Normal )
        }else{
            playButton.setTitle("Play Hard!", forState: UIControlState.Normal )
        }
    }
}