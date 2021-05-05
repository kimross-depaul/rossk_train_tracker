//
//  StopTableViewController.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 4/28/21.
//

import UIKit

var line: String = ""; 
var trainStops: [TrainStop]?;
var trains: [Train]?;

class StopTableViewController: UITableViewController, PopupProvider {

    var isDataLoaded = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    override func viewWillAppear(_ animated: Bool) {
        trains = [Train]();
        //Retrieve trains from the API
        Connect.loadData(parms: ["rt":line.lowercased()], objType: .Train, sender: self, completion: { result in
            switch result {
            case .success(let ary):
                print(ary);
            case .failure(let error):
                self.popupMessage(title: "Uh oh!", message: "No trains were returned. \(error.localizedDescription)");
            }
        });
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //We'll have one table row for every train stop
        var stopCount = 0;
        
        guard let trainLine = trains else {
            return 1;
        }
        //There's only one train
        for rootTrain in trainLine {
            stopCount += rootTrain.trainStops?.count ?? 0;
        }
        return stopCount;
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainStop", for: indexPath)
        
        //Only update the table if data was successfully retrieve from the API
        if isDataLoaded {
            guard let trainLine = trains?[0] else {
                return cell;
            }
            if let sCell = cell as? StopTableCell {
                let whichStop = trainLine.getStop(indexPath.row)
                sCell.lblStopName.text = whichStop.name;
                if whichStop.isHandicapAssessible == 1 {
                    sCell.lblStopName.text = whichStop.name + " ♿️"
                }else {

                }
                sCell.barCircle.setColor(strColor: line);
            }
        }
        return cell;
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Launch the detail view when the user picks a stop
        if let detailViewController = segue.destination as? DetailViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                detailViewController.selectedStop = trains?[0].getStop(indexPath.row) ?? TrainStop();
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "To_Detail", sender: self)
    }
    func popupMessage (title: String, message: String) {
        let popup = UIAlertController(title: title, message: message , preferredStyle:  .alert);
        popup.addAction(UIAlertAction(title: "OK", style: .default, handler: nil));
        self.present(popup, animated: true, completion: nil);
    }
}
