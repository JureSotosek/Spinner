//
//  StatsViewController.swift
//  colorSpinGame
//
//  Created by Jure Sotosek on 01/01/16.
//  Copyright © 2016 Jure Sotosek. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var mainBackView: MainBackView!
    @IBOutlet weak var rotateScrollView: RotateScrollView!
    @IBOutlet weak var rotateScrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var highScoreDisplay: UILabel!
    @IBOutlet weak var avarageScoreDisplay: UILabel!
    @IBOutlet weak var totalScoreDisplay: UILabel!
    @IBOutlet weak var gamesPlayedDisplay: UILabel!
    @IBOutlet weak var playingTimeDisplay: UILabel!
    @IBOutlet weak var distanceTraveledDisplay: UILabel!
    
    let defaults = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.setAnimationsEnabled(false)
        
        let buttonColor = UIColor(red: 0.75, green: 0.75, blue: 0.7, alpha: 1)
        menuView.backgroundColor = UIColor(red: 0.85, green: 0.8, blue: 0.65, alpha: 1)
        mainBackView.backgroundColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        backButton.backgroundColor = buttonColor

        let games = defaults.objectForKey("games") as! Array<Dictionary<String, Int>>
        
        gamesPlayedDisplay.text = "\(games.count)"
        
        var playingTimeString = ""
        var playingTime = 0
        var pointsTravaled = 0
        var highScore = 0
        var totalScore = 0
        for i in games {
            playingTime += i["GameDuration"]!
            pointsTravaled += i["DistanceTravaled"]!
            if i["Score"] > highScore {
                highScore = i["Score"]!
            }
            totalScore += i["Score"]!
        }
        if (playingTime / 86400) >= 1{
            let playingTimeDays = Int(playingTime / 86400)
            playingTimeString = playingTimeString + "\(playingTimeDays)d"
            playingTime = playingTime % 86400
        }
        if (playingTime / 3600) >= 1{
            let playTimeHours = Int(playingTime / 3600)
            playingTimeString = playingTimeString + "\(playTimeHours)h"
            playingTime = playingTime % 3600
        }
        if (playingTime / 60) >= 1{
            let playingTimeMinutes = Int(playingTime / 60)
            playingTimeString = playingTimeString + "\(playingTimeMinutes)m"
            playingTime = playingTime % 60
        }
        if playingTime >= 0 {
            playingTimeString = playingTimeString + "\(playingTime)s"
        }
        playingTimeDisplay.text = playingTimeString

        var distanceTravaled = (Double(pointsTravaled)/320) * 50
        var distanceTravaledString = ""
        if (distanceTravaled / 1000) > 1 {
            let distanceTravaledMeters = Int(distanceTravaled/1000)
            distanceTravaledString = distanceTravaledString + "\(distanceTravaledMeters)m"
            distanceTravaled = distanceTravaled % 1000
        }
        distanceTravaledString = distanceTravaledString + String(Int(distanceTravaled/10)) + "cm"
        distanceTraveledDisplay.text = distanceTravaledString
        
        highScoreDisplay.text = "\(highScore)"
        let avargeScore = Double(totalScore) / Double(games.count)
        avarageScoreDisplay.text = String(format: "%.2f", avargeScore)
        totalScoreDisplay.text = "\(totalScore)"
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
        tracker.set(kGAIScreenName, value: "StatsScreen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
}
