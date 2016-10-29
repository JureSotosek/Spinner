//
//  CustomGameViewController.swift
//  colorSpinGame
//
//  Created by Jure Sotosek on 29/12/15.
//  Copyright © 2015 Jure Sotosek. All rights reserved.
//

import UIKit

class CustomGameViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var mainBackView: MainBackView!
    @IBOutlet weak var rotateScrollView: RotateScrollView!
    @IBOutlet weak var rotateScrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var ballVelocityIncreasing: UISwitch!
    @IBOutlet weak var ballVelocityRate: UILabel!
    
    @IBOutlet weak var launchRateIncreasing: UISwitch!
    @IBOutlet weak var launchRateRate: UILabel!
    @IBOutlet weak var launchRateStartingRate: UILabel!
    
    @IBOutlet weak var firstBallDelay: UILabel!
    
    let defaults = NSUserDefaults()
    var settingsSent = false
    
    @IBAction func unwindToCGVC(segue: UIStoryboardSegue){}
    
    @IBAction func ballVelocityRateButton(sender: UIButton) {
        if Int(ballVelocityRate.text!)! < 10 && sender.currentTitle == "+" {
            ballVelocityRate.text = "\(Int(ballVelocityRate.text!)!+1)"
        }else if Int(ballVelocityRate.text!)! > 0 && sender.currentTitle == "-" {
            ballVelocityRate.text = "\(Int(ballVelocityRate.text!)!-1)"
        }
        settingsSent = false
    }
    
    @IBAction func launchRateRateButton(sender: UIButton) {
        if Int(launchRateRate.text!)! < 10 && sender.currentTitle == "+" {
            launchRateRate.text = "\(Int(launchRateRate.text!)!+1)"
        }else if Int(launchRateRate.text!)! > 0 && sender.currentTitle == "-" {
            launchRateRate.text = "\(Int(launchRateRate.text!)!-1)"
        }
        settingsSent = false
    }
    
    @IBAction func launchRateStartingRateButton(sender: UIButton) {
        if Int(launchRateStartingRate.text!)! < 10 && sender.currentTitle == "+" {
            launchRateStartingRate.text = "\(Int(launchRateStartingRate.text!)!+1)"
        }else if Int(launchRateStartingRate.text!)! > 0 && sender.currentTitle == "-" {
            launchRateStartingRate.text = "\(Int(launchRateStartingRate.text!)!-1)"
        }
        settingsSent = false
    }
    
    @IBAction func firstBallDelayButton(sender: UIButton) {
        if Int(firstBallDelay.text!)! < 10 && sender.currentTitle == "+" {
            firstBallDelay.text = "\(Int(firstBallDelay.text!)!+1)"
        }else if Int(firstBallDelay.text!)! > 0 && sender.currentTitle == "-" {
            firstBallDelay.text = "\(Int(firstBallDelay.text!)!-1)"
        }
        settingsSent = false
    }
    @IBAction func sendSetting(sender: UIButton) {
        if !settingsSent {
            var sentSettings = defaults.objectForKey("sentSettings") as! Array<Dictionary<String, Int>>
            var currentSettings = [String: Int]()
            currentSettings["ballVelocityIncreasing"] = Int(ballVelocityIncreasing.state.rawValue)
            currentSettings["ballVelocityRate"] = Int(ballVelocityRate.text!)!
            currentSettings["launchRateIncreasing"] = Int(launchRateIncreasing.state.rawValue)
            currentSettings["launchRateRate"] = Int(launchRateRate.text!)!
            currentSettings["launchRateStartingRate"] = Int(launchRateStartingRate.text!)!
            currentSettings["firstBallDelay"] = Int(firstBallDelay.text!)!
            currentSettings["Sent"] = 0
            sentSettings.append(currentSettings)
            defaults.setObject(sentSettings, forKey: "sentSettings")
            
            for mySettings in defaults.objectForKey("sentSettings") as! Array<Dictionary<String, Int>> {
                if mySettings["Sent"] == 0 {
                }
            }
            
            let uniqueID = UIDevice.currentDevice().identifierForVendor!.UUIDString
            for (index, mySettings) in sentSettings.enumerate() {
                if mySettings["Sent"] != 1 {
                    let url: NSURL = NSURL(string: "http://84.20.247.236:8081/csg/custom_setting.php")!
                    let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
                    request.HTTPMethod = "POST"
                    
                    let bodyData = "ball_velocity_increasing1=\(mySettings["ballVelocityIncreasing"])&ball_velocity_rate1=\(mySettings["ballVelocityRate"])&launch_rate_icreasing1=\(mySettings["launchRateIncreasing"])&launch_rate_rate1=\(mySettings["launchRateRate"])&launch_rate_starting_rate1=\(mySettings["launchRateStartingRate"])&first_ball_delay1=\(mySettings["firstBallDelay"])&unique_id1=" + uniqueID
                    request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
                    
                    request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
                    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                        (data, response, error) in
                        
                        if error == nil {
                            print("Settings sent")
                            sentSettings[index]["Sent"] = 1
                            self.defaults.setObject(sentSettings, forKey: "sentSettings")
                        }
                        print(error)
                        print(response)
                    }
                    task.resume()
                }
            }
            
            settingsSent = true
        }
    }
    
    @IBAction func settingsChanged(sender: UISwitch) {
        settingsSent = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dvc = segue.destinationViewController as? MainGameViewController {
            
            var myLaunchRateIncreasing = true
            var myLaunchRateRate = 1.0
            var myLaunchRateStartingRate = 1.0
            var myFirstBallDelay = 1.0
            
            var myBallVelocityIncreasing = true
            var myBallVelocityRate = 1.0
            
            
            if ballVelocityIncreasing.on == true {
                myBallVelocityIncreasing = true
            }else{
                myBallVelocityIncreasing = false
            }
            
            if launchRateIncreasing.on == true {
                myLaunchRateIncreasing = true
            }else{
                myLaunchRateIncreasing = false
            }
            
            myBallVelocityRate = 1.0+((Double(ballVelocityRate.text!)!-5)/10)
            myLaunchRateRate = 1.0+(-((Double(launchRateRate.text!)!-5))/10)
            myLaunchRateStartingRate = 1.0+(-((Double(launchRateStartingRate.text!)!-5))/10)
            
            myFirstBallDelay = 1.0+((Double(firstBallDelay.text!)!-5)/10)
            
            dvc.launchRateIncreasing = myLaunchRateIncreasing
            dvc.launchRateRate = myLaunchRateRate
            dvc.launchRateStartingRate = myLaunchRateStartingRate
            dvc.firstBallDelay = myFirstBallDelay
            dvc.ballVelocityIncreasing = myBallVelocityIncreasing
            dvc.ballVelocityRate = myBallVelocityRate
            dvc.normalGame = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.setAnimationsEnabled(false)
        
        let buttonColor = UIColor(red: 0.75, green: 0.75, blue: 0.7, alpha: 1)
        menuView.backgroundColor = UIColor(red: 0.85, green: 0.8, blue: 0.65, alpha: 1)
        mainBackView.backgroundColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        backButton.backgroundColor = buttonColor
        playButton.backgroundColor = buttonColor
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
        tracker.set(kGAIScreenName, value: "CustomGameScreen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
}
