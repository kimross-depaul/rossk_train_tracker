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
    static let instance = Connect()
    
    func loadData(parms: [String: String], objType: CTAObjectType, completion: (Result<[TrainStop],SerializationError>) -> Void) {
        let urlString = CTAObjectFactory.createCTAUrl(parms: ["rt":line], objType: .Train);
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared;
        let request = URLRequest(url: url);
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                self.logError(error?.localizedDescription ?? "Unknown Error");
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
                    //Dictionaries are enclosed with {} and return [String: Any]
                    guard let root = json["ctatt"] as? jDict else {
                        throw SerializationError.missingElement("Root node 'feed' is missing from json");
                    }
                    
                    CTAObjectFactory.createCTAObject(jDict: root, objType: objType)
                }
            } catch SerializationError.missingElement(let msg) {
                self.logError("Missing: \(msg)");
            } catch SerializationError.invalidResponse(let msg, let data) {
                self.logError("Invalid:  \(msg), \(data)");
            } catch let error as NSError {
                self.logError ("Other Error: \(error.localizedDescription)");
            }
            //self.isDataLoaded = true;
            DispatchQueue.main.async {
                //self.tableView.reloadData();
            }
        }.resume();
    }
    func logError(_ message: String) {
        print(message);
    }
    

}
enum SerializationError: Error {
    case missingElement(String)
    case invalidResponse(String, Any)
}
