//
//  Link.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 22.05.2021.
//

import Foundation

class Link {
    
    static let sharedLinks : Link = Link()
    
    var links : [User] = [User]()
    
    func appendUserFromData(data : [String : Any]){
        let user = User(data: data)
        links.append(user)
    }
    
    private init(){
        
    }
    
}
