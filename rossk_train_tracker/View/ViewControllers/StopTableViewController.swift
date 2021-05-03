//
//  StopTableViewController.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 4/28/21.
//

import UIKit

var line: String = "blue"; // COME BACK
var trainStops: [TrainStop]?;
var trains: [Train]?;

class StopTableViewController: UITableViewController {

    var isDataLoaded = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    override func viewWillAppear(_ animated: Bool) {
        trains = [Train]();
        
        Connect.loadData(parms: ["rt":line.lowercased()], objType: .Train, sender: self, completion: { result in
            switch result {
            case .success(let ary):
                print(ary);
            case .failure(let error):
                print(error);
            }
        });
        /*
        Connect.loadData(parms: ["rt":line], objType: .TrainStop, sender: self, completion: {result in
            print("done loading");
            switch result {
            case .failure(let error) :
                print ("error happened");
            case .success(let ary):
                print ("no error happened")
                trainStops = ary;
            }

        });*/
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var stopCount = 0;
        
        guard let trainLine = trains else {
            return 1;
        }
        for rootTrain in trainLine {
            stopCount += rootTrain.trainStops?.count ?? 0;
        }
        return stopCount;
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainStop", for: indexPath)
        
        if isDataLoaded {
            guard let trainLine = trains?[0] else {
                return cell;
            }
            if let sCell = cell as? StopTableCell {
                let whichStop = trainLine.getStop(indexPath.row)
                sCell.lblStopName.text = whichStop.name + " (" + whichStop.stopId + ")";
            }
        }
        return cell;
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? DetailViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                //subViewController.categoryMenuItems = getMenuItemsForCategory(category: categories[indexPath.row]);
                detailViewController.selectedStop = trains?[0].getStop(indexPath.row) ?? TrainStop();
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "To_Detail", sender: self)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
