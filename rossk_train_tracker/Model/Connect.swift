//
//  Connect1.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 4/29/21.
//

import UIKit

typealias jDict = [String: Any]
typealias jArray = [Any]

class Connect {
    //static let instance = Connect()
    //var observers = [Observer]();
    
    static func loadData(parms: [String: String], objType: CTAObjectType, sender: UIViewController, completion: (Result<[TrainStop],SerializationError>) -> Void) {
        let urlString = CTAObjectFactory.createCTAUrl(parms: parms, objType: objType);
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared;
        let request = URLRequest(url: url);
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                Connect.logError(error?.localizedDescription ?? "Unknown Error");
                return;
            }
            print("seeing if there's data")
            guard let data = data else {return}
            print ("there's data")
            
            //THIS DO-CATCH NEEDS TO POPULATE AN ARRAY ON THE VIEW CONTROLLER
            //AND CALL A METHOD ON THAT VIEW CONTROLLER self.tableView.reloadData()
            //WHERE THAT TABLEVIEW IS ALREADY BEING LOADED BY THAT ARRAY OF OBJECTS (records in the example)
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? jDict {
                    guard let root = json["ctatt"] as? jDict else {
                        throw SerializationError.missingElement("Root node 'feed' is missing from json");
                    }
                    if objType == .Arrival {
                        if let newArrivals = CTAObjectFactory.createCTAObject(jDict: root, objType: .Arrival) as? [Arrival] {
                            arrivals = newArrivals;
                        }
                    } else {
                        trainStops = CTAObjectFactory.createCTAObject(jDict: root, objType: objType) as? [TrainStop]
                    }
                }
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? jArray {
                    if objType == .Train {
                        if let newTrains = CTAObjectFactory.createCTAObject(jAry: json, objType: .Train) as? [Train] {
                            trains? = newTrains
                        }
                    }
                }
                
            } catch SerializationError.missingElement(let msg) {
                Connect.logError("Missing: \(msg)");
            } catch SerializationError.invalidResponse(let msg, let data) {
                Connect.logError("Invalid:  \(msg), \(data)");
            } catch let error as NSError {
                Connect.logError ("Other Error: \(error.localizedDescription)");
            }
            //self.isDataLoaded = true;
            DispatchQueue.main.async {
                if let stopSender = sender as? StopTableViewController {
                    stopSender.isDataLoaded = true;
                    stopSender.tableView.reloadData();
                }
                if let arrivalSender = sender as? DetailViewController {
                    arrivalSender.isDataLoaded = true;
                    arrivalSender.tableView.reloadData();
                }
            }
        }.resume();
    }
    static func logError(_ message: String) {
        print(message);
    }
    

}

