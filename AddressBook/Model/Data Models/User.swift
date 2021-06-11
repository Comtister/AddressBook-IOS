//
//  User.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 14.05.2021.
//

import Foundation

struct User : Codable {
    
    var id : String
    var username : String
    var fullname : String
    var email : String
    
    init(data : [String : Any]) {
        self.id = data["id"] as! String
        self.username = data["username"] as! String
        self.fullname = data["fullname"] as! String
        self.email = data["email"] as! String
    }
    
    init(id: String,username: String, fullname: String, email: String){
        self.id = id
        self.username = username
        self.fullname = fullname
        self.email = email
    }
    
    func toDictionary() -> [String : Any]{
        return ["id" : self.id , "username" : self.username , "fullname" : self.fullname , "email" : self.email]
    }
    
}
