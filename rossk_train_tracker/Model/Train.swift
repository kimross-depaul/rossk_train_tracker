//
//  Train.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 4/29/21.
//

import Foundation

class Train : CTAObject {
    var line: String;
    var stops: [TrainStop];
    var directions: [String: [TrainStop]] //A dictionary of directions, that holds the stops for that direction
        //So "N" has 4 stops, "S" has 4 stops, "E"... etc.
    
    init(line: String, jArray: jArray) {
        self.line = line;
        for node in jArray {
            if let dict = node as? jDict {
                guard let dir = dict["direction_id"] as? String else {
                    throw SerializationError.missingElement("Missing direction from Train Stop")
                }

            }
        }
        
        stops = [TrainStop]();
        
    }
}
