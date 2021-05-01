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

    let locationManager : CLLocationManager = CLLocationManager()
    var mapView : MKMapView?
    var mapGesture : UILongPressGestureRecognizer?
    
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
        mapGesture = UILongPressGestureRecognizer(target: self, action: #selector(mapTap(_:)))
        mapGesture?.delegate = self
        mapGesture?.minimumPressDuration = 2
        mapView?.addGestureRecognizer(mapGesture!)
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
    
    @objc func mapTap(_ gestureRecognizer : UILongPressGestureRecognizer){
        
        if gestureRecognizer.state == .began{
            let location = gestureRecognizer.location(in: mapView)
            let coordinate = mapView?.convert(location, toCoordinateFrom: mapView)
            
            showYerOrNoDialog(coordinate: coordinate!)
            print(coordinate)
            
        }
        
       
        
    }
    
    private func showYerOrNoDialog(coordinate : CLLocationCoordinate2D){
        let dialogVC = UIAlertController(title: "Attention", message: "are you sure you want to add the address?", preferredStyle: .alert)
        dialogVC.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] (alert) in
            self?.performSegue(withIdentifier: "AddAddressSegue", sender: coordinate)
        }))
        dialogVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(dialogVC, animated: true, completion: nil)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? AddressSaveViewController{
            vc.coordinate = sender as? CLLocationCoordinate2D
        }
        
    }
    
    private func showDialog(){
        
        let dialogVC = UIAlertController(title: "Ups", message: "To use the application, you must provide location permission , go to settings and allow location permission", preferredStyle: .alert)
        dialogVC.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self.present(dialogVC, animated: true, completion: nil)
    }
    
}

extension MapViewController : UIGestureRecognizerDelegate{
    
  
    
    
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
