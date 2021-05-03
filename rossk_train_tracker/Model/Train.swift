//
//  Train.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 4/29/21.
//

/*
 
 A Train has
    - Directions (N, S, E, and W)
    - Stops for that direction ("Austin", "Belmont", etc.)
 So it looks something like this:
    Direction:  S
        Harlem
        Clark/Lake
 
    Direction: N
        Harlem
        Belmont
        Clark/Lake
 */

import Foundation

class Train : CTAObject {
    var line: String;
    var trainStops: Dictionary<String, TrainStop>?  // Stop Name + Stop Details
    var indexes = Dictionary<Int, String>();
//    var directions: Dictionary<String, Dictionary<Int, TrainStop>>;
    
    init (line: String, stopName: String, isAda: Int, direction: String, stopId: String) {
        self.line = line;
        //directions = [String: [TrainStop]]();
        trainStops = Dictionary<String, TrainStop>();
        indexes = Dictionary<Int, String>();
        
        addStop(stopName: stopName, isAda: isAda, direction: direction, stopId: stopId);
    }
    
    func addStop(stopName: String, isAda: Int, direction: String, stopId: String) {
        let t = TrainStop(name: stopName, isHandicapAccessible: isAda, stopId: stopId);

        let exists = trainStops?[stopName] != nil
        
        if !exists {
            trainStops?[stopName] = t;
            indexes[indexes.count] = stopName;
        }
    }
    init () {
        self.line = "Stops currently unavailable";
//        directions = [String: [TrainStop]]();
        trainStops = Dictionary<String, TrainStop>();
        indexes = Dictionary<Int, String>();
    }

    func getStop(_ index: Int) -> TrainStop {
        if let requestedIndex = indexes[index] {
            return trainStops?[requestedIndex] ?? TrainStop();
        }
        return TrainStop();
    }
    
}
