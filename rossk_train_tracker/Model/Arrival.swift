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
    var svcToward: String;
    var timePrediction: Date?;
    
    init(routeNum: String, stopName: String, svcToward: String, timePrediction: String) {
        self.routeNum = routeNum;
        self.stopName = stopName;
        self.svcToward = svcToward;
        
        //let timePrediction = "2021-05-03T19:04:44"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX");
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let myDate:Date = dateFormatter.date(from: timePrediction)!;
        self.timePrediction = myDate;
    }
    
}
