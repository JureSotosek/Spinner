//
//  MainGameViewController.swift
//  colorSpinGame
//
//  Created by Jure Sotosek on 17/12/15.
//  Copyright © 2015 Jure Sotosek. All rights reserved.
//

import UIKit
import Darwin
import AudioToolbox
import AVFoundation
import GoogleMobileAds

struct game {
    
    var NormalGame = Bool()
    var GameDuration = Int()
    var Score = Int()
    var TimePlayedAt = String()
    var DistanceTravaled = Int()
    var GameDifficulty = Int()
    
    init(MyNormalGame: Bool){
        NormalGame = MyNormalGame
    }
}

class MainGameViewController: UIViewController, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate, BallDynamicBehaviorDelegate, BallLuncherDelegate {
    
    @IBOutlet weak var mainBackView: MainBackView!
    
    @IBOutlet weak var rotateScrollView: RotateScrollView!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var scoreDisplay: UILabel!
    
    @IBOutlet weak var highScoreDisplay: UILabel!
    
    @IBOutlet weak var gameOverView: UIView!
    
    @IBOutlet weak var gameOverLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    
    @IBOutlet weak var pauseView: UIView!
    
    @IBOutlet weak var pauseRestartButton: UIButton!
    
    @IBOutlet weak var pauseResumeButton: UIButton!
    
    @IBOutlet weak var restartButtonOutlet: UIButton!
    
    @IBOutlet weak var mainMenuButtonOutlet: UIButton!
    
    @IBOutlet weak var blureView: UIView!
    
    @IBOutlet weak var scoreDisplayTopOffSet: NSLayoutConstraint!
    @IBOutlet weak var rotateScrollViewHeight: NSLayoutConstraint!
    
    @IBAction func restartButton(sender: UIButton) {
        firstTimeViewDidLayoutSubviews = true
        scoreDisplay.text = "0"
        pause = false
        firstPause = true
        for view in mainBackView.subviews {
            if let ball = view as? UIItemView {
                ball.removeFromSuperview()
            }
        }
        viewDidLoad()
    }

    @IBAction func mainMenuButton(sender: UIButton) {
        if normalGame{
            performSegueWithIdentifier("unwindToMVC", sender: nil)
        }else{
            performSegueWithIdentifier("unwindToCGVC", sender: nil)
        }
//        if interstitial!.isReady {
//            interstitial?.presentFromRootViewController(self)
//        }
    }
    
    var firstPause = true
    var pause = false
    @IBAction func pauseButton(sender: AnyObject?) {
        if firstPause && !pause{
            myAnimator.removeBehavior(myBallDynamicBehavior!)
            myBallLuncher?.stop = true
            pause = true

            mainBackView.bringSubviewToFront(blureView)
            blureView.hidden = false
            pauseView.hidden = false
        }
    }
    
    @IBAction func resumeButton(sender: UIButton) {
        if pause {
            myBallLuncher?.stop = true
            myAnimator.addBehavior(myBallDynamicBehavior!)
            let innerCirclePath = UIBezierPath(arcCenter: CGPoint(x: mainBackView.bounds.midX, y: mainBackView.circleCenter.y), radius: mainBackView.circleRadius-6, startAngle: CGFloat(0), endAngle: CGFloat(M_PI*2), clockwise: true)
            myBallDynamicBehavior!.addBarrier(innerCirclePath, named: "innerCirclePath")
            
            for view in mainBackView.subviews {
                if let ball = view as? UIItemView {
                    ball.hidden = false
                }
            }
            
            let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64( 1*firstBallDelay * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue()) { [unowned self] in
                if !self.pause {
                    self.myBallLuncher?.stop = false
                    self.firstPause = false
                    self.myBallLuncher?.increseDifficulty()
                    self.myBallLuncher?.lunchMyBall()
                }
            }
            pause = false
            
            blureView.hidden = true
            pauseView.hidden = true
        }
    }
    
