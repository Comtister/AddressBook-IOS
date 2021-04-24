//
//  LogicExtensions.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 22.04.2021.
//

import Foundation

extension UserDefaults{
    
    func setObject<Object : Encodable>(_ object : Object , forKey: String) throws{
        let encoder = JSONEncoder()
        
        do{
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        }catch{
            
        }
        
    }
    
    func getObject<Object : Decodable>(forKey : String , castTo type : Object.Type) throws ->Object?{
        
        guard let data = data(forKey: forKey) else{throw RegisterErrors.databaseError}
        let decoder = JSONDecoder()
        
        do{
            let object = try decoder.decode(type, from: data)
            return object
        }catch{
            throw RegisterErrors.databaseError
    }
        
}

}
