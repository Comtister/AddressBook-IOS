//
//  AuthManager.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 15.04.2021.
//

import Foundation
import Firebase

class AuthManager {
    
    enum AuthErrors : String, Error{
        case databaseError = "Database Error"
        case userAlreadyExısts = "User already exısts"
       
    }
    
    private static let db = Firestore.firestore()
    
    
    static func registerAccount(mail : String , password : String , username : String , fullName : String , completion : @escaping (Error?) -> Void){
        
        db.collection("users").whereField("username", isEqualTo: username).getDocuments { (snapshots, error) in
            if let error = error{
                completion(AuthErrors.databaseError)
                return
            }
            if (snapshots?.documents.count)! > 0{
                completion(AuthErrors.userAlreadyExısts)
                return
            }
            registerAction(mail: mail, username: username, fullname: fullName, password: password) { (error) in
                if let error = error{
                    completion(error)
                    return
                }
                completion(nil)
            }
            
            
        }
        
        
    }
    
    private static func registerAction(mail : String , username : String , fullname : String , password : String , completion : @escaping (Error?) -> Void){
        
        Auth.auth().createUser(withEmail: mail, password: password) { (result, error) in
            if let error = error{
                completion(error)
                return
            }
            saveAccount(mail: mail, username: username, fullName: fullname) { (error) in
                if let error = error{
                    completion(error)
                    return
                }
                completion(nil)
            }
        }
        
    }
    
    private static func saveAccount(mail : String , username : String , fullName : String , completion : @escaping (Error?) -> Void){
        
        db.collection("users").document(username).setData(["email" : mail , "username" : username , "fullname" : fullName]) { (error) in
            if let error = error{
                completion(error)
                return
            }
            completion(nil)
        }
       
    }
    
   
    
    
}
