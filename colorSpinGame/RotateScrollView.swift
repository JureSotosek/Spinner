//
//  RotateScrollView.swift
//  colorSpinGame
//
//  Created by Jure Sotosek on 20/12/15.
//  Copyright © 2015 Jure Sotosek. All rights reserved.
//

import UIKit

@IBDesignable
class RotateScrollView: UIView {
    
    let iMax = 70
    
    var offSet: CGFloat = 0 {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    var bigScreenOffSet: CGFloat {
        if UIScreen.mainScreen().bounds.height > 600 {
            return 20
        }else{
            return 0
        }
    }
    
    var halfCirclePath: UIBezierPath {
        let halfCirclePath = UIBezierPath()
        halfCirclePath.addArcWithCenter(CGPoint(x: bounds.midX, y: 0-bigScreenOffSet), radius: bounds.maxY-35+bigScreenOffSet, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: true)
        halfCirclePath.lineWidth = 70
        return halfCirclePath
    }
    
    var texturePath: UIBezierPath {
        let lazyTexturePath = UIBezierPath()
        let defaults = NSUserDefaults()
        if defaults.boolForKey("Normal Controlls") == true {
        for i in 1...iMax{
            
            var pointX1 = CGFloat(((2*M_PI)*(Double(i)/Double(iMax))))
            pointX1 = cos(pointX1+CGFloat(-offSet))
            pointX1 = pointX1 * (bounds.maxY-13+bigScreenOffSet)
            pointX1 = bounds.midX + CGFloat(pointX1)
            var pointY1 = CGFloat(((2*M_PI)*(Double(i)/Double(iMax))))
            pointY1 = sin(pointY1+CGFloat(-offSet))
            pointY1 = pointY1 * (bounds.maxY-13+bigScreenOffSet)
            
            var pointX2 = CGFloat(((2*M_PI)*(Double(i)/Double(iMax))))
            pointX2 = cos(pointX2+CGFloat(-offSet))
            pointX2 = pointX2 * (bounds.maxY-70+13+bigScreenOffSet)
            pointX2 = bounds.midX + CGFloat(pointX2)
            var pointY2 = CGFloat(((2*M_PI)*(Double(i)/Double(iMax))))
            pointY2 = sin(pointY2+CGFloat(-offSet))
            pointY2 = pointY2 * (bounds.maxY-70+13+bigScreenOffSet)
            
            if UIScreen.mainScreen().bounds.height > 600 {
                pointY1 = pointY1 - 20
                pointY2 = pointY2 - 20
            }
            
            lazyTexturePath.moveToPoint(CGPoint(x: pointX1, y: pointY1))
            lazyTexturePath.addLineToPoint(CGPoint(x: pointX2, y: pointY2))
        }
        }else{
            for i in -1...Int(self.frame.size.width / 20)+1{
                lazyTexturePath.moveToPoint(CGPoint(x: CGFloat(i*20)+offSet, y: self.bounds.size.height-13))
                lazyTexturePath.addLineToPoint(CGPoint(x: CGFloat(i*20)+offSet, y: 13))
            }
        }
        lazyTexturePath.lineWidth = 6
        lazyTexturePath.lineCapStyle = .Round
        return lazyTexturePath
    }
    
    override func drawRect(rect: CGRect) {
        let defaults = NSUserDefaults()
        if defaults.boolForKey("Normal Controlls") == true {
            UIColor.darkGrayColor().set()
            halfCirclePath.stroke()
        }
        UIColor.blackColor().set()
        texturePath.stroke()
    }

}