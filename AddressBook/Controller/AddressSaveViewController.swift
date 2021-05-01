//
//  AddressSaveViewController.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 30.04.2021.
//

import UIKit
import CoreLocation
import MapKit

class AddressSaveViewController: UIViewController {

    @IBOutlet var mapview : MKMapView!
    @IBOutlet var addressPhoto : UIButton!
    @IBOutlet var addressTitle : UITextField!
    @IBOutlet var addressDescription : UITextField!
    @IBOutlet var saveBtn : UIButton!
    
    var photoController : UIImagePickerController!
    
    var coordinate : CLLocationCoordinate2D!
    private var addressMark : MKPlacemark!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveBtn.layer.cornerRadius = 10

        addressMark = MKPlacemark(coordinate: coordinate)
        mapview.addAnnotation(addressMark)
        mapview.setRegion(MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
        
        photoController = UIImagePickerController(rootViewController: self)
        photoController.sourceType = .camera
        print(UIImagePickerController.availableMediaTypes(for: .camera))
        photoController.mediaTypes = ["public.image"]
        
    }
    

    @IBAction func setPhoto(_ sender : Any){
        
        self.present(photoController, animated: true, completion: nil)
        
    }
   

}

extension AddressSaveViewController : UIImagePickerControllerDelegate{
    
    
    
}
