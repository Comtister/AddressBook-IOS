//
//  Address.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 5.05.2021.
//

import Foundation
import UIKit
import MapKit

class Address{
    
    var id : String
    var title : String
    var desc : String
    var owner : String?
    private var _photo : Data?
    var photo : UIImage?
    private var _latitude : Double
    private var _longitude : Double
    var coordinate : CLLocationCoordinate2D
    private var photoURL : String?
    
    init(id : String , title : String , desc : String , photo : UIImage , coordinate : CLLocationCoordinate2D) {
        self.title = title
        self.desc = desc
        self.photo = photo
        self._photo = photo.jpegData(compressionQuality: 0.5)!
        self._latitude = coordinate.latitude
        self._longitude = coordinate.longitude
        self.coordinate = CLLocationCoordinate2D(latitude: _latitude, longitude: _longitude)
        self.id = id
    }
    
    init(id : String , keyValue : [String : Any]) {
        self.title = keyValue["title"] as! String
        self.desc = keyValue["desc"] as! String
        self._latitude = keyValue["latitude"] as! Double
        self._longitude = keyValue["longitude"] as! Double
        self.coordinate = CLLocationCoordinate2D(latitude: _latitude, longitude: _longitude)
        self.photoURL = keyValue["photo_url"] as! String
        self.id = keyValue["id"] as! String
    }
    
   
    func convertKeyValueArray() -> [String : Any]{
        
        if let owner = owner{
            return ["title" : title , "desc" : desc , "latitude" : _latitude , "longitude" : _longitude , "photo_url" : photoURL ?? "" , "id" : id , "owner" : owner]
        }else{
            return ["title" : title , "desc" : desc , "latitude" : _latitude , "longitude" : _longitude , "photo_url" : photoURL ?? "" , "id" : id]
        }
        
        
        
    }
    
    func getPhotoUrl() -> String{
        return self.photoURL ?? ""
    }
    
    func setPhotoUrl(path : String){
        self.photoURL = path
    }
    
    func getPhotoData() -> Data{
        return _photo ?? Data()
    }
    
    
}
