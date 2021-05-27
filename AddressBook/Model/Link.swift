//
//  Link.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 22.05.2021.
//

import Foundation

class Link {
    
    static let sharedLinks : Link = Link()
    
    var links : [String] = [String]()
    
    private init(){
        
    }
    
}
