//
//  Stop.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 4/29/21.
//

import Foundation
import MapKit

//A TrainStop represents a place where the train accepts passengers, a train station, like "Belmont".
class TrainStop: CTAObject {
    var name: String;
    var isHandicapAssessible: Int;
    var stopId: String;
    var latitude: Double;
    var longitude: Double;
    
    init (name: String, isHandicapAccessible: Int, stopId: String, lat: Double, long: Double) {
        self.name = name;
        self.isHandicapAssessible = isHandicapAccessible;
        self.stopId = stopId;
        self.latitude = lat;
        self.longitude = long;
    }
    //If we don't receive any data, fill an empty TrainStop with a nice message
    init () {
        name = "Data is currently unavailable";
        isHandicapAssessible = 0;
        stopId = "0";
        latitude = 0.0;
        longitude = 0.0;
    }
    
    func getMarker() -> Marker {
        let coord = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.latitude), longitude: CLLocationDegrees(self.longitude));
        return Marker(coord, title: name);
    }
}
