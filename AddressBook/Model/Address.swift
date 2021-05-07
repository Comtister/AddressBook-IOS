//
//  Address.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 5.05.2021.
//

import Foundation
import UIKit
import MapKit

class Address : Codable {
    
    var title : String
    var desc : String
    private var _photo : Data?
    var photo : UIImage?
    private var _latitude : Double
    private var _longitude : Double
    var coordinate : CLLocationCoordinate2D
    private var photoURL : String?
    
    init(title : String , desc : String , photo : UIImage , coordinate : CLLocationCoordinate2D) {
        self.title = title
        self.desc = desc
        self.photo = photo
        self._photo = photo.jpegData(compressionQuality: 0.5)!
        self._latitude = coordinate.latitude
        self._longitude = coordinate.longitude
        self.coordinate = CLLocationCoordinate2D(latitude: _latitude, longitude: _longitude)
    }
    
    init(keyValue : [String : Any]) {
        self.title = keyValue["title"] as! String
        self.desc = keyValue["desc"] as! String
        self._latitude = keyValue["latitude"] as! Double
        self._longitude = keyValue["longitude"] as! Double
        self.coordinate = CLLocationCoordinate2D(latitude: _latitude, longitude: _longitude)
        self.photoURL = keyValue["photo_url"] as! String
    }
    
    enum CodingKeys : CodingKey{
        case title , desc , photo , latitude , longitude
    }
    
    func convertKeyValueArray() -> [String : Any]{
        
        return ["title" : title , "desc" : desc , "latitude" : _latitude , "longitude" : _longitude , "photo_url" : photoURL ?? ""]
        
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(desc, forKey: .desc)
        try container.encode(_photo, forKey: .photo)
        try container.encode(_latitude, forKey: .latitude)
        try container.encode(_longitude, forKey: .longitude)
    }
    
    required init(from decoder: Decoder) throws {
        var container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        desc = try container.decode(String.self, forKey: .desc)
        _photo = try container.decode(Data.self, forKey: .photo)
        photo = UIImage(data: _photo ?? Data())!
        _latitude = try container.decode(Double.self, forKey: .latitude)
        _longitude = try container.decode(Double.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: _latitude, longitude: _longitude)
    }
    
}
