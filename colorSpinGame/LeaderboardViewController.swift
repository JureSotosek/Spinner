//
//  LeaderboardViewController.swift
//  colorSpinGame
//
//  Created by Jure Sotosek on 03/01/16.
//  Copyright © 2016 Jure Sotosek. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var mainBackView: MainBackView!
    @IBOutlet weak var rotateScrollView: RotateScrollView!
    @IBOutlet weak var rotateScrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var worldRankButton: UIButton!
    
    @IBOutlet weak var firstDisplayEasy: UILabel!
    @IBOutlet weak var secondDisplayEasy: UILabel!
    @IBOutlet weak var thirdDisplayEasy: UILabel!
    @IBOutlet weak var fourthDisplayEasy: UILabel!
    @IBOutlet weak var fifthDisplayEasy: UILabel!
    @IBOutlet weak var sixthDisplayEasy: UILabel!
    @IBOutlet weak var seventhDisplayEasy: UILabel!
    @IBOutlet weak var eighthDisplayEasy: UILabel!
    @IBOutlet weak var ninthDisplayEasy: UILabel!
    @IBOutlet weak var tenthDisplayEasy: UILabel!
    
    @IBOutlet weak var firstDisplayNormal: UILabel!
    @IBOutlet weak var secondDisplayNormal: UILabel!
    @IBOutlet weak var thirdDisplayNormal: UILabel!
    @IBOutlet weak var fourthDisplayNormal: UILabel!
    @IBOutlet weak var fifthDisplayNormal: UILabel!
    @IBOutlet weak var sixthDisplayNormal: UILabel!
    @IBOutlet weak var seventhDisplayNormal: UILabel!
    @IBOutlet weak var eighthDisplayNormal: UILabel!
    @IBOutlet weak var ninthDisplayNormal: UILabel!
    @IBOutlet weak var tenthDisplayNormal: UILabel!
    
    @IBOutlet weak var firstDisplayHard: UILabel!
    @IBOutlet weak var secondDisplayHard: UILabel!
    @IBOutlet weak var thirdDisplayHard: UILabel!
    @IBOutlet weak var fourthDisplayHard: UILabel!
    @IBOutlet weak var fifthDisplayHard: UILabel!
    @IBOutlet weak var sixthDisplayHard: UILabel!
    @IBOutlet weak var seventhDisplayHard: UILabel!
    @IBOutlet weak var eighthDisplayHard: UILabel!
    @IBOutlet weak var ninthDisplayHard: UILabel!
    @IBOutlet weak var tenthDisplayHard: UILabel!
    let defaults = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.setAnimationsEnabled(false)
        
        let buttonColor = UIColor(red: 0.75, green: 0.75, blue: 0.7, alpha: 1)
        menuView.backgroundColor = UIColor(red: 0.85, green: 0.8, blue: 0.65, alpha: 1)
        mainBackView.backgroundColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        backButton.backgroundColor = buttonColor
        
        let games = defaults.objectForKey("games") as! Array<Dictionary<String, Int>>
        
        var rankArrayEasy = [0,0,0,0,0,0,0,0,0,0]
        var rankArrayNormal = [0,0,0,0,0,0,0,0,0,0]
        var rankArrayHard = [0,0,0,0,0,0,0,0,0,0]
        
        for i in games {
            if i["Difficulty"] == 1 {
                for (index, score) in rankArrayNormal.enumerate() {
                    if i["Score"]! > score {
                        rankArrayNormal.insert (i["Score"]!, atIndex: index)
                        rankArrayNormal.removeAtIndex(10)
                        break
                    }
                }
            }else if i["Difficulty"] == 2 {
                for (index, score) in rankArrayHard.enumerate() {
                    if i["Score"]! > score {
                        rankArrayHard.insert (i["Score"]!, atIndex: index)
                        rankArrayHard.removeAtIndex(10)
                        break
                    }
                }
            }else{
                for (index, score) in rankArrayEasy.enumerate() {
                    if i["Score"]! > score {
                        rankArrayEasy.insert (i["Score"]!, atIndex: index)
                        rankArrayEasy.removeAtIndex(10)
                        break
                    }
                }
            }
        }
        
        firstDisplayEasy.text = rankArrayEasy[0].description
        secondDisplayEasy.text = rankArrayEasy[1].description
        thirdDisplayEasy.text = rankArrayEasy[2].description
        fourthDisplayEasy.text = rankArrayEasy[3].description
        fifthDisplayEasy.text = rankArrayEasy[4].description
        sixthDisplayEasy.text = rankArrayEasy[5].description
        seventhDisplayEasy.text = rankArrayEasy[6].description
        eighthDisplayEasy.text = rankArrayEasy[7].description
        ninthDisplayEasy.text = rankArrayEasy[8].description
        tenthDisplayEasy.text = rankArrayEasy[9].description
        
        firstDisplayNormal.text = rankArrayNormal[0].description
        secondDisplayNormal.text = rankArrayNormal[1].description
        thirdDisplayNormal.text = rankArrayNormal[2].description
        fourthDisplayNormal.text = rankArrayNormal[3].description
        fifthDisplayNormal.text = rankArrayNormal[4].description
        sixthDisplayNormal.text = rankArrayNormal[5].description
        seventhDisplayNormal.text = rankArrayNormal[6].description
        eighthDisplayNormal.text = rankArrayNormal[7].description
        ninthDisplayNormal.text = rankArrayNormal[8].description
        tenthDisplayNormal.text = rankArrayNormal[9].description
        
        firstDisplayHard.text = rankArrayHard[0].description
        secondDisplayHard.text = rankArrayHard[1].description
        thirdDisplayHard.text = rankArrayHard[2].description
        fourthDisplayHard.text = rankArrayHard[3].description
        fifthDisplayHard.text = rankArrayHard[4].description
        sixthDisplayHard.text = rankArrayHard[5].description
        seventhDisplayHard.text = rankArrayHard[6].description
        eighthDisplayHard.text = rankArrayHard[7].description
        ninthDisplayHard.text = rankArrayHard[8].description
        tenthDisplayHard.text = rankArrayHard[9].description
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
        tracker.set(kGAIScreenName, value: "LeaderboardScreen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
}
