//
//  backView.swift
//  colorSpinGame
//
//  Created by Jure Sotosek on 17/12/15.
//  Copyright © 2015 Jure Sotosek. All rights reserved.
//

import UIKit

@IBDesignable
class MenuBackView: UIView {
    
    lazy var circleCenter: CGPoint = { [unowned self] in
        if self.bounds.height < 500 {
            return CGPoint(x: self.bounds.midX, y: self.bounds.height-338)
        }else if self.bounds.height < 600 {
            return CGPoint(x: self.bounds.midX, y: self.bounds.height-383)
        }else if self.bounds.height < 700{
            return CGPoint(x: self.bounds.midX, y: self.bounds.height-442)
        }else{
            return CGPoint(x: self.bounds.midX, y: self.bounds.height-482)
        }
    }()
    
    var circleRadius: CGFloat {
        if bounds.height < 600 {
            return 150
        }else if bounds.height < 700{
            return 180
        }else{
            return 200
        }
    }
    
    var rotation: CGFloat = 0 {
        didSet{self.setNeedsDisplay()}
    }
    
    var outerCirclePath: UIBezierPath {
        return UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: 0, endAngle: CGFloat(2.0*M_PI), clockwise: true)
    }
    var outerCircleColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
    
    var innerCirclePath1 : UIBezierPath {
        let innerCirclePath1Temp = UIBezierPath(arcCenter: circleCenter, radius: circleRadius-9, startAngle: CGFloat(0)+rotation, endAngle: CGFloat(M_PI/2.0)+rotation, clockwise: true)
        innerCirclePath1Temp.lineWidth = CGFloat(5)
        if bounds.height > 600 {
            innerCirclePath1Temp.lineWidth = CGFloat(6)
        }
        return innerCirclePath1Temp
    }
    var innerCirclePath2 : UIBezierPath {
        let innerCirclePath2Temp = UIBezierPath(arcCenter: circleCenter, radius: circleRadius-9, startAngle: CGFloat(M_PI/2.0)+rotation, endAngle: CGFloat(M_PI)+rotation, clockwise: true)
        innerCirclePath2Temp.lineWidth = CGFloat(5)
        if bounds.height > 600 {
            innerCirclePath2Temp.lineWidth = CGFloat(6)
        }
        return innerCirclePath2Temp
    }
    var innerCirclePath3 : UIBezierPath {
        let innerCirclePath3Temp = UIBezierPath(arcCenter: circleCenter, radius: circleRadius-9, startAngle:CGFloat(M_PI)+rotation, endAngle: CGFloat((3.0*M_PI)/2)+rotation, clockwise: true)
        innerCirclePath3Temp.lineWidth = CGFloat(5)
        if bounds.height > 600 {
            innerCirclePath3Temp.lineWidth = CGFloat(6)
        }
        return innerCirclePath3Temp
    }
    var innerCirclePath4 : UIBezierPath {
        let innerCirclePath4Temp = UIBezierPath(arcCenter: circleCenter, radius: circleRadius-9, startAngle: CGFloat((3.0*M_PI)/2)+rotation, endAngle: CGFloat(2.0*M_PI)+rotation, clockwise: true)
        innerCirclePath4Temp.lineWidth = CGFloat(5)
        if bounds.height > 600 {
            innerCirclePath4Temp.lineWidth = CGFloat(6)
        }
        return innerCirclePath4Temp
    }
    
    var mainCircleColor = UIColor(red: 205/255, green: 205/255, blue: 170/255, alpha: 1)
    
    var mainCirclePath: UIBezierPath {
        return UIBezierPath(arcCenter: circleCenter, radius: circleRadius-10, startAngle: 0, endAngle: CGFloat(2.0*M_PI), clockwise: true)
    }
    
    var anglePathBig: UIBezierPath {
        let anglePathBigTemp = UIBezierPath()
        for angle in 1...360 {
            if (angle % 45) == 0 {
                var pointX1 = CGFloat(Double(angle)+(Double(rotation*360)/(2*M_PI)))
                pointX1 = CGFloat(cos((pointX1/360)*2*CGFloat(M_PI)))
                var pointY1 = CGFloat(Double(angle)+(Double(rotation*360)/(2*M_PI)))
                pointY1 = CGFloat(sin((pointY1/360)*2*CGFloat(M_PI)))
                var pointX2 = CGFloat()
                var pointY2 = CGFloat()
                pointX2 = pointX1*(circleRadius+17)+circleCenter.x
                pointY2 = pointY1*(circleRadius+17)+circleCenter.y
                pointX1 = pointX1*(circleRadius+3)+circleCenter.x
                pointY1 = pointY1*(circleRadius+3)+circleCenter.y
                anglePathBigTemp.moveToPoint(CGPoint(x:pointX1,y:pointY1))
                anglePathBigTemp.addLineToPoint(CGPoint(x: pointX2, y: pointY2))
            }
        }
        anglePathBigTemp.lineWidth = 2.5
        anglePathBigTemp.lineCapStyle = .Round
        return anglePathBigTemp
    }
    
    var anglePathSmall: UIBezierPath {
        let anglePathSmallTemp = UIBezierPath()
        for angle in 1...360 {
            if (angle % 3) == 0 {
                var pointX1 = CGFloat(Double(angle)+(Double(rotation*360)/(2*M_PI)))
                pointX1 = CGFloat(cos((pointX1/360)*2*CGFloat(M_PI)))
                var pointY1 = CGFloat(Double(angle)+(Double(rotation*360)/(2*M_PI)))
                pointY1 = CGFloat(sin((pointY1/360)*2*CGFloat(M_PI)))
                var pointX2 = CGFloat()
                var pointY2 = CGFloat()
                pointX2 = pointX1*(circleRadius+10)+circleCenter.x
                pointY2 = pointY1*(circleRadius+10)+circleCenter.y
                pointX1 = pointX1*(circleRadius+3)+circleCenter.x
                pointY1 = pointY1*(circleRadius+3)+circleCenter.y
                anglePathSmallTemp.moveToPoint(CGPoint(x:pointX1,y:pointY1))
                anglePathSmallTemp.addLineToPoint(CGPoint(x: pointX2, y: pointY2))
            }
        }
        anglePathSmallTemp.lineWidth = 1.2
        anglePathSmallTemp.lineCapStyle = .Round
        return anglePathSmallTemp
    }
    
    override func drawRect(rect: CGRect) {
        
        outerCircleColor.set()
        outerCirclePath.fill()
        anglePathSmall.stroke()
        
        UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1).set()
        anglePathBig.stroke()
        
        UIColor.redColor().set()
        innerCirclePath1.stroke()
        
        UIColor.blueColor().set()
        innerCirclePath2.stroke()
        
        UIColor(red: 0, green: 210/255, blue: 0, alpha: 1).set()
        innerCirclePath3.stroke()
        
        UIColor(red: 240/255, green: 240/255, blue: 0, alpha: 1).set()
        innerCirclePath4.stroke()
        
        mainCircleColor.set()
        mainCirclePath.fill()
        
//        UIGraphicsBeginImageContext(self.frame.size)
//        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//        UIGraphicsEndImageContext()
        
    }
}