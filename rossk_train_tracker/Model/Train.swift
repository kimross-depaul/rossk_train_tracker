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
    var trainStops: Dictionary<String, TrainStop>?  // Stop Name + Stop Details
    
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
        }else {
            trainStops?[t.name]?.mergeColors(t.strColors);
        }

    }
  
    init () {
        trainStops = Dictionary<String, TrainStop>();
    }

}
