//
//  JsonUtil.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 5/15/21.
//

import Foundation

class JsonUtil {
    static func getElement(from: jDict, name: String) -> Any? {
        return from[name];
    }
    static func getString(_ from: jDict, _ name: String) -> String {
        guard let str = getElement(from: from, name: name) as? String else {return ""}
        return str;
    }
    static func getDouble(_ from: jDict, _ name: String) -> Double {
        guard let dbl = getElement(from: from, name: name) as? Double else {return -1.0}
        return dbl;
    }
    static func getInt(_ from: jDict, _ name: String) -> Int {
        guard let i = getElement(from: from, name: name) as? Int else {return 0}
        return i;
    }
    static func isTrue(_ from: jDict, _ name: String) -> String {
        guard let i = getElement(from: from, name: name) as? Int else {return ""}
        if i == 1 {
            return name;
        }
        return "";
    }
    
    
    /*
    static func getElement(from: jArray, with name: String) -> Any? {
        return f
    }
    static getString(from:jArray, with name: String) -> String {
        guard let
    }
    static getDouble(from: jArray, with name: String) -> Double {
        
    }
    static getInt(from: jArray, with name: String) -> Int {
        
    }*/
    static func getLatLong(_ location: Any?) -> (Double, Double) {
        var lat: Double = 0.0;
        var long: Double = 0.0;
        if let locAry = location as? jDict {
            let locLat = locAry["latitude"] ?? "0";
            let locLong = locAry["longitude"] ?? "0";
            
            if let strLat = locLat as? String {
                lat = NumberFormatter().number(from: strLat)?.doubleValue ?? 0.0;
            }
            if let strLong = locLong as? String {
                long = NumberFormatter().number(from: strLong)?.doubleValue ?? 0.0;
            }
        }
        return (lat, long);
    }
}
