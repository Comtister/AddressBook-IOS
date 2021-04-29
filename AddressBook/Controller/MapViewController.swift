//
//  MapViewController.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 28.04.2021.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    var locationManager : CLLocationManager = CLLocationManager()
    var mapView : MKMapView?
    
    override func loadView() {
        let mapview = MKMapView()
        
        view = mapview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLocationManager()
        setMapView()
        
    }
    
    private func setMapView(){
        
        mapView = view as? MKMapView
        mapView?.delegate = self
        mapView?.showsUserLocation = true
        mapView?.userTrackingMode = .follow
        
    }
    
    private func setLocationManager(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 5
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
        getLocationRequest()
        
    }
    
    
    private func getLocationRequest(){
        
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            locationManager.requestWhenInUseAuthorization()
            break
        case .denied:
            showDialog()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        default:
            return
        }
    
    }
    
   
    private func showDialog(){
        
        let dialogVC = UIAlertController(title: "Ups", message: "To use the application, you must provide location permission , go to settings and allow location permission", preferredStyle: .alert)
        dialogVC.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self.present(dialogVC, animated: true, completion: nil)
    }
    
}

extension MapViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
      print("burda burda")
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        let status = locationManager.authorizationStatus
        
        switch status {
        case .denied:
            showDialog()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            mapView?.userTrackingMode = .follow
            break
        case .restricted:
            locationManager.requestWhenInUseAuthorization()
            break
        default:
            return
        }
        
    }
    
}


extension MapViewController : MKMapViewDelegate{
    
}
