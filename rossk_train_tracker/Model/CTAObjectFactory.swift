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
        case .Train:
            return [CTAObject]();
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
        }
    }
/*    static func createCTAObject(jArray: jArray, objType: CTAObjectType) -> CTAObject {
        switch objType {
        case .Train:
            return Train(line: "");
        case .Arrival:
            return Arrival();
        case .TrainStop:
            return TrainStop(name: "", isHandicapAccessible: true);
        }
    }*/
    
    static func createCTAUrl(parms: [String:String], objType: CTAObjectType) -> String {
        switch objType {
        case .Train:
            return "https://lapi.transitchicago.com/api/1.0/ttpositions.aspx?key=3a2367a9d5ca4cd695e310b7350b2b91&rt=\(parms["rt"] ?? "")&outputType=JSON";
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
                        let newStop = TrainStop(name: thisTrain["nextStaNm"] as! String, isHandicapAccessible: true);
                        trainStopResults.append(newStop);
                    }
                }
                print (nodeName);
            }
        }
        return .success(trainStopResults);
    }
}
