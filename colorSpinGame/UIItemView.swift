//
//  UIItemView.swift
//  colorSpinGame
//
//  Created by Jure Sotosek on 17/12/15.
//  Copyright © 2015 Jure Sotosek. All rights reserved.
//

import UIKit

class UIItemView: UIView {
    
    var pushBehavior: UIPushBehavior?
    var angle: Double?
    var myColor = UIColor()
    var myFrame = CGRect()
    var colorIndex: Int {
        get{
            switch myColor{
            case UIColor(red: 240/255, green: 240/255, blue: 0, alpha: 1): return 1
            case UIColor(red: 0, green: 210/255, blue: 0, alpha: 1): return 2
            case UIColor.blueColor(): return 3
            case UIColor.redColor(): return 4
            default: return 5
            }
        }
    }
    
    override var collisionBoundingPath: UIBezierPath {
        get{return UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: bounds.midX, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true)} }
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0, alpha: 0)
        myFrame = CGRect(origin: CGPointZero, size: frame.size)
        myColor = color
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(ovalInRect: myFrame)
        myColor.set()
        path.fill()
    }
}
