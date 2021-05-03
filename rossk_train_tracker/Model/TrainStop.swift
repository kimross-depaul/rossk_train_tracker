//
//  Stop.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 4/29/21.
//

import Foundation

class TrainStop: CTAObject {
    var name: String;
    var isHandicapAssessible: Int;
    var stopId: String
    
    init (name: String, isHandicapAccessible: Int, stopId: String) {
        self.name = name;
        self.isHandicapAssessible = isHandicapAccessible;
        self.stopId = stopId;
    }
    init () {
        name = "Data is currently unavailable";
        isHandicapAssessible = 0;
        stopId = "0";
    }
}
