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
    //var line: String;
    var trainStops: Dictionary<String, TrainStop>?  // Stop Name + Stop Details
    //var indexes = Dictionary<Int, String>();
    
    init (node: jDict) {
        trainStops = Dictionary<String, TrainStop>();
        addStop(node: node);
    }
    func addStop(node: jDict) {
        let t = TrainStop();
        t.name = JsonUtil.getString(node, "station_name");
        t.isHandicapAssessible = JsonUtil.getInt(node, "ada");
        t.stopId = JsonUtil.getString(node, "map_id");
        let lat_long = JsonUtil.getLatLong(node["location"]);
        t.latitude = lat_long.0;
        t.longitude = lat_long.1;
        //let stopName = node["station_name"] as? String ?? "";
        //let isAda = node["ada"] as? Int ?? 0;
        //let dirId = node["direction_id"] as? String ?? "";
        //let stopId = node["map_id"] as? String ?? "";

        t.addColor(JsonUtil.isTrue(node, "red"));
        t.addColor(JsonUtil.isTrue(node, "blue"));
        t.addColor(JsonUtil.isTrue(node, "g"));
        t.addColor(JsonUtil.isTrue(node, "brn"));
        t.addColor(JsonUtil.isTrue(node, "p"));
        t.addColor(JsonUtil.isTrue(node, "y"));
        t.addColor(JsonUtil.isTrue(node, "pnk"));
        t.addColor(JsonUtil.isTrue(node, "o"));
        let exists = trainStops?[t.name] != nil
        
        if !exists {
            trainStops?[t.name] = t;
        }

    }
   /* init (line: String, stopName: String, isAda: Int, direction: String, stopId: String, lat: Double, long: Double) {
        self.line = line;
        trainStops = Dictionary<String, TrainStop>();
        indexes = Dictionary<Int, String>();
        
        addStop(stopName: stopName, isAda: isAda, direction: direction, stopId: stopId, lat: lat, long: long);
    }
    
    func addStop(stopName: String, isAda: Int, direction: String, stopId: String, lat: Double, long: Double) {
        let t = TrainStop(name: stopName, isHandicapAccessible: isAda, stopId: stopId, lat: lat, long: long);

     let exists = trainStops?[stopName] != nil
     
     if !exists {
         trainStops?[stopName] = t;
         indexes[indexes.count] = stopName;
     }
    }*/
    init () {
        //self.line = "Stops currently unavailable";
        trainStops = Dictionary<String, TrainStop>();
       // indexes = Dictionary<Int, String>();
    }
/*
    //For UITableviews - gets stops by their index
    func getStop(_ index: Int) -> TrainStop {
        if let requestedIndex = indexes[index] {
            return trainStops?[requestedIndex] ?? TrainStop();
        }
        return TrainStop();
    }
    */
}
