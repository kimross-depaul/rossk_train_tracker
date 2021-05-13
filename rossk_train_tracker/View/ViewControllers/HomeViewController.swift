//
//  HomeViewController.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 4/28/21.
//

import UIKit
import CoreLocation
import MapKit

class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var btnRed: UIButton!
    @IBOutlet var btnOrange: UIButton!
    @IBOutlet var btnGreen: UIButton!
    @IBOutlet var btnYellow: UIButton!
    @IBOutlet var btnBlue: UIButton!
    @IBOutlet var btnBrown: UIButton!
    @IBOutlet var btnPurple: UIButton!
    @IBOutlet var btnPink: UIButton!
    @IBOutlet var map: MKMapView!
    
    let locationManager = CLLocationManager();
    var isDataLoaded = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //Styling the button icons
        btnRed.styleMe();
        btnOrange.styleMe();
        btnGreen.styleMe();
        btnYellow.styleMe();
        btnBlue.styleMe();
        btnBrown.styleMe();
        btnPurple.styleMe();
        btnPink.styleMe();
        
        let status = CLLocationManager.authorizationStatus();
        if status == .denied || status == .restricted {
            print ("Location Service not authorized");
        } else {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            locationManager.distanceFilter = 1 //meter
            locationManager.delegate = self;
            locationManager.requestWhenInUseAuthorization()
        }
        guard let myLoc: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        let regionView = MKCoordinateRegion(center: myLoc, latitudinalMeters: 500, longitudinalMeters: 500);
        map.setRegion(regionView, animated: false);
        map.delegate = self;
                
    }
    override func viewWillAppear(_ animated: Bool) {
        //Hide the nav bar from root controller
        self.navigationController?.setNavigationBarHidden(true, animated: true);
        map.showsUserLocation = true;
        map.isZoomEnabled = true;
        map.isScrollEnabled = true;
        

       
        trains = [Train]();
        //Retrieve trains from the API
        Connect.loadData(parms: ["rt":""], objType: .Train, sender: self, completion: { result in
            switch result {
            case .success(let ary):
                putAnnotations();
            case .failure(let error):
                self.popupMessage(title: "Uh oh!", message: "No trains were returned. \(error.localizedDescription)");
            }
        });
    }

    func putAnnotations() {
        if self.isDataLoaded {
//            map.removeAnnotations(map.annotations);
            if let trains = trains {
                for t in trains {
                    if let stops = t.trainStops {
                        print (stops.count);
                        for stop in stops {
                            let mark = stop.value.getMarker();
                            if isCoordNearby(coord: mark.coordinate) {
                                map.addAnnotation(mark);
                            }
                        }
                    }
                }
            }
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
        line = segue.identifier ?? "";
    }
    func popupMessage (title: String, message: String) {
        let popup = UIAlertController(title: title, message: message , preferredStyle:  .alert);
        popup.addAction(UIAlertAction(title: "OK", style: .default, handler: nil));
        self.present(popup, animated: true, completion: nil);
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let myLoc: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let regionView = MKCoordinateRegion(center: myLoc, latitudinalMeters: 500, longitudinalMeters: 500);
        map.setRegion(regionView, animated: false);
    }
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
     //   map.removeAnnotations(map.annotations);
    }
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        putAnnotations();
    }
}

extension UIButton {

    //Sets rounded corners on the icons, moves text label under the icon
    func styleMe(padding: CGFloat = 0.0) {
        self.setTitleColor(UIColor.black, for: UIControl.State.normal);
        let imageSize = self.imageView!.image!.size;
        let titleSize = self.titleLabel!.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding + 20.0
        
        self.layer.cornerRadius = 15.0;

        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0,
            bottom: -40,
            right: -titleSize.width
        )
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
    }

}
