//
//  BallLuncher.swift
//  colorSpinGame
//
//  Created by Jure Sotosek on 22/12/15.
//  Copyright © 2015 Jure Sotosek. All rights reserved.
//

import Foundation
import UIKit

protocol BallLuncherDelegate: class {
    func getCircleCenter() -> CGPoint
    func lunchMyBall(ball: UIView, angle: CGFloat)
}

class BallLuncher : NSObject {
    lazy var difficulty: Double = { [unowned self] in
        let defaults = NSUserDefaults()
        var diffuculty = 2.0
        if self.myNormalGame! {
            switch defaults.doubleForKey("difficulty") {
            case 0: diffuculty = 2.0
            case 1: diffuculty = 1.2
            case 2: diffuculty = 0.7
            default: break
            }
        }
        return diffuculty * self.launchRateStartingRate
    }()
    
    var lastBallAngle: Double?
    var lastBallColorIndex: Int?
    var myTimeInterval = NSTimeInterval()
    var behavior: BallDynamicBehavior?
    var stop = false
    
    var launchRateIncreasing = true
    var launchRateRate = 1.0
    var launchRateStartingRate = 1.0
    var firstBallDelay = 1.0
    
    var dataSource: BallLuncherDelegate?
    var myNormalGame: Bool?
    
    var mainTimer = NSTimer()
    
    init(myDataSource: MainGameViewController, myBehavior: BallDynamicBehavior, mylaunchRateIncreasing: Bool, myLaunchRateRate: Double, myLaunchRateStartingRate: Double, myFirstBallDelay: Double, myGameIsNormal: Bool){
        super.init()
        myNormalGame = myGameIsNormal
        launchRateIncreasing = mylaunchRateIncreasing
        launchRateRate = myLaunchRateRate
        launchRateStartingRate = myLaunchRateStartingRate
        firstBallDelay = myFirstBallDelay
        
        dataSource = myDataSource
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1*firstBallDelay * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue()) { [unowned self] in
            if !self.stop {
                self.lunchMyBall()
            }
        }
        if launchRateIncreasing {
            let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)){ [unowned self] in
            self.increseDifficulty()
            }
        }
    }
    
    func increseDifficulty(){
        print("Difficulty: \(difficulty)")
        if difficulty > 1.2{
            difficulty = difficulty * 0.976
        }else if difficulty > 0.8{
            difficulty = difficulty * 0.985
        }else if difficulty > 0.7{
            difficulty = difficulty * 0.994
        }else if difficulty > 0.6{
            difficulty = difficulty * 0.995
        }else{
            difficulty = difficulty * 0.998
        }
        if !stop{
            let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1*launchRateRate * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue()) {
                if !self.stop {
                self.increseDifficulty()
                }
            }
        }
    }

    func lunchMyBall(){
        let myBall = createBall()
        var angle = Int(arc4random_uniform(70))
        angle = angle+1-35
        if angle < 0 {
            angle = -angle
            angle = angle-70
        } else {
            angle = angle+70
        }
        if arc4random()%2 == 1 {
            angle = -angle
        }
        if lastBallAngle == nil {
            myBall.angle = Double(angle)
        }else{
            switch lastBallColorIndex! {
            case 1: switch myBall.colorIndex {
                case 1: myBall.angle = lastBallAngle! + Double(angle)
                case 2: myBall.angle = lastBallAngle! + Double(angle)-90
                case 3: myBall.angle = lastBallAngle! + Double(angle)+180
                case 4: myBall.angle = lastBallAngle! + Double(angle)+90
            default: break
                }
            case 2: switch myBall.colorIndex {
                case 1: myBall.angle = lastBallAngle! + Double(angle)+90
                case 2: myBall.angle = lastBallAngle! + Double(angle)
                case 3: myBall.angle = lastBallAngle! + Double(angle)-90
                case 4: myBall.angle = lastBallAngle! + Double(angle)+180
                default: break
                }
            case 3: switch myBall.colorIndex {
                case 1: myBall.angle = lastBallAngle! + Double(angle)+180
                case 2: myBall.angle = lastBallAngle! + Double(angle)+90
                case 3: myBall.angle = lastBallAngle! + Double(angle)
                case 4: myBall.angle = lastBallAngle! + Double(angle)-90
                default: break
                }
            case 4: switch myBall.colorIndex {
                case 1: myBall.angle = lastBallAngle! + Double(angle)-90
                case 2: myBall.angle = lastBallAngle! + Double(angle)+180
                case 3: myBall.angle = lastBallAngle! + Double(angle)+90
                case 4: myBall.angle = lastBallAngle! + Double(angle)
                default: break
                }
            default: break
            }
        }
        if myBall.angle! > 360 {
            myBall.angle = myBall.angle! - 360
        }else if myBall.angle! < 0 {
            myBall.angle = myBall.angle! + 360
        }
        let tempAngle = CGFloat((myBall.angle!/360)*2*M_PI)
        lastBallAngle = myBall.angle
        lastBallColorIndex = myBall.colorIndex
        dataSource?.lunchMyBall(myBall, angle: tempAngle)
        if !stop{
            let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(difficulty * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue()) {
                if !self.stop {
                    self.lunchMyBall()
                }
            }
        }
    }
    
    func createBall() -> UIItemView {
        var frame = CGRect(origin: CGPointZero, size: CGSize(width: 10, height: 10))
        if UIScreen.mainScreen().bounds.height > 600 {
            frame = CGRect(origin: CGPointZero, size: CGSize(width: 11, height: 11))
        }
        frame.origin = (CGPoint(x: (dataSource?.getCircleCenter().x)!-5, y: (dataSource?.getCircleCenter().y)!-5))
        
        let ballView = UIItemView(frame: frame, color: UIColor.random())
        
        return ballView
    }
}

private extension CGFloat {
    static func randomRad() -> CGFloat {
        return CGFloat((arc4random() % 62831))/10000
    }
}

private extension UIColor {
    static func random() -> UIColor {
        switch arc4random()%4 {
        case 0: return UIColor(red: 0, green: 210/255, blue: 0, alpha: 1)
        case 1: return UIColor.blueColor()
        case 2: return UIColor(red: 240/255, green: 240/255, blue: 0, alpha: 1)
        case 3: return UIColor.redColor()
        default: return UIColor.blackColor()
        }
    }
}