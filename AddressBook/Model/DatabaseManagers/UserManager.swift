//
//  UserManager.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 10.06.2021.
//

import Foundation
import Firebase

class UserManager{
    
    enum relationshipStatus{
        case noRelation , relation , requestReletion
    }
    
    static let shared : UserManager = UserManager()
    
    private var db : Firestore
    private var storage : Storage
   
    private init(){
        self.db = Firestore.firestore()
        self.storage = Storage.storage()
    }
    
    func getUsers(searchText username : String , completion : @escaping ([User]?,Error?) -> Void){
        
        var datas : [User] = [User]()
        
        db.collection("users").whereField("username", isGreaterThanOrEqualTo: username).whereField("username", isLessThanOrEqualTo: username+"\u{f8ff}").getDocuments { (snapshots, error) in
            if let error = error{
                completion(nil,error)
                return
            }
          
            guard let snapshots = snapshots else {return}
            
            guard !snapshots.documents.isEmpty else {return}
            
            for document in snapshots.documents{
                let user = User(data: document.data())
                if user.username == AuthManager.shared.getProfile()?.username{
                    return
                }
                datas.append(user)
            }
            
            completion(datas,nil)
            
        }
        
    }
    
    func sendRequest(user : User , completion : @escaping (Error?) -> Void){
        
        db.collection("users").document(AuthManager.shared.getProfile()!.id).collection("requestProfiles").addDocument(data: user.toDictionary())
        
        db.collection("users").document(user.id).collection("requests").addDocument(data: AuthManager.shared.getProfile()!.toDictionary()) { (error) in
            if let error = error{
                completion(error)
                return
            }
            
            completion(nil)
            
        }
        
        
    }
    
    func fetchRequest(username : String , completion : @escaping (Error?) -> Void){
        
        var users : [String] = [String]()
        
        db.collection("users").document(AuthManager.shared.getProfile()!.id).collection("requests").addSnapshotListener { (snapshots, error) in
            if let error = error{
                completion(error)
                return
            }
            
            guard let documents = snapshots?.documents else {return}
            
            snapshots?.documentChanges.forEach({ (documentChange) in
                
                if documentChange.type == .added{
                    Link.sharedLinks.appendUserFromData(data: documentChange.document.data())
                }
                
                if documentChange.type == .removed{
                    Link.sharedLinks.links.remove(at: Int(documentChange.oldIndex))
                }
                completion(nil)
            })
            
        
    }
    }
    
    func compareRequest(username : String , completion : @escaping (relationshipStatus?,Error?) -> Void){
        
        db.collection("users").document(AuthManager.shared.getProfile()!.id).collection("shared_users").whereField("username", isGreaterThanOrEqualTo: username).whereField("username", isLessThanOrEqualTo: username+"\u{f8ff}").getDocuments { (snapshots, error) in
            if let error = error{
                completion(nil,error)
                return
            }
            
            guard let snapshots = snapshots else { completion(nil,error) ; return }
            
            if snapshots.documents.count > 0{
                completion(.relation,nil)
                return
            }
            
            
        }
        
        
        db.collection("users").document(AuthManager.shared.getProfile()!.id).collection("requestProfiles").whereField("username", isGreaterThanOrEqualTo: username).whereField("username", isLessThanOrEqualTo: username+"\u{f8ff}").getDocuments { (snapshots, error) in
            
            if let error = error{
                completion(nil,error)
                return
            }
            
            guard let snapshots = snapshots else { completion(nil,error) ; return }
            
            if snapshots.documents.count > 0{
                completion(.requestReletion,nil)
            }else{
                completion(.noRelation,nil)
            }
            
            
        }
        
        
    }
    
    func addUserSharedUsers(user : User , completion : @escaping (Error?) -> Void){
        
        db.collection("users").document(AuthManager.shared.getProfile()!.id).collection("shared_users").addDocument(data: user.toDictionary()) { [weak self] (error) in
            
            if let error = error{
                completion(error)
                return
            }
            
            self?.db.collection("users").document(user.id).collection("shared_users").addDocument(data: AuthManager.shared.getProfile()!.toDictionary(), completion: { (error) in
                if let error = error{
                    completion(error)
                    return
                }
                self?.deleteRequestProfile(user: user) { [weak self] (error) in
                    if let error = error{
                        completion(error)
                        return
                    }
                    
                   
                    completion(nil)
                }
                
                
                
                
            })
            
           
         
            
            
        }
        
        
    }
    
    func deleteRequestProfile(user : User , completion : @escaping (Error?) -> Void){
        db.collection("users").document(user.id).collection("requestProfiles").whereField("id", in: [AuthManager.shared.getProfile()!.id]).getDocuments { [weak self] (snapshot, error) in
            
            if let error = error{
                completion(error)
                return
            }
            let doc = snapshot?.documents[0].documentID
           
            
            self?.db.collection("users").document(user.id).collection("requestProfiles").document(doc!).delete { (error) in
                if let error = error{
                    completion(error)
                    return
                }
               
                
                self?.db.collection("users").document(AuthManager.shared.getProfile()!.id).collection("requests").whereField("id", in: [user.id]).getDocuments { (snapshots, error) in
                    if let error = error{
                        completion(error)
                        return
                    }
                   
                    let doc2 = snapshots?.documents[0].documentID
                    
                    self?.db.collection("users").document(AuthManager.shared.getProfile()!.id).collection("requests").document(doc2!).delete(completion: { (error) in
                        if let error = error{
                            completion(error)
                            return
                        }
                        completion(nil)
                    })
                    
                    
                }
                
                
            }
        }
        
        
    }
    
    func getSharedUsers( completion : @escaping ([User]?,Error?) -> Void){
        
        var users : [User] = [User]()
        
        db.collection("users").document(AuthManager.shared.getProfile()!.id).collection("shared_users").getDocuments { (snapshots, error) in
            if let error = error{
                completion(nil,error)
                return
            }
            
            guard let snapshots = snapshots else { completion(nil,nil) ; return }
            
            for document in snapshots.documents{
                let user = User(data: document.data())
                users.append(user)
            }
            completion(users,nil)
        }
        
    }
    
    func deleteUser(username : String , completion : @escaping (Error?) -> Void){
        
       
        
    }
    
   
    
}
