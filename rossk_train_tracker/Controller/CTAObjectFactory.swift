//
//  CTAObjectFactory.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 5/1/21.
//

import Foundation

protocol CTAObject {}
    
enum CTAObjectType {
    case Train
    case Arrival
    case TrainStop
}

class CTAObjectFactory {
    //CTA Objects that return Dictionaries are Arrivals and TrainStops
    static func createCTAObject(jDict: jDict, objType: CTAObjectType) -> [CTAObject] {
        switch objType {
        case .Arrival:
            let dataResult = createArrivals(root: jDict);
            switch dataResult {
            case .failure(let error):
                print ("Error getting Arrival data: \(error.localizedDescription)")
                var ret = [Arrival]();
                ret.append(Arrival(routeNum: "", stopName: "Try again later.", svcToward: "Unable to fetch times - try again", timePrediction: ""))
                return ret;
            case .success(let ary):
                return ary;
            }
        case .TrainStop:
            let dataResult = createTrainStops(root: jDict);
            switch dataResult {
            case .failure(let error) :
                print("ERROR!!! \(error)")
                var ret = [TrainStop]();
                ret.append(TrainStop(name: "Unable to get stops - try again later", isHandicapAccessible: 0, stopId: "0", lat: 0.0, long: 0.0))
                return ret;
            case .success(let ary) :
                return ary;
            }
        case .Train:
            print("You used this library incorrectly - Trains return arrays, not dictionaries");
        }
        return [CTAObject]();
    }
    //The only CTAObject that returns an array is a Train object
    static func createCTAObject(jAry: jArray, objType: CTAObjectType) -> [CTAObject] {
        let dataResult = createTrains(root: jAry);
        switch dataResult {
        case .failure(let error):
            print("ERROR! \(error)")
            var ret = [Train]();
            ret.append(Train(line: line, stopName: "Stops not available - try again later", isAda: 0, direction: "", stopId: "", lat: 0.0, long: 0.0));
            return ret;
        case .success(let newTrains):
            return newTrains;
        }
    }
    
    //Lines from City of Chicago:  red, blue, g, brn, p, y, pnk, o
    //Lines from Chicago Transit:  red, blue, g, brn, p, y, pink, org
    
    //Returns the correct URL for a given CTAObject type
    static func createCTAUrl(parms: [String:String], objType: CTAObjectType) -> String {
        switch objType {
        case .Train:
            //The opening screen gets all trains
            if parms["rt"] == "" {
                return "https://data.cityofchicago.org/resource/8pix-ypme.json"
            }
            //This translation is required because the codes between CTA and the City don't match
            let selectedLine = parms["rt"]?.lowercased() ?? "";
            var translatedLine = "";
            switch selectedLine {
            case "pink":
                translatedLine = "pnk";
            case "org":
                translatedLine = "o";
            default:
                translatedLine = selectedLine;
            }
            return "https://data.cityofchicago.org/resource/8pix-ypme.json?\(translatedLine)=true";
        case .Arrival:
            let mapid = parms["mapid"] ?? "";
            return "https://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=3a2367a9d5ca4cd695e310b7350b2b91&mapid=\(mapid)&outputType=JSON";
        case .TrainStop:
            return "https://lapi.transitchicago.com/api/1.0/ttfollow.aspx?key=3a2367a9d5ca4cd695e310b7350b2b91&runnumber=\(String(describing: parms["runnumber"]))&outputType=JSON";
        }
    }
    
    //Creates TrainStop CTAObjects from a json dictionary
    static func createTrainStops(root: jDict) -> Result<[TrainStop],SerializationError> {
        var trainStopResults = [TrainStop]();
        guard let entries = root["route"] as? jArray else {
            return .failure(SerializationError.missingElement("There should be a 'route' node!"));
        }
        
        for e in entries {
            if let entry = e as? jDict {
                //trains are an array of train attributes (route 422, about to stop at station 40380... etc.)
                guard let trains = entry["train"] as? jArray else {
                    return .failure(SerializationError.missingElement("The Train element is missing"));
                }
                //Get each station name, handicap status, and stop ID from the results.
                //These are appended to the array we return
                for t in trains {
                    if let thisTrain = t as? [String:Any] {
                        
                        let nextName = thisTrain["nextStaNm"] as? String ?? "Unavailable";
                        let newStop = TrainStop(name: nextName, isHandicapAccessible: 1, stopId: "1", lat: 0.0, long: 0.0);
                        trainStopResults.append(newStop);
                    }
                }
            }
        }
        return .success(trainStopResults);
    }
    //Creates Train CTAObjects from the json result
    static func createTrains(root: jArray) -> Result<[Train],SerializationError> {
        //There is 1 Train object with many TrainStops.
        var retTrains = [Train]();
        var append = true;
        
        //If part of the result is missing, return the data we did get
        //Create a Train, then TrainStops (added to our Train object)
        for trainNode in root {
            if let node = trainNode as? jDict {
                let stopName = node["station_name"] as? String ?? "";
                let isAda = node["ada"] as? Int ?? 0;
                let dirId = node["direction_id"] as? String ?? "";
                let stopId = node["map_id"] as? String ?? "";
                let lat_long = getLatLong(node["location"]);
                
                if append {
                    let newTrain = Train(line: line, stopName: stopName, isAda: isAda, direction: dirId, stopId: stopId, lat: lat_long.0, long: lat_long.1);
                    retTrains.append(newTrain);
                    append = false;
                }else {
                    retTrains[0].addStop(stopName: stopName, isAda: isAda, direction: dirId, stopId: stopId, lat: 0.0, long: 0.0)
                }
            }
        }
        return .success(retTrains);
    }
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
    //Creates an Arrival CTAObject from the json result
    static func createArrivals(root: jDict) -> Result<[Arrival],SerializationError>{
        var retArrivals = [Arrival]();
        
        //If data is missing, return as much data as they send.
        if let etas = root["eta"] as? jArray {
            for eta in etas {
                if let eta = eta as? jDict {
                    let rn = eta["rn"] as? String ?? "?"
                    let staNm = eta["staNm"] as? String ?? "Unable to load stations."
                    let timePred = eta["arrT"] as? String ?? ""
                    let svcToward = eta["stpDe"] as? String ?? ""
                    let a = Arrival(routeNum: rn, stopName: staNm, svcToward: svcToward, timePrediction: timePred)
                    retArrivals.append(a);
                }
            }

        }
        return .success(retArrivals);
    }
}
