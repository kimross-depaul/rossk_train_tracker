//
//  Connect.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 4/28/21.
//

import UIKit

class Connect {
    func getJson(urlString: String, displayLabel: UILabel) -> Data? {
        var returnData: Data?;
        //Make sure it's a valid URL
        guard let url = URL(string: urlString) else {
            logError(message: "Invalid URL", to: displayLabel);
            return nil;
        }
        
        let session = URLSession.shared;
        let request = URLRequest(url: url);
        
        session.dataTask(with: request) { data, response, error in
            //Make sure there aren't errors with the request
            guard error == nil else {
                self.logError(message: error!.localizedDescription, to: displayLabel);
                return;
            }
            returnData = data;
        }.resume();
        return returnData;
    }
    
    func parseResponse(data: Data?, logTo label: UILabel, responseType: JsonResponseType) -> Any {
        do {
            if responseType == JsonResponseType.dictionary {
                return getDict(data: data, logTo: label)
            }else {
                return getArray(data: data, logTo: label)
            }
        } catch SerializationError.missingElement(let message) {
            self.logError(message: message, to: label);
        } catch SerializationError.invalidResponse(let message, let data) {
            self.logError(message: message, to: label);
            print(data);
        } catch let error as NSError {
            self.logError(message: error.localizedDescription, to: label);
        }
    }
    
    func getDict(data: Data?, logTo label: UILabel?) -> [String: Any] {
        let dict = JSONSerialization.jsonObject(with: data, options: []) as? [String: Any];
    }
    
    func getArray(data: Data?, logTo label: UILabel) -> [Any] {
        
    }
    
    func temp () {
        //Make sure we got data
    /*    guard let data = data else { return }
        
        do {
        
        } catch SerializationError.missingElement(let message) {
            self.logError(message: message, to: displayLabel);
        } catch SerializationError.invalidResponse(let message, let data) {
            self.logError(message: message, to: displayLabel);
            print(data);
        } catch let error as NSError {
            self.logError(message: error.localizedDescription, to: displayLabel);
        }*/
    }
    
    func logError(message: String, to label: UILabel?) {
        if let lbl = label {
            lbl.text = message
        }
        print(message);
    }
    
    enum SerializationError: Error {
        case missingElement(String)
        case invalidResponse(String, Any)
    }
    enum JsonResponseType {
        case dictionary
        case array
        case single
    }
}
