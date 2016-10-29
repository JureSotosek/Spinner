//
//  AppDelegate.swift
//  colorSpinGame
//
//  Created by Jure Sotosek on 17/12/15.
//  Copyright © 2015 Jure Sotosek. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let defaults = NSUserDefaults()
    var sessionsStartedAt = 0


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        if let _ = defaults.objectForKey("games") as? Array<Dictionary<String, Int>> {
        }else{
            defaults.setObject([] as AnyObject, forKey: "games")
        }
        if defaults.objectForKey("sentSettings") == nil {
            defaults.setObject([] as AnyObject, forKey: "sentSettings")
        }
        if defaults.objectForKey("difficulty") == nil {
            defaults.setInteger(1, forKey: "difficulty")
        }
        if defaults.objectForKey("Sensitivity") == nil {
            defaults.setInteger(1, forKey: "Sensitivity")
        }
        if defaults.objectForKey("sessions") == nil {
            defaults.setObject([], forKey: "sessions")
        }
        if defaults.objectForKey("volume") == nil {
            defaults.setBool(true, forKey: "volume")
        }
        if defaults.objectForKey("Normal Controlls") == nil {
            defaults.setBool(true, forKey: "Normal Controlls")
        }
        if defaults.objectForKey("highScore") == nil {
            defaults.setInteger(0, forKey: "highScore")
        }
        if let _ = defaults.objectForKey("sentSettings") as? Array<Dictionary<String, Int>> {
        }else{
            defaults.setObject([], forKey: "sentSettings")
        }
        
        defaults.setObject(0, forKey: "sessionGames")
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmm"
        let sessionEndedAt = Int(formatter.stringFromDate(date))
        
        var currentSession = [String: Int]()
        var sessions = defaults.objectForKey("sessions") as! Array<Dictionary<String, Int>>
        currentSession["StartedAt"] = sessionsStartedAt
        currentSession["EndedAt"] = sessionEndedAt
        currentSession["GamesPlayed"] = defaults.integerForKey("sessionGames")
        currentSession["Sent"] = 0
        
        sessions.append(currentSession)
        
        defaults.setObject(sessions, forKey: "sessions")
    }

    func applicationWillEnterForeground(application: UIApplication) {
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmm"
        sessionsStartedAt = Int(formatter.stringFromDate(date))!
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
}

