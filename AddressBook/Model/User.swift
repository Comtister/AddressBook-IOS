//
//  User.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 14.05.2021.
//

import Foundation

struct User {
    var username : String
    var fullname : String
    var email : String
    
    init(data : [String : Any]) {
        self.username = data["username"] as! String
        self.fullname = data["fullname"] as! String
        self.email = data["email"] as! String
    }
    
}