    @IBAction func panGestureRotation(sender: UIPanGestureRecognizer) {
        if !pause {
            let distanceTravaled = abs(Int(sender.translationInView(mainBackView).x))
            currentGame?.DistanceTravaled += distanceTravaled
            
            if defaults.boolForKey("Normal Controlls") == true {
                if sender.state == .Changed {
                    let pointX = sender.locationInView(mainBackView).x-mainBackView.circleCenter.x
                    let pointY = sender.locationInView(mainBackView).y-mainBackView.circleCenter.y
                    var currentAngle = atan(pointX/pointY)
                    if currentAngle < 0 && sender.locationInView(mainBackView).x < mainBackView.circleCenter.x{
                        currentAngle = CGFloat(M_PI/2)+(CGFloat(M_PI/2)+currentAngle)
                    }else if currentAngle > 0 && sender.locationInView(mainBackView).x > mainBackView.circleCenter.x{
                        currentAngle = currentAngle + CGFloat(M_PI)
                    }else if currentAngle < 0 && sender.locationInView(mainBackView).x > mainBackView.circleCenter.x{
                        currentAngle = CGFloat(2*M_PI*(3/4))+(CGFloat(M_PI/2)+currentAngle)
                    }
                    if abs(currentAngle-lastAngle) < 1 {
                        mainBackView.rotation -= (currentAngle-lastAngle)*3*CGFloat(defaults.doubleForKey("Sensitivity"))
                        if mainBackView.rotation > CGFloat(2*M_PI) || mainBackView.rotation < -CGFloat(2*M_PI){
                            mainBackView.rotation = 0
                        }
                        rotateScrollView.offSet = rotateScrollView.offSet + (currentAngle-lastAngle)
                    }
                    lastAngle = currentAngle
                    sender.setTranslation(CGPointZero, inView: mainBackView)
                }else if sender.state == .Began {
                    let pointX = sender.locationInView(mainBackView).x-mainBackView.circleCenter.x
                    let pointY = sender.locationInView(mainBackView).y-mainBackView.circleCenter.y
                    var currentAngle = atan(pointX/pointY)
                    if currentAngle < 0 && sender.locationInView(mainBackView).x < mainBackView.circleCenter.x{
                        currentAngle = CGFloat(M_PI/2)+(CGFloat(M_PI/2)+currentAngle)
                    }else if currentAngle > 0 && sender.locationInView(mainBackView).x > mainBackView.circleCenter.x{
                        currentAngle = currentAngle + CGFloat(M_PI)
                    }else if currentAngle < 0 && sender.locationInView(mainBackView).x > mainBackView.circleCenter.x{
                        currentAngle = CGFloat(2*M_PI*(3/4))+(CGFloat(M_PI/2)+currentAngle)
                    }
                    lastAngle = currentAngle
                }else if sender.state == .Ended {
                    lastAngle = 0
                }
            }else if sender.state == .Changed{
                rotateScrollView.offSet += sender.translationInView(mainBackView).x
                if rotateScrollView.offSet > 20 || rotateScrollView.offSet < -20 {
                    rotateScrollView.offSet = 0
                }
                mainBackView.rotation -= (CGFloat(sender.translationInView(mainBackView).x)/100) * CGFloat(defaults.doubleForKey("Sensitivity"))
                if mainBackView.rotation > CGFloat(2*M_PI) || mainBackView.rotation < -CGFloat(2*M_PI){
                    mainBackView.rotation = 0
                }
                sender.setTranslation(CGPointZero, inView: mainBackView)
            }
        }
    }
    
    let defaults = NSUserDefaults()
    
    var gamesPlayed = 0
    
    var launchRateIncreasing = true
    var launchRateRate = 1.0
    var launchRateStartingRate = 1.0
    var firstBallDelay = 1.0
    
    var ballVelocityIncreasing = true
    var ballVelocityRate = 1.0
    
    var normalGame = true
    var highScore = 0
    
    var viewBackgroundColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
    
    var startTime = NSDate.timeIntervalSinceReferenceDate()
    
    lazy var myAnimator: UIDynamicAnimator = { [unowned self] in
        let lazyMyAnimator = UIDynamicAnimator(referenceView: self.mainBackView)
        lazyMyAnimator.delegate = self
        return lazyMyAnimator
    }()
    
