//
//  Arrival.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 4/29/21.
//

import Foundation

class Arrival: CTAObject {
    var routeNum: String;
    var stopName: String;
    var timePrediction: Date?;
    
    init(routeNum: String, stopName: String, timePrediction: String) {
        self.routeNum = routeNum;
        self.stopName = stopName;
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX");
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.timePrediction = dateFormatter.date(from: timePrediction);
    }
    
}
