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

class StopColors: UIView {
    var dotX = CGFloat(0.0);
    var dotString = "Start";
    let barWidth = CGFloat(20.0);
    let dotDiameter = CGFloat(20.0)
    var pad = CGFloat(3.0);
    var barColor = UIColor.blue;
    var colorsToDraw: [String]?;
    
    override func draw(_ rect: CGRect) {
        //let colorsToDraw = ["red","blue","g","brn","p","y","pink","org"];
        var x = bounds.width - barWidth;
        
        if let colorsToDraw = self.colorsToDraw {
            for color in colorsToDraw {
                let barRect = CGRect(x: CGFloat(x), y: 0, width: barWidth, height: 15.0);
                let barPath = UIBezierPath(rect: barRect);
                setColor(strColor: color);
                barColor.set();
                barPath.fill();
                UIColor.white.set();
                barPath.lineWidth = pad;
                barPath.stroke();
                x -= barWidth;
            }
        }
    }
    
    func setColors(stop: TrainStop) {
        
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
