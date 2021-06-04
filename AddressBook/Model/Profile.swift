//
//  Profile.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 21.04.2021.
//

import Foundation

struct Profile : Codable {
    
    var id : String
    var username : String
    var fullname : String
    var email : String
    var online : Bool
    
}