    var myBallDynamicBehavior: BallDynamicBehavior?
    
    var myBallLuncher: BallLuncher?
    
    var currentGame: game?
    
    var lastAngle = CGFloat()
    
    func getRotation() -> CGFloat {
        return mainBackView.rotation
    }
    
    //var interstitial: GADInterstitial?
    
    let trueAudioURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("true", ofType: "wav")!)
    var trueAudioPlayer = AVAudioPlayer()
    
    let falseAudioURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("false", ofType: "wav")!)
    var falseAudioPlayer = AVAudioPlayer()
    
    var currentGameToSave: game?
    func scoreChanged(increse: Bool) {
        if increse == true {
            scoreDisplay.text = "\(Int(scoreDisplay.text!)! + 1)"
            if defaults.boolForKey("volume") {
                let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
                dispatch_async(dispatch_get_global_queue(qos, 0)){ [unowned self] in
                    self.trueAudioPlayer.play()
                }
            }
            if Int(scoreDisplay.text!)! > highScore {
                highScoreDisplay.text = "High score: " + scoreDisplay.text!
                highScore = Int(scoreDisplay.text!)!
            }
            
        }else{
            if defaults.boolForKey("volume") {
                let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
                dispatch_async(dispatch_get_global_queue(qos, 0)){ [unowned self] in
                    self.falseAudioPlayer.play()
                }
            }
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            let anim = CAKeyframeAnimation( keyPath:"transform" )
            anim.values = [
                NSValue( CATransform3D:CATransform3DMakeTranslation(-5, 0, 0 ) ),
                NSValue( CATransform3D:CATransform3DMakeTranslation( 5, 0, 0 ) )
            ]
            anim.autoreverses = true
            anim.repeatCount = 2
            anim.duration = 7/100
            
            mainBackView.layer.addAnimation( anim, forKey:nil )
            
            if normalGame && Int(scoreDisplay.text!)! > defaults.integerForKey("highScore") {
                defaults.setInteger(Int(scoreDisplay.text!)!, forKey: "highScore")
            }
            
            gamesPlayed += 1
            
            currentGameToSave = currentGame
            let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)){ [unowned self] in
                self.currentGameToSave?.Score = Int(self.scoreDisplay.text!)!
                let date = NSDate()
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyyMMddHHmm"
                self.currentGameToSave?.TimePlayedAt = formatter.stringFromDate(date)
                
                var dictionaryToStore = [String: Int]()
                var currentArrayOfDic = self.defaults.objectForKey("games") as! Array<Dictionary<String, Int>>
                dictionaryToStore["NormalGame"] = self.currentGameToSave?.NormalGame.hashValue
                dictionaryToStore["Score"] = self.currentGameToSave?.Score
                dictionaryToStore["GameDuration"] = self.currentGameToSave?.GameDuration
                if Int((self.currentGameToSave?.TimePlayedAt)!) == nil {
                    dictionaryToStore["TimePlayedAt"] = 0
                }else{
                    dictionaryToStore["TimePlayedAt"] = Int((self.currentGameToSave?.TimePlayedAt)!)!
                }
                dictionaryToStore["DistanceTravaled"] = self.currentGameToSave?.DistanceTravaled
                dictionaryToStore["GameIndex"] = currentArrayOfDic.count
                dictionaryToStore["Difficulty"] = self.defaults.integerForKey("difficulty")
                dictionaryToStore["Sent"] = 0
                
                currentArrayOfDic.append(dictionaryToStore)
                self.defaults.setObject(currentArrayOfDic as AnyObject, forKey: "games")
                self.defaults.setObject(self.defaults.integerForKey("sessionGames") + 1, forKey: "sessionGames")
            }
            
            myBallLuncher!.stop = true
            pause = true
            
            let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue()) { [unowned self] in
                
                self.blureView.hidden = false
                self.gameOverView.hidden = false
                self.scoreLabel.text = "Your Score Is: " + self.scoreDisplay.text!
                switch self.defaults.integerForKey("difficulty") {
                case 0: self.difficultyLabel.text = "Difficulty: Easy!"
                case 1: self.difficultyLabel.text = "Difficulty: Normal!"
                case 2: self.difficultyLabel.text = "Difficulty: Hard!"
                default: break
                }
                self.myBallDynamicBehavior?.deleteBalls()
            }
        }
    }
    
    func getCircleCenter() -> CGPoint {
        return mainBackView.circleCenter
    }
    
    func lunchMyBall(ball: UIView, angle: CGFloat){
        myBallDynamicBehavior!.lunchBall(ball, angle: angle)
    }
    
    func time(timer: NSTimer){
        if !pause {
            currentGame?.GameDuration += 1
        }else{
            timer.invalidate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.setAnimationsEnabled(false)
        
        pause = false
        do {
            falseAudioPlayer = try AVAudioPlayer(contentsOfURL: self.falseAudioURL)
            trueAudioPlayer = try AVAudioPlayer(contentsOfURL: self.trueAudioURL)
        }catch{}
        
        let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)){ [unowned self] in
            self.trueAudioPlayer.play()
        }
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(MainGameViewController.time(_:)), userInfo: nil, repeats: true)
        
        if !normalGame{
            mainMenuButtonOutlet.setTitle("Custom Menu", forState: UIControlState.Normal)
        }
        
        mainMenuButtonOutlet.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.7, alpha: 1)
        gameOverView.backgroundColor = UIColor(red: 0.85, green: 0.8, blue: 0.65, alpha: 1)
        
        blureView.hidden = true
        gameOverView.hidden = true
        
        myBallDynamicBehavior = BallDynamicBehavior(myBallVelocityIncreasing: ballVelocityIncreasing, myBallVelocityRate: ballVelocityRate)
        mainBackView.backgroundColor = viewBackgroundColor
        myAnimator.addBehavior(myBallDynamicBehavior!)
        myBallDynamicBehavior!.dataSource = self
        
        myBallLuncher = BallLuncher(myDataSource: self, myBehavior: myBallDynamicBehavior!, mylaunchRateIncreasing: launchRateIncreasing, myLaunchRateRate: launchRateRate, myLaunchRateStartingRate: launchRateStartingRate, myFirstBallDelay: firstBallDelay, myGameIsNormal: normalGame)
        
        currentGame = game(MyNormalGame: normalGame)
        
        if normalGame {
            highScore = defaults.objectForKey("highScore") as! Int
            highScoreDisplay.text = "High score: " + "\(highScore)"
        }
        
        bannerView.adUnitID = "ca-app-pub-9315315035951188/9674367958"
        bannerView.rootViewController = self
        //bannerView.loadRequest(GADRequest())
        
