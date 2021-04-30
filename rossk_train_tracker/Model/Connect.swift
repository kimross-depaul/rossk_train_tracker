//
//  Connect1.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 4/29/21.
//

import UIKit

class Connect {
    static let instance = Connect()
    
    func loadData(urlString: String) {
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
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                    //Dictionaries are enclosed with {} and return [String: Any]
                    guard let root = json["ctatt"] as? [String: Any] else {
                        throw SerializationError.missingElement("Root node 'feed' is missing from json");
                    }
                    //Arrays are enclosed with [] and return [Any]
                    guard let entries = root["route"] as? [Any] else {
                        throw SerializationError.missingElement("There should be an 'route' node beneath the root");
                    }
                    
                    for e in entries {
                        if let entry = e as? [String:Any] {
                            //@name is an attribute of Route - returns a String
                            guard let nodeName = entry["@name"] as? String else {
                                throw SerializationError.missingElement("rn (route number) is missing")
                            }
                            //trains are an array of train attributes (route 422, about to stop at station 40380... etc.)
                            guard let trains = entry["train"] as? [Any] else {
                                throw SerializationError.missingElement("rn (route number) is missing")
                            }
                            for t in trains {
                                if let thisTrain = t as? [String:Any] {
                                    print (thisTrain)
                                }
                            }
                            print (nodeName);
                        }
                    }
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
    
    
    enum SerializationError: Error {
        case missingElement(String)
        case invalidResponse(String, Any)
    }
}

