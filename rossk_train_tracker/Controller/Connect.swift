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
        
        /*let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(25)
        config.timeoutIntervalForResource = TimeInterval(25)*/
        let session = URLSession.shared;// URLSession(configuration: config)
        let request = URLRequest(url: url);
        
        session.dataTask(with: request) { data, response, error in
            //Make sure we have no session or data issues
            guard error == nil else {
                Connect.logError(error?.localizedDescription ?? "Unknown Error", vc: sender);
                return;
            }
            guard let data = data else {return}

            //Parse the JSON and create the correct object
            do {
                try CTAObjectFactory.parseAndCreate(data: data, objType: objType);
            } catch SerializationError.missingElement(let msg) {
                Connect.logError("Missing: \(msg)", vc: sender);
            } catch SerializationError.invalidResponse(let msg, let data) {
                Connect.logError("Invalid:  \(msg), \(data)", vc: sender);
            } catch let error as NSError {
                Connect.logError ("Other Error: \(error.localizedDescription)", vc: sender);
            }
            
            //Refresh the view-controller's data
            DispatchQueue.main.async {
                if let mainSender = sender as? Refreshable {
                    mainSender.refresh();
                }
            }
        }.resume();
    }
    static func logError(_ message: String, vc: UIViewController){
        DispatchQueue.main.async {
            if let currVc = vc as? PopupProvider {
                currVc.popupMessage(title: "Uh oh!", message: message);
            }
        }
    }
    

}

