//
//  LineCircle.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 5/3/21.
//
/*
 ToDo:
 look for all "come back's"
 make sure everything is completely error checked
 Turn off wifi and make sure the app handles appropriately
 */

import UIKit

class LineCircle: UIView {
    var dotX = CGFloat(0.0);
    var dotString = "Start";
    let barWidth = CGFloat(15.0);
    let dotDiameter = CGFloat(20.0)
    var barColor = UIColor.blue;
    
    override func draw(_ rect: CGRect) {
        //Draws the blue rectangle
        let barRect = CGRect(x: 5, y: 0, width: barWidth, height: bounds.height);
        let barPath = UIBezierPath(rect: barRect);
        barColor.set();
        barPath.fill();
        
        //Draws the dot that represents where we are in the process
        let dot = CGRect(x: 2, y:bounds.height/2 - (dotDiameter/2), width: dotDiameter, height: dotDiameter);
        let dotPath = UIBezierPath(ovalIn: dot);
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setFill();
        dotPath.fill();
        #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).setFill();
        dotPath.stroke();
    }
    //Lines from City of Chicago:  red, blue, g, brn, p, y, pnk, o
    //Lines from Chicago Transit:  red, blue, g, brn, p, y, pink, org
    func setColor(strColor: String) {
        switch strColor.lowercased() {
        case "red": barColor = UIColor.red;
        case "blue": barColor = UIColor.blue;
        case "g" : barColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1);
        case "brn": barColor = UIColor.brown;
        case "p" : barColor = UIColor.purple;
        case "y" : barColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1);
        case "pink": barColor = #colorLiteral(red: 1, green: 0.4882920081, blue: 0.6821268715, alpha: 1);
        case "org" : barColor = UIColor.orange;
        default: barColor = UIColor.black;
        }
        setNeedsDisplay();
    }
}
