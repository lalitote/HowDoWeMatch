//
//  SpinningCircleView.swift
//  HowDoWeMatch
//
//  Created by lalitote on 30.08.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

@IBDesignable
class SpinningCircleView: UIView {
    
    @IBInspectable
    private var scale: CGFloat = 0.9
    
    @IBInspectable
    private var color: UIColor = UIColor.blueColor()
    
    @IBInspectable
    private var lineWidth: CGFloat = 1.0
    
    var circleRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 20 * scale
    }
    
    var circleCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY )
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2*M_PI),
            clockwise: false)
        
        path.lineWidth = lineWidth
        return path
    }
    
    override func drawRect(rect: CGRect)
    {
        color.set()
        pathForCircleCenteredAtPoint(circleCenter, withRadius: circleRadius).stroke()
        
    }


}
