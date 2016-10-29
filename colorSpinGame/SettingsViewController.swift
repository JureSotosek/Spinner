//
//  AboutViewController.swift
//  colorSpinGame
//
//  Created by Jure Sotosek on 03/01/16.
//  Copyright © 2016 Jure Sotosek. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var advancedControllsOutlet: UISwitch!
    
    @IBOutlet weak var mainBackView: MainBackView!
    @IBOutlet weak var rotateScrollView: RotateScrollView!
    @IBOutlet weak var rotateScrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var sensitivityBarOutlet: UISlider!
    @IBOutlet weak var volumeSwitchOutlet: UISwitch!
    @IBAction func sensitivityBar(sender: UISlider) {
        defaults.setDouble(Double(sender.value), forKey: "Sensitivity")
    }
    @IBAction func volumeSwitch(sender: UISwitch) {
        if sender.on {
            defaults.setBool(true, forKey: "volume")
        }else{
            defaults.setBool(false, forKey: "volume")
        }
    }
    @IBOutlet weak var difficultyButtonEasyOutlet: UIButton!
    @IBOutlet weak var difficultyButtonNormalOutlet: UIButton!
    @IBOutlet weak var difficultyButtonHardOutlet: UIButton!
    
    @IBAction func difficultyButtons(sender: UIButton) {
        switch sender.currentTitle! {
        case "Easy": defaults.setInteger(0, forKey: "difficulty")
        difficultyButtonEasyOutlet.backgroundColor = UIColor(red: 0.55, green: 0.55, blue: 0.5, alpha: 1)
        difficultyButtonNormalOutlet.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.7, alpha: 1)
        difficultyButtonHardOutlet.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.7, alpha: 1)
        case "Normal": defaults.setInteger(1, forKey: "difficulty")
        difficultyButtonEasyOutlet.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.7, alpha: 1)
        difficultyButtonNormalOutlet.backgroundColor = UIColor(red: 0.55, green: 0.55, blue: 0.5, alpha: 1)
        difficultyButtonHardOutlet.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.7, alpha: 1)
        case "Hard": defaults.setInteger(2, forKey: "difficulty")
        difficultyButtonEasyOutlet.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.7, alpha: 1)
        difficultyButtonNormalOutlet.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.7, alpha: 1)
        difficultyButtonHardOutlet.backgroundColor = UIColor(red: 0.55, green: 0.55, blue: 0.5, alpha: 1)
        default: break
        }
    }
    let defaults = NSUserDefaults()
    
    @IBAction func advancedControlls(sender: UISwitch) {
        if sender.on == true {
            defaults.setBool(false, forKey: "Normal Controlls")
            rotateScrollViewHeight.constant = 70
            rotateScrollView.backgroundColor = UIColor.darkGrayColor()
        }else{
            defaults.setBool(true, forKey: "Normal Controlls")
            rotateScrollViewHeight.constant = 302
            rotateScrollView.backgroundColor = UIColor(white: 1, alpha: 0)
        }
        viewDidLayoutSubviews()
    }
    
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.setAnimationsEnabled(false)
        
        let buttonColor = UIColor(red: 0.75, green: 0.75, blue: 0.7, alpha: 1)
        menuView.backgroundColor = UIColor(red: 0.85, green: 0.8, blue: 0.65, alpha: 1)
        mainBackView.backgroundColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        backButton.backgroundColor = buttonColor
        difficultyButtonEasyOutlet.backgroundColor = buttonColor
        difficultyButtonNormalOutlet.backgroundColor = buttonColor
        difficultyButtonHardOutlet.backgroundColor = buttonColor
        let defaults = NSUserDefaults()
        if defaults.boolForKey("Normal Controlls") == false{
            advancedControllsOutlet.setOn(true, animated: true)
        }
        sensitivityBarOutlet.value = Float(defaults.doubleForKey("Sensitivity"))
        volumeSwitchOutlet.setOn(defaults.boolForKey("volume"), animated: false)
    }
    override func viewDidLayoutSubviews() {
        if defaults.boolForKey("Normal Controlls") == true {
            rotateScrollViewHeight.constant = 302
            rotateScrollView.backgroundColor = UIColor(white: 1, alpha: 0)
        }else{
            rotateScrollViewHeight.constant = 70
            rotateScrollView.backgroundColor = UIColor.darkGrayColor()
        }
        switch defaults.integerForKey("difficulty") {
        case 0: difficultyButtonEasyOutlet.backgroundColor = UIColor(red: 0.55, green: 0.55, blue: 0.5, alpha: 1)
        case 1: difficultyButtonNormalOutlet.backgroundColor = UIColor(red: 0.55, green: 0.55, blue: 0.5, alpha: 1)
        case 2: difficultyButtonHardOutlet.backgroundColor = UIColor(red: 0.55, green: 0.55, blue: 0.5, alpha: 1)
        default: break
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "SettingsScreen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
}