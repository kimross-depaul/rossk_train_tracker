//
//  LineCircle.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 5/3/21.
//

import UIKit

class LineCircle: UIView {
    var dotX = CGFloat(0.0);
    var dotString = "Start";
    let barWidth = CGFloat(15.0);
    let dotDiameter = CGFloat(20.0)
    
    override func draw(_ rect: CGRect) {
        //Draws the blue rectangle
        let barRect = CGRect(x: 5, y: 0, width: barWidth, height: bounds.height);
        let barPath = UIBezierPath(rect: barRect);
        UIColor.blue.set();
        barPath.fill();
        
        //Draws the dot that represents where we are in the process
        let dot = CGRect(x: 2, y:bounds.height/2 - (dotDiameter/2), width: dotDiameter, height: dotDiameter);
        let dotPath = UIBezierPath(ovalIn: dot);
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setFill();
        dotPath.fill();
        #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).setFill();
        dotPath.stroke();
    }
}
