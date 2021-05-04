//
//  DetailViewController.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 4/28/21.
//

import UIKit

var arrivals = [Arrival]();

class DetailViewController: UITableViewController {
    var selectedStop = TrainStop();
    var isDataLoaded = false;
    var timer: Timer?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(refreshTimes), userInfo: nil, repeats: true);
    }

    override func viewWillAppear(_ animated: Bool) {
        if let t = timer {
            t.fire();
        }
    }
    @objc func refreshTimes() {
        print ("Refreshing...");
        Connect.loadData(parms: ["mapid":selectedStop.stopId], objType: .Arrival, sender: self, completion: { result in
            switch result {
            case .success(let ary):
                print(ary);
            case .failure(let error):
                print(error);
            }
        });
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let t = timer {
            t.invalidate();
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrivals.count;
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArrivalCell", for: indexPath)
        let now = Date()
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        
        if isDataLoaded {
            if let sCell = cell as? ArrivalViewCell {
                let whichArrival = arrivals[indexPath.row];
                sCell.lblDetails.text = "\(whichArrival.stopName) #\(whichArrival.routeNum)"; //"\(line) Line #\(whichArrival.routeNum)";
                sCell.lblMain.text = "\(whichArrival.svcToward)";
                if let thisOnesTime = whichArrival.timePrediction {
                    var minutesLeft = formatter.string(from: now, to: thisOnesTime)! + " Min.";
                    if minutesLeft == "0 Min." {
                        minutesLeft = "Arriving"
                    }
                    sCell.lblMinutes.text = minutesLeft;
                }else {
                    sCell.lblMinutes.text = "Unavailable";
                }
            }
        }
        return cell;
    }
}
