//
//  AuthManager.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 15.04.2021.
//

import Foundation
import Firebase

class AuthManager {
    
    private static let db = Firestore.firestore()
    
    
    static func registerAccount(mail : String , password : String , username : String , fullName : String , completion : @escaping (Error?) -> Void){
        
        db.collection("users").whereField("username", isEqualTo: username).getDocuments { (snapshots, error) in
            if let error = error{
                completion(RegisterErrors.databaseError)
                return
            }
            if (snapshots?.documents.count)! > 0{
                completion(RegisterErrors.userAlreadyExists)
                return
            }
            registerAction(mail: mail, username: username, fullname: fullName, password: password) { (error) in
                if let error = error{
                    completion(error)
                    return
                }
                setProfile(username: username, fullname: fullName, email: mail)
                completion(nil)
            }
            
            
        }
        
        
    }
    
    static func loginAccount(email : String , password : String , completion : @escaping (AuthDataResult?,Error?) -> Void){
        
        Auth.auth().signIn(withEmail: email, password: password) { (resultData, error) in
            if let error = error{
                completion(nil,error)
                return
            }
            getProfileData(mail: email) { (profile, error) in
                if let error = error{
                    completion(nil,error)
                    return
                }
                setProfile(profile: profile!)
            }
            completion(resultData,nil)
        }
        
    }
    
    //MARK:Offline profile process methods
    static func isOnline() -> Bool{
        
        let userDef = UserDefaults.standard
        
        do {
            if let profile = try userDef.getObject(forKey: "profile", castTo: Profile.self){
                return true
            }else{
                return false
            }
        } catch {
            return false
        }
        
    
    }
    
    private static func setProfile(profile : Profile){
        let userDef = UserDefaults.standard
        do{
            try userDef.setObject(profile, forKey: "profile")
        }catch{
            
        }
        
        //userDef.set(profile, forKey: "profile")
        
    }
    
    private static func setProfile(username : String , fullname : String , email : String){
        let profile = Profile(username: username, fullname: fullname, email: email, online: true)
        let userDef = UserDefaults.standard
        
        do {
            try userDef.setObject(profile, forKey: "profile")
        } catch {
            
        }
        
        //userDef.setValue(profile, forKey: "profile")
        
    }
    
    static func getProfile() -> Profile?{
        
        let userDef = UserDefaults.standard
        
        do {
        let profile = try userDef.getObject(forKey: "profile", castTo: Profile.self)
            return profile
        } catch  {
            return nil
        }
        
    }
    
    static func closeProfile(completion : @escaping (Error?) -> Void){
        UserDefaults.standard.removeObject(forKey: "profile")
        
        do{
            try Auth.auth().signOut()
            completion(nil)
        
        }catch{
            completion(error)
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
    
    private static func getProfileData(mail : String, completion : @escaping (Profile?,Error?) -> Void){
        
        db.collection("users").whereField("email", isEqualTo: mail).getDocuments { (snapshots, error) in
            if let error = error{
                completion(nil,error)
                return
            }
            if let snapshot = snapshots{
                print( snapshots?.documents[0].get("email"))
                let document = snapshots?.documents[0]
                let profile = Profile(username: document?.get("username") as! String, fullname: document?.get("fullname") as! String, email: document?.get("email") as! String, online: true)
                completion(profile,nil)
            }
            
           
           
        }
        
    }
    
    
}
