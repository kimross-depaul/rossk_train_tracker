//
//  Stop.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 4/29/21.
//

import Foundation

class TrainStop: CTAObject {
    var name: String;
    var isHandicapAssessible: Bool;
    
    init (name: String, isHandicapAccessible: Bool) {
        self.name = name;
        self.isHandicapAssessible = isHandicapAccessible;
        
    }
}
