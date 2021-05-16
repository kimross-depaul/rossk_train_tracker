//
//  Marker.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 5/12/21.
//

import UIKit
import MapKit;

class Marker: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D;
    var title: String?;
    var mapId: String?;
    
    init(_ coordinate: CLLocationCoordinate2D, title: String, mapId: String) {
        self.coordinate = coordinate;
        self.title = title;
        self.mapId = mapId;
    }
}
