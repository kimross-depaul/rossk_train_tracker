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
    
    static func loadData(parms: [String: String], objType: CTAObjectType, sender: UIViewController, completion: (Result<[TrainStop],SerializationError>) -> Void) {
        let urlString = CTAObjectFactory.createCTAUrl(parms: parms, objType: objType);
        guard let url = URL(string: urlString) else { return }
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(15)
        config.timeoutIntervalForResource = TimeInterval(15)
        let session = URLSession(configuration: config)
///        let session = URLSession.shared;
        let request = URLRequest(url: url);
        
        session.dataTask(with: request) { data, response, error in
            //Make sure we have no session or data issues
            guard error == nil else {
                Connect.logError(error?.localizedDescription ?? "Unknown Error");
                return;
            }
            guard let data = data else {return}

            //Parse the JSON and create the correct object
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? jDict {
                    guard let root = json["ctatt"] as? jDict else {
                        throw SerializationError.missingElement("Root node is missing from json");
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
            
            //Refresh the view-controller's data
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
 /*       let actionSheetController: UIAlertController = UIAlertController(title: "Oh no!", message: message, preferredStyle: .actionSheet)

        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        actionSheetController.addAction(cancelAction)
//        actionSheetController.popoverPresentationController?.sourceView = yourSourceViewName // works for both iPhone & iPad
    */
        print (message);
    }
    

}

