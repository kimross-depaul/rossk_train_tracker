//
//  HomeViewController.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 4/28/21.
//

import UIKit
import CoreLocation
import MapKit

var arrivals = [Arrival]();
var trains = [Train]();
var trainStops = [TrainStop]();

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate, PopupProvider, Refreshable {

    @IBOutlet var btnRed: UIButton!
    @IBOutlet var btnOrange: UIButton!
    @IBOutlet var btnGreen: UIButton!
    @IBOutlet var btnYellow: UIButton!
    @IBOutlet var btnBlue: UIButton!
    @IBOutlet var btnBrown: UIButton!
    @IBOutlet var btnPurple: UIButton!
    @IBOutlet var btnPink: UIButton!
    @IBOutlet var map: MKMapView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnMyLocation: UIButton!
    
    let locationManager = CLLocationManager();
    var isDataLoaded = false;
    var visibleStops: [TrainStop] = [TrainStop]();
    var tappedPinId: Int?
    var hasLocationPermission = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self;
        tableView.dataSource = self;
        
        //Request Permission for your location (when the app is in use)
        locationManager.requestWhenInUseAuthorization()

        //Get the user's permission to use their location
        switch locationManager.authorizationStatus {
        case .restricted, .denied, .notDetermined:
            popupMessage(title: "Location Services", message: "Unable to determine your current location - allow 'Location Services' permissions in Settings to enable that feature.");
        default:
            hasLocationPermission = true;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            locationManager.distanceFilter = 1 //meter
            locationManager.delegate = self;
        }
        map.delegate = self;
        map.isZoomEnabled = true;
        map.isScrollEnabled = true;
    }
    override func viewWillAppear(_ animated: Bool) {
        //Hide the nav bar from root controller
        self.navigationController?.setNavigationBarHidden(true, animated: true);
        
        //COME BACK - SHOULD EXECUTE WHEN THE PERSON MOVES, not just when view appears
        if (hasLocationPermission) {
            centerMapOnMyLocation();
        }

        //Retrieve trains from the API
        trains = [Train]();
        Connect.loadData(parms: ["rt":""], objType: .Train, sender: self, completion: { result in
            switch result {
            case .success( _):
                putAnnotations();
            case .failure(let error):
                self.popupMessage(title: "Uh oh!", message: "No trains were returned. \(error.localizedDescription)");
            }
        });
    }
    func centerMapOnMyLocation() {
        if let myLoc: CLLocationCoordinate2D = locationManager.location?.coordinate {
            let regionView = MKCoordinateRegion(center: myLoc, latitudinalMeters: 500, longitudinalMeters: 500);
            map.setRegion(regionView, animated: false);
            map.showsUserLocation = true;
        }else {
            popupMessage(title: "Location Not Available", message: "Unable to determine your current location - listing all train stops in Chicago.");
        }
    }
    @IBAction func btnMyLocation_click(_ sender: UIButton) {
        centerMapOnMyLocation();
    }
    
    func putAnnotations() {
        if self.isDataLoaded {
            visibleStops = [TrainStop]();
            tappedPinId = -1;
            //if let trains = trains {
                for t in trains {
                    if let stops = t.trainStops {
                        var i = 0;
                        for stop in stops {
                            let mark = stop.value.getMarker();
                            if isCoordNearby(coord: mark.coordinate) {
                                map.addAnnotation(mark);
                                stop.value.setDistanceToMe(yourCoord: locationManager.location?.coordinate);
                                visibleStops.append(stop.value);
                                i += 1;
                            }
                        }
                    }
                }
          //  }
            visibleStops.sort {$0.distanceToMe < $1.distanceToMe} ;
            tableView.reloadData();
        }
    }
    func isCoordNearby(coord: CLLocationCoordinate2D) -> Bool {
        let visibleMapRect:MKMapRect = map.visibleMapRect;
        let point = MKMapPoint(coord);
        return visibleMapRect.contains(point);
    }
    override func viewWillDisappear(_ animated: Bool) {
        //Show the nav bar before navigating to other controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        locationManager.stopUpdatingLocation();
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Get the train-line from the icon the user clicked
        var selectedStop = -1;
        if let pinId = tappedPinId {
            if pinId >= 0 { selectedStop = pinId; }
        }
        if let tblId = self.tableView.indexPathForSelectedRow {
            if selectedStop < 0 {
                selectedStop = tblId.row;
            }
        }
        if let detailViewController = segue.destination as? DetailViewController {
            if selectedStop >= 0 {
                detailViewController.selectedStop = visibleStops[selectedStop];
            }
        }
    }
    func popupMessage (title: String, message: String) {
        let popup = UIAlertController(title: title, message: message , preferredStyle:  .alert);
        popup.addAction(UIAlertAction(title: "OK", style: .default, handler: nil));
        self.present(popup, animated: true, completion: nil);
    }
    func refresh() {
        isDataLoaded = true;
        tableView.reloadData();
        putAnnotations();
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let myLoc: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let regionView = MKCoordinateRegion(center: myLoc, latitudinalMeters: 500, longitudinalMeters: 500);
        map.setRegion(regionView, animated: false);
    }
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
     //   map.removeAnnotations(map.annotations);
        putAnnotations();
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view : MKPinAnnotationView
        guard let annotation = annotation as? Marker else {return nil}
        let id = annotation.mapId ?? "";
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKPinAnnotationView {
            view = dequeuedView
        }else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: id);
        }
        view.isEnabled = true;
        view.canShowCallout = true;
        view.pinTintColor = #colorLiteral(red: 0.2948878094, green: 0.2563245438, blue: 0.5212025808, alpha: 1);
        let btn = UIButton(type: .detailDisclosure);
        
        view.leftCalloutAccessoryView = btn;
        return view;
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let marker = view.annotation as! Marker;
        var i = 0;
        for stop in visibleStops {
            if stop.stopId == marker.mapId {
                tappedPinId = i;
                break;
            }
            i += 1;
        }
        self.performSegue(withIdentifier: "To_Detail", sender: self)
    }
    //***************************************************************
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleStops.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainStop", for: indexPath)
        
        //Only update the table if data was successfully retrieve from the API
        if isDataLoaded {
            if trains.count == 0 {
                return cell;
            }
            if let sCell = cell as? StopTableCell {
                let whichStop = visibleStops[indexPath.row]; //trainLine.getStop(indexPath.row)
                sCell.lblStopName.text = whichStop.name;
                if whichStop.isHandicapAssessible == 1 {
                    sCell.lblStopName.text = whichStop.name + " ♿️"
                }
                sCell.lblSubtitle.text = whichStop.getDistance();
                sCell.barCircle.setColor(strColor: "");
                sCell.colors.colorsToDraw = [String]();
                for c in whichStop.strColors {
                    sCell.colors.addColor(strColor: c);
                }
                sCell.colors.setNeedsDisplay();
            }
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "To_Detail", sender: self)
    }
}

extension UIButton {


}
