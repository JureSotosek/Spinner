//
//  BallDynamicBehavior.swift
//  colorSpinGame
//
//  Created by Jure Sotosek on 17/12/15.
//  Copyright © 2015 Jure Sotosek. All rights reserved.
//

import UIKit

protocol BallDynamicBehaviorDelegate: class {
    func getRotation() -> CGFloat
    func scoreChanged(increse: Bool)
}

class BallDynamicBehavior: UIDynamicBehavior, UICollisionBehaviorDelegate {

    var ballVelocityIncreasing = true
    var ballVelocityRate = 1.0
    
    var dataSource: BallDynamicBehaviorDelegate?
    
    var collisionBehavior = UICollisionBehavior()
    
    var lunchBehaviorAngle: CGFloat?
    
    var lunchBehavior : UIPushBehavior {
        var lunchBehavior = UIPushBehavior()
        if ballVelocityIncreasing == true {
        lunchBehavior = UIPushBehavior(items: [], mode: .Continuous)
        }else{
        lunchBehavior = UIPushBehavior(items: [], mode: .Instantaneous)
        }
        return lunchBehavior
    }
    
    convenience init(myBallVelocityIncreasing: Bool, myBallVelocityRate: Double) {
        self.init()
        ballVelocityIncreasing = myBallVelocityIncreasing
        ballVelocityRate = myBallVelocityRate
    }
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        collisionBehavior.collisionDelegate = self
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        if let myItem = item as? UIItemView {
            if (isPointInAngle(myItem.angle!, colorIndex: myItem.colorIndex) == true) {
                dataSource?.scoreChanged(true)
            }else{
                for i in collisionBehavior.items {
                    if (i as? UIItemView) != myItem {
                        if let view = i as? UIItemView {
                            collisionBehavior.removeItem(view)
                            removeChildBehavior(view.pushBehavior!)
                            view.pushBehavior?.removeItem(view)
                            view.removeFromSuperview()
                        }
                    }
                }
                dataSource?.scoreChanged(false)
            }
            
            collisionBehavior.removeItem(myItem)
            removeChildBehavior(myItem.pushBehavior!)
            myItem.pushBehavior?.removeItem(myItem)
            myItem.removeFromSuperview()
        }
    }
    
    func addBarrier(path: UIBezierPath, named name: String) {
        collisionBehavior.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    func deleteBalls() {
        for i in collisionBehavior.items {
            if let view = i as? UIItemView {
                collisionBehavior.removeItem(view)
                removeChildBehavior(view.pushBehavior!)
                view.pushBehavior?.removeItem(view)
                view.removeFromSuperview()
            }
        }
    }
    
    func lunchBall(ball: UIView, angle: CGFloat) {
        let myLunchBehavior: UIPushBehavior? = lunchBehavior
        let myBall = ball as! UIItemView
        myBall.angle = 360-((Double(angle)/(2*M_PI))*360)
        myLunchBehavior!.setAngle(angle, magnitude: CGFloat(0.005*(ballVelocityRate)))
        myLunchBehavior!.addItem(ball)
        myBall.pushBehavior = myLunchBehavior
        dynamicAnimator?.referenceView?.addSubview(ball)
        addChildBehavior(myBall.pushBehavior!)
        collisionBehavior.addItem(ball)
    }
    
    func isPointInAngle(angle: Double, colorIndex: Int) -> (Bool)? {
        var rotation = dataSource?.getRotation()
        rotation = -rotation!
        switch colorIndex {
        case 1:
            var angleOne: CGFloat = 0
            angleOne = angleOne + (rotation!/CGFloat(M_PI*2))*360
            if angleOne < 0 {
                angleOne = angleOne + 360
            }else if angleOne > 360{
                angleOne = angleOne - 360
            }
            
            var angleTwo = angleOne+90
            if angleTwo > 360 {
                angleTwo = angleTwo - 360
            }
            let angleThree = CGFloat(angle)
            print("angleOne: \(angleOne), angleTwo:\(angleTwo), angleThree:\(angleThree), index:\(colorIndex), rotation:\(rotation!)")
            
            if angleOne < angleThree && angleTwo > angleThree {
                return true
            }else if angleTwo - angleOne < 0 {
                if angleThree < angleTwo || angleThree > angleOne{
                    return true
                }
            }else{
                return false
            }
            
        case 2:
            var angleOne: CGFloat = 90
            angleOne = angleOne + (rotation!/CGFloat(M_PI*2))*360
            if angleOne < 0 {
                angleOne = angleOne + 360
            }else if angleOne > 360{
                angleOne = angleOne - 360
            }
            
            var angleTwo = angleOne+90
            if angleTwo > 360 {
                angleTwo = angleTwo - 360
            }
            let angleThree = CGFloat(angle)
            print("angleOne: \(angleOne), angleTwo:\(angleTwo), angleThree:\(angleThree), index:\(colorIndex), rotation:\(rotation!)")
            
            if angleOne < angleThree && angleTwo > angleThree {
                return true
            }else if angleTwo - angleOne < 0 {
                if angleThree < angleTwo || angleThree > angleOne{
                    return true
                }
            }else{
                return false
            }
        case 3:
            var angleOne: CGFloat = 180
            angleOne = angleOne + (rotation!/CGFloat(M_PI*2))*360
            if angleOne < 0 {
                angleOne = angleOne + 360
            }else if angleOne > 360{
                angleOne = angleOne - 360
            }
            
            var angleTwo = angleOne+90
            if angleTwo > 360 {
                angleTwo = angleTwo - 360
            }
            let angleThree = CGFloat(angle)
            print("angleOne: \(angleOne), angleTwo:\(angleTwo), angleThree:\(angleThree), index:\(colorIndex), rotation:\(rotation!)")
            
            if angleOne < angleThree && angleTwo > angleThree {
                return true
            }else if angleTwo - angleOne < 0 {
                if angleThree < angleTwo || angleThree > angleOne{
                    return true
                }
            }else{
                return false
            }
        case 4:
            var angleOne: CGFloat = 270
            angleOne = angleOne + (rotation!/CGFloat(M_PI*2))*360
            if angleOne < 0 {
                angleOne = angleOne + 360
            }else if angleOne > 360{
                angleOne = angleOne - 360
            }
            var angleTwo = angleOne+90
            if angleTwo > 360 {
                angleTwo = angleTwo - 360
            }
            let angleThree = CGFloat(angle)
            print("angleOne: \(angleOne), angleTwo:\(angleTwo), angleThree:\(angleThree), index:\(colorIndex), rotation:\(rotation!)")
            
            if angleOne < angleThree && angleTwo > angleThree {
                return true
            }else if angleTwo - angleOne < 0 {
                if angleThree < angleTwo || angleThree > angleOne{
                    return true
                }
            }else{
                return false
            }
        default: break
        }
        return nil
    }

}