//        interstitial = GADInterstitial(adUnitID: "adUnitID: ca-app-pub-9315315035951188/8688659150")
//        interstitial!.loadRequest(GADRequest())
    }
    
    var firstTimeViewDidLayoutSubviews = true
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if firstTimeViewDidLayoutSubviews {
            var height = CGFloat()
            if mainBackView.bounds.height < 500 {
                height = 318
            }else if mainBackView.bounds.height < 600 {
                height = 363
            }else if mainBackView.bounds.height < 700{
                height = 422
            }else{
                height = 442
            }
            
            scoreDisplayTopOffSet.constant = height
            mainBackView.layoutIfNeeded()
            
            if defaults.boolForKey("Normal Controlls") == true {
                rotateScrollViewHeight.constant = 302
                rotateScrollView.backgroundColor = UIColor(white: 1, alpha: 0)
            }else{
                rotateScrollViewHeight.constant = 70
                rotateScrollView.backgroundColor = UIColor.darkGrayColor()
            }
            let innerCirclePath = UIBezierPath(arcCenter: CGPoint(x: mainBackView.bounds.midX, y: mainBackView.circleCenter.y), radius: mainBackView.circleRadius-7, startAngle: CGFloat(0), endAngle: CGFloat(M_PI*2), clockwise: true)
            myBallDynamicBehavior!.addBarrier(innerCirclePath, named: "innerCirclePath")
            firstTimeViewDidLayoutSubviews = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "GameScreen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
}
