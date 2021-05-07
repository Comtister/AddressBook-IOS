//
//  AddressSaveViewController.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 30.04.2021.
//

import UIKit
import CoreLocation
import MapKit

class AddressSaveViewController: UIViewController, UINavigationControllerDelegate{

    @IBOutlet var mapview : MKMapView!
    @IBOutlet var addressPhoto : UIButton!
    @IBOutlet var addressTitle : UITextField!
    @IBOutlet var addressDescription : UITextField!
    @IBOutlet var saveBtn : UIButton!
    
    var photoController : UIImagePickerController!
    
    var coordinate : CLLocationCoordinate2D!
    private var addressMark : MKPlacemark!
    private var photo : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveBtn.layer.cornerRadius = 10
        

        addressMark = MKPlacemark(coordinate: coordinate)
        mapview.addAnnotation(addressMark)
        mapview.setRegion(MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
        
      
        photoController = UIImagePickerController()
        photoController.delegate = self
        // On this line Real Device photoController.sourceType = .camera
        //photoController.cameraDevice = .rear
        
        
       
        
    }
    

    @IBAction func setPhoto(_ sender : Any){
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            self.present(photoController, animated: true, completion: nil)
    
        }else{
            Alerts.showBasicDialog(VC: self, titles: "Ops","Close", messages: "Your device not suppported camera")
        }
        
        
        
    }
    
    @IBAction func saveAddress(){
        
        guard addressTitle.text != "" else{ Alerts.showBasicDialog(VC: self, titles: "Ops","Close", messages: "Title Field cannot be empty") ; return }
        let addressTitleData = addressTitle.text
        
        if photo == nil{
            photo = UIImage(named: "DefaultAddressImage")
        }
        
        let addressDescData = addressDescription.text
        
        let address = Address(title: addressTitleData!, desc: addressDescData ?? "", photo: photo!, coordinate: coordinate)
        
        DatabaseManager.shared.saveAddress(address: address) { [weak self] (error) in
            if let error = error{
                
            }
            self?.performSegue(withIdentifier: "goBackAddressList", sender: nil)
        }
        
        
    }
   
    
}

extension AddressSaveViewController : UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        photo = info[.originalImage] as? UIImage
        addressPhoto.setImage(photo, for: .normal)
        dismiss(animated: true, completion: nil)
        
    }
    
}
