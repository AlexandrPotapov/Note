//
//  ColorTagView.swift
//  Note
//
//  Created by lancelap on 03.08.2019.
//  Copyright © 2019 lancelap. All rights reserved.
//

import UIKit

@IBDesignable
class ColorTagView: UIView {
    
    @IBInspectable
    var color: UIColor = UIColor.white { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    @IBInspectable
    var isCurrent: Bool = false { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    

    override func draw(_ rect: CGRect) {
        
        let rect = CGRect(x: bounds.minX + 1, y: bounds.minY + 1, width: 48, height: 48)
        
        let pathFill = UIBezierPath(rect: rect)
        
        color.setFill()
        pathFill.fill()
        
        
        let pathRectStroke = UIBezierPath(rect: rect)
        
        pathRectStroke.lineWidth = 2
        UIColor.black.setStroke()
        pathRectStroke.stroke()
        
        if color == .clear {
            
            let rect = CGRect(x: bounds.minX + 2, y: bounds.minY + 2, width: 46, height: 46)
            
            let path = UIBezierPath(rect: rect)

            let gradient = CAGradientLayer()
            gradient.frame = path.bounds
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 0)
            
            gradient.colors = [UIColor.red.cgColor, UIColor.orange.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor, UIColor.cyan.cgColor,UIColor.blue.cgColor, UIColor.purple.cgColor]
            layer.addSublayer(gradient)
            
            
        }
        
        
        if isCurrent == true {
            
        let pathArc = UIBezierPath()
            
            pathArc.addArc(withCenter:CGPoint(x: bounds.midX + 10, y: bounds.midY - 10), radius: 10, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
            pathArc.lineWidth = 2
            UIColor.black.setStroke()
            pathArc.stroke()

            
            
        
        let path = UIBezierPath()
        
        let point1 = CGPoint(x: bounds.midX + 5, y: bounds.midY - 10)
        let point2 = CGPoint(x: bounds.midX + 10, y: bounds.midY - 5)
        let point3 = CGPoint(x: bounds.midX + 15, y: bounds.midY - 15)

        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        
        path.lineWidth = 2
        UIColor.black.setStroke()
        path.stroke()
    }
    }

}
