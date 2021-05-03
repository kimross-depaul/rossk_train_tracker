//
//  CTAObjectFactory.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 5/1/21.
//

import Foundation

protocol CTAObject {
    
}

enum CTAObjectType {
    case Train
    case Arrival
    case TrainStop
}

class CTAObjectFactory {
    static func createCTAObject(jDict: jDict, objType: CTAObjectType) -> [CTAObject] {
        switch objType {
        case .Arrival:
            return [Arrival]();
        case .TrainStop:
            //If you wanted a list of train stops, those go on the StopTableViewController
            let dataResult = createTrainStops(root: jDict);
            switch dataResult {
            case .failure(let error) :
                print("ERROR!!! \(error)")
                return [TrainStop]();
            case .success(let ary) :
                return ary;
            }
        case .Train:
            print ("Invalid choice - COME BACK");
        }
        return [CTAObject]();
    }
    static func createCTAObject(jAry: jArray, objType: CTAObjectType) -> [CTAObject] {
        switch objType {
        case .Train:
            let dataResult = createTrains(root: jAry);
            switch dataResult {
            case .failure(let error):
                print ("ERROR! \(error)")
                return [Train]();
            case .success(let newTrains):
                return newTrains;
            }
        case .Arrival:
            print("invalid choice - COME BACK");
        case .TrainStop:
            print("invalid choice - COME BACK");
        }
        return [Train]();
    }
    
    static func createCTAUrl(parms: [String:String], objType: CTAObjectType) -> String {
        switch objType {
        case .Train:
            let selectedLine = parms["rt"]?.lowercased() ?? "";
            return "https://data.cityofchicago.org/resource/8pix-ypme.json?\(selectedLine)=true";
        //"https://lapi.transitchicago.com/api/1.0/ttpositions.aspx?key=3a2367a9d5ca4cd695e310b7350b2b91&rt=\(parms["rt"] ?? "")&outputType=JSON";
        case .Arrival:
            return "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=3a2367a9d5ca4cd695e310b7350b2b91&mapid=\(String(describing: parms["mapid"]))&outputType=JSON";
        case .TrainStop:
            return "http://lapi.transitchicago.com/api/1.0/ttfollow.aspx?key=3a2367a9d5ca4cd695e310b7350b2b91&runnumber=\(String(describing: parms["runnumber"]))&outputType=JSON";
        }
    }

    static func createTrainStops(root: jDict) -> Result<[TrainStop],SerializationError> {
        var trainStopResults = [TrainStop]();
        guard let entries = root["route"] as? jArray else {
            return .failure(SerializationError.missingElement("There should be an 'route' node beneath the root"));
        }
        
        for e in entries {
            if let entry = e as? jDict {
                //@name is an attribute of Route - returns a String
                guard let nodeName = entry["@name"] as? String else {
                    return .failure(SerializationError.missingElement("rn (route number) is missing"));
                }
                //trains are an array of train attributes (route 422, about to stop at station 40380... etc.)
                guard let trains = entry["train"] as? jArray else {
                    return .failure(SerializationError.missingElement("rn (route number) is missing"));
                }
                for t in trains {
                    if let thisTrain = t as? [String:Any] {
                        print (thisTrain);
                        let newStop = TrainStop(name: thisTrain["nextStaNm"] as! String, isHandicapAccessible: 1, stopId: "1");
                        trainStopResults.append(newStop);
                    }
                }
                print (nodeName);
            }
        }
        return .success(trainStopResults);
    }
    static func createTrains(root: jArray) -> Result<[Train],SerializationError> {
        //WE NEED SOME ERROR TRAPPING HERE I THINK
        var retTrains = [Train](); //There's only one train.  it's an array with one train in it for consistency
        var append = true;
        
        for trainNode in root {
            if let node = trainNode as? jDict {
                let stopName = node["station_name"] as? String ?? "";
                let isAda = node["ada"] as? Int ?? 0;
                let dirId = node["direction_id"] as? String ?? "";
                let stopId = node["map_id"] as? String ?? "";
                if append {
                    let newTrain = Train(line: line, stopName: stopName, isAda: isAda, direction: dirId, stopId: stopId);
                    retTrains.append(newTrain);
                    append = false;
                }else {
                    retTrains[0].addStop(stopName: stopName, isAda: isAda, direction: dirId, stopId: stopId)
                }
            }
        }
        return .success(retTrains);
        
    }
}
