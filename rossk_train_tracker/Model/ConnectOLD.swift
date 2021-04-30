//
//  Connect.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 4/28/21.
//

import UIKit

/*
 
 getJson connects to the api
 parseResponse gets a dictionary
 func
 
 */

/*
class Connectold {
    func doIt(urlString: String) {
        /*requestList(urlString: urlString) { result in
            if result == .success(let data)
        }*/
    }
    static func requestList(urlString: String, completionHandler: @escaping (Result<Data, SerializationError>) -> Void) {
        guard let url = URL(string: urlString) else {
            return ;
        }
        let session = URLSession.shared;
        let request = URLRequest(url: url);
        
        session.dataTask(with: request) { data, response, error in
            //Make sure there aren't errors with the request
            guard error == nil else {
                self.logError(message: "Error #1:  error requesting data - \(error!.localizedDescription)");
                return;
            }
            guard let data = data else {
                completionHandler(.failure(.invalidResponse("Did not receive data from server.", "")))
                return;
            }
            completionHandler(.success(data));
        }.resume();
    }
/*    func fetchUnreadCount1(from urlString: String, completionHandler: @escaping (Result<Int, SerializationError>) -> Void)  {
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(SerializationError.invalidResponse("Bad URL", "")))
            return
        }

        completionHandler(.success(5))
    }
    
    func doIt() {
        fetchUnreadCount1(from: "https://www.hackingwithswift.com") { result in
            switch result {
            case .success(let count):
                print("\(count) unread messages.")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }*/
    
    static func getJson(urlString: String, completion: (Result<Int, Error>)) -> [String:Any] {
        var returnData: [String: Any];
        //Make sure it's a valid URL
        guard let url = URL(string: urlString) else {
            logError(message: "Invalid URL");
            return [String:Any]();
        }
        
        let session = URLSession.shared;
        let request = URLRequest(url: url);
        
        session.dataTask(with: request) { data, response, error in
            //Make sure there aren't errors with the request
            guard error == nil else {
                self.logError(message: "Error #1:  error requesting data - \(error!.localizedDescription)");
                return;
            }
            //returnData =
            parseResponse(data: data);
        }.resume();
        return [String:Any](); //returnData;
    }
    
    static func parseResponse(data: Data?) -> [String: Any] {
        guard let data = data else { return [String:Any]()}
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("json is \(json)")
                return json;
            }
        } catch SerializationError.missingElement(let message) {
            self.logError(message: message);
        } catch SerializationError.invalidResponse(let message, let data) {
            self.logError(message: message);
            print(data);
        } catch let error as NSError {
            self.logError(message: error.localizedDescription);
        }
        return Dictionary<String, String>();
    }
    
    
    static func logError(message: String) {
        print(message);
    }


}
*/
