//
//  Stop.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 4/29/21.
//

import Foundation

//A TrainStop represents a place where the train accepts passengers, a train station, like "Belmont".
class TrainStop: CTAObject {
    var name: String;
    var isHandicapAssessible: Int;
    var stopId: String
    
    init (name: String, isHandicapAccessible: Int, stopId: String) {
        self.name = name;
        self.isHandicapAssessible = isHandicapAccessible;
        self.stopId = stopId;
    }
    //If we don't receive any data, fill an empty TrainStop with a nice message
    init () {
        name = "Data is currently unavailable";
        isHandicapAssessible = 0;
        stopId = "0";
    }
}
