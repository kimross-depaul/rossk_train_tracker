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
    var distanceToMe: Double;
    var strColors: [String];
    
    init (name: String, isHandicapAccessible: Int, stopId: String, lat: Double, long: Double) {
        self.name = name;
        self.isHandicapAssessible = isHandicapAccessible;
        self.stopId = stopId;
        self.latitude = lat;
        self.longitude = long;
        distanceToMe = -1;
        strColors = [String]();
    }
    //If we don't receive any data, fill an empty TrainStop with a nice message
    init () {
        name = "Data is currently unavailable";
        isHandicapAssessible = 0;
        stopId = "0";
        latitude = 0.0;
        longitude = 0.0;
        distanceToMe = -1;
        strColors = [String]();
    }
    // A "Color" refers to an El line (Pink Line, Blue line, etc.)
    func addColor(_ strColor: String) {
        strColors.append(strColor);
    }
    //Produces an MKAnnotation subclass with this class' cooredinates
    func getMarker() -> Marker {
        let coord = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.latitude), longitude: CLLocationDegrees(self.longitude));
        return Marker(coord, title: name, mapId: stopId);
    }
    //Given the users' current location, tells how far this point is from them
    func setDistanceToMe(yourCoord: CLLocationCoordinate2D?) {
        if let yourCoord = yourCoord {
            let thisCoord = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude);
            
            let point1 = MKMapPoint(thisCoord);
            let point2 = MKMapPoint(yourCoord);
            distanceToMe =  point1.distance(to: point2);
        } else {
            distanceToMe = -1;
        }
    }
    //Convers from meters to feet / miles, displays a nice message
    func getDistance() -> String {
        let feet = distanceToMe * 3.28084;
        if feet >= 250 {
            return String(format: "%.2f Miles from me", feet/3280.84)
        } else {
            return String(format: "%.0f Feet away", feet);
        }
    }
}
