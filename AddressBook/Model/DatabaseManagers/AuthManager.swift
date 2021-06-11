//
//  AuthManager.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 15.04.2021.
//

import Foundation
import Firebase

class AuthManager {
    
    static let shared = AuthManager()
    private let db : Firestore
    
    private init(){
        self.db = Firestore.firestore()
    }
    
    func register(mail : String , password : String , username : String , fullName : String , completion : @escaping (Error?) -> Void){
        
        let profileID = UUID().uuidString
        let userProfile = User(id: profileID, username: username, fullname: fullName, email: mail)
        
        checkUser(username: userProfile.username) { [weak self] (isExits, error) in
            if let error = error{
                completion(error)
                return
            }
            
            if isExits!{
                completion(RegisterErrors.userAlreadyExists)
                return
            }else{
                self?.registerAction(profile: userProfile , password: password) { (error) in
                    if let error = error{
                        completion(error)
                        return
                    }
                    self?.setProfile(profile: userProfile)
                    completion(nil)
                }
                
            }
            
        }
        
        }
        
    
    func login(email : String , password : String , completion : @escaping (AuthDataResult?,Error?) -> Void){
        
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] (resultData, error) in
            if let error = error{
                completion(nil,error)
                return
            }
            self?.getProfileData(mail: email) { (profile, error) in
                if let error = error{
                    completion(nil,error)
                    return
                }
                self?.setProfile(profile: profile!)
                completion(resultData,nil)
            }
            
        }
        
    }
    
    //MARK:Offline Profile Funcs
    
    func isOnline() -> Bool{
        
        let userDef = UserDefaults.standard
        
        do {
            if let _ = try userDef.getObject(forKey: "profile", castTo: User.self){
                return true
            }else{
                return false
            }
        } catch {
            return false
        }
        
    
    }
    
    private func setProfile(profile : User){
        let userDef = UserDefaults.standard
        do{
            try userDef.setObject(profile, forKey: "profile")
        }catch{
            
        }
    
    }
    
    func getProfile() -> User?{
        
        let userDef = UserDefaults.standard
        
        do {
        let profile = try userDef.getObject(forKey: "profile", castTo: User.self)
            return profile
        } catch  {
            return nil
        }
        
    }
    
    
    func closeProfile(completion : @escaping (Error?) -> Void){
        UserDefaults.standard.removeObject(forKey: "profile")
        
        do{
            try Auth.auth().signOut()
            completion(nil)
        
        }catch{
            completion(error)
        }
        
    }
    
    
    //MARK:-Private Funcs
    private func registerAction(profile : User, password : String , completion : @escaping (Error?) -> Void){
        
        Auth.auth().createUser(withEmail: profile.email, password: password) {[weak self] (result, error) in
            if let error = error{
                completion(error)
                return
            }
            self?.saveAccount(profile: profile ) { (error) in
                if let error = error{
                    completion(error)
                    return
                }
                completion(nil)
            }
        }
        
    }
    
    private func saveAccount(profile : User, completion : @escaping (Error?) -> Void){
        
        
        db.collection("users").document(profile.id).setData(profile.toDictionary()) { (error) in
            if let error = error{
                completion(error)
                return
            }
            completion(nil)
        }
       
    }
    
    private func getProfileData(mail : String, completion : @escaping (User?,Error?) -> Void){
        
        db.collection("users").whereField("email", isEqualTo: mail).getDocuments { (snapshots, error) in
            if let error = error{
                completion(nil,error)
                return
            }
            if let snapshot = snapshots{
                let document = snapshot.documents[0]
                let profile = User(id: document.get("id") as! String,username: document.get("username") as! String, fullname: document.get("fullname") as! String, email: document.get("email") as! String)
                completion(profile,nil)
            }
            
           
           
        }
        
    }
    
    private func checkUser(username : String , completion : @escaping (Bool?,Error?) -> Void){
        
        db.collection("users").whereField("username", isEqualTo: username).getDocuments { (snapshots, error) in
            if let _ = error{
                completion(nil,RegisterErrors.databaseError)
                return
            }
            if (snapshots?.documents.count)! > 0{
                completion(true,nil)
                return
            }
            completion(false,nil)
            
            
    }
        
    }
    
}
