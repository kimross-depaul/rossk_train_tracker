//
//  Train.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 4/29/21.
//


import Foundation

//A "Train" object represents a train *line*, like "the blue line"
//It has a collection of of stops that it makes

class Train : CTAObject {
    var line: String;
    var trainStops: Dictionary<String, TrainStop>?  // Stop Name + Stop Details
    var indexes = Dictionary<Int, String>();
    
    init (line: String, stopName: String, isAda: Int, direction: String, stopId: String) {
        self.line = line;
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
        trainStops = Dictionary<String, TrainStop>();
        indexes = Dictionary<Int, String>();
    }

    //For UITableviews - gets stops by their index
    func getStop(_ index: Int) -> TrainStop {
        if let requestedIndex = indexes[index] {
            return trainStops?[requestedIndex] ?? TrainStop();
        }
        return TrainStop();
    }
    
}
