//
//  DetailViewController.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 4/28/21.
//

import UIKit

var arrivals = [Arrival]();

class DetailViewController: UITableViewController, PopupProvider, Refreshable {
    var selectedStop = TrainStop();
    var isDataLoaded = false;
    var timer: Timer?;
    var svcTowards: [String]?; //These are the section headers, "Service to O'Hare", for example
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //We want to refresh this view every 10 seconds
        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(refreshTimes), userInfo: nil, repeats: true);
    }

    override func viewWillAppear(_ animated: Bool) {
        //Fire the timer when the screen appears
        if let t = timer {
            t.fire();
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        //Invalidate the timer when this scren disappears
        if let t = timer {
            t.invalidate();
        }
    }
    @objc func refreshTimes() {
        Connect.loadData(parms: ["mapid":selectedStop.stopId], objType: .Arrival, sender: self, completion: { result in
            switch result {
            case .success(let ary):
                print(ary);
            case .failure(let error):
                self.popupMessage(title: "Uh Oh!", message: "No trains were returned. \(error.localizedDescription)");
            }
        });
    }
    
    /******************************************************************************/
    /************************ REFRESHABLE REQ'D FUNCTIONS************************/
    /******************************************************************************/
    func refresh() {
        isDataLoaded = true;
        svcTowards = [String]();
        for arrival in arrivals {
            if svcTowards?.contains(arrival.svcToward) == false {
                svcTowards?.append(arrival.svcToward);
            }
        }
        tableView.reloadData();
    }
    /******************************************************************************/
    /************************ TABLE VIEW FUNCTIONS *******************************/
    /******************************************************************************/
    //The number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let svcTowards = svcTowards {
            return svcTowards.count;
        }else {
            return 1;
        }
    }
    //The number of rows in (the current) section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let whichSection = svcTowards?[section];
        let arrivalsInSection = arrivals.filter() {$0.svcToward == whichSection };
        return arrivalsInSection.count;
    }
    //The section's title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let svcs = svcTowards {
            return svcs[section];
        }
        return "";
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView();
        vw.backgroundColor = #colorLiteral(red: 0.3031301361, green: 0.715178265, blue: 0.7947372512, alpha: 1);
        let lbl = UILabel();
        lbl.text = svcTowards?[section];
        lbl.textColor = UIColor.white;
        lbl.font = .systemFont(ofSize: 20.0);
        lbl.frame = CGRect.init(x: 5, y: 5, width: tableView.frame.width, height: 20.0);
        vw.addSubview(lbl);
        return vw;
    }
    //Populating each row's cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArrivalCell", for: indexPath) 
        let now = Date()
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        
        //When data is loaded fully, refresH this table
        if isDataLoaded {
            if let sCell = cell as? ArrivalViewCell {
                let whichSection = svcTowards?[indexPath.section];
                let arrivalsInSection = arrivals.filter() {$0.svcToward == whichSection };
                let whichArrival = arrivalsInSection[indexPath.row];
                
                sCell.lblDetails.text = "Train #\(whichArrival.routeNum)"
                sCell.lblMain.text = "\(whichArrival.stopName)"; 
                //Calculate how many minutes away the trains are
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
    /******************************************************************************/
    /************************ POPUP PROVIDER FUNCTIONS***************************/
    /******************************************************************************/
    func popupMessage (title: String, message: String) {
        let popup = UIAlertController(title: title, message: message , preferredStyle:  .alert);
        popup.addAction(UIAlertAction(title: "OK", style: .default, handler: nil));
        self.present(popup, animated: true, completion: nil);
    }
}
