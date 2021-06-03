//
//  DatabaseManager.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 5.05.2021.
//

import Foundation
import Firebase
import Kingfisher

class DatabaseManager{
    
    enum relationshipStatus{
        case noRelation , relation , requestReletion
    }
    
    static let shared : DatabaseManager = DatabaseManager()
    
    private var db : Firestore
    private var storage : Storage
    
    private init(){
        self.db = Firestore.firestore()
        self.storage = Storage.storage()
    }
    
    
    func saveAddress(address : Address , completion : @escaping (Error?) -> Void){
    
        guard let username = AuthManager.getProfile()?.username else { completion(RegisterErrors.connectionProblem) ; return }
            
        let storageReference = storage.reference(withPath: "users").child(username).child("address_photos/\(address.title)")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let uploadTask = storageReference.putData(address.getPhotoData(), metadata: metadata) { [weak self] (metaData, error) in
            if let error = error{
                completion(error)
                return
            }
            
            storageReference.downloadURL { (url, error) in
                if let error = error{
                    completion(error)
                    return
                }
                
                address.setPhotoUrl(path: url!.absoluteString)
                self?.db.collection("users").document(username).collection("addresses").document(address.id).setData(address.convertKeyValueArray()) { (error) in
                    
                    if let _ = error{
                        completion(RegisterErrors.databaseError)
                        return
                    }
                    completion(nil)
                }
            }
            
        
        }
        
        
            
    }
    
    func getAddresses(completion : @escaping (Address? , Error?) -> Void){
        
        guard let username = AuthManager.getProfile()?.username else { completion(nil,RegisterErrors.connectionProblem) ; return }
        
       
        db.collection("users").document(username).collection("addresses").addSnapshotListener {[weak self] (snapshot, error) in
           
            if let error = error {
                completion(nil,error)
                return
            }
            
            if snapshot?.documents.count != 0{
                
                snapshot?.documentChanges.forEach { (difference) in
                    if difference.type == .added{
                        let address = Address(id: difference.document.documentID , keyValue: difference.document.data())
                        self?.getPhotos(address: address, completion: { (image) in
                            address.photo = image
                            completion(address,nil)
                        })
                    }
                    
                    if difference.type == .removed{
                        
                    }
                }
                
                   
            }else{
                completion(nil,nil)
            }
            
            
        
        }
        
    }
    
    private func getPhotos(address : Address , completion : @escaping (UIImage?) -> Void){
        
        let resource = ImageResource(downloadURL: URL(string: address.getPhotoUrl())!)
        
        let cache = ImageCache.default
        cache.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024
        print(cache.diskStorage.directoryURL)
        
        if ImageCache.default.isCached(forKey: address.getPhotoUrl()){
            cache.retrieveImage(forKey: address.getPhotoUrl()) { (result) in
                switch result{
                case .success(let value):
                    completion(UIImage(cgImage: (value.image?.cgImage)!))
                    return
                case .failure:
                    completion(nil)
                    return
                }
            }
        }else{
            
            KingfisherManager.shared.retrieveImage(with: resource) { (result) in
               
                do{
                    let image = try UIImage(cgImage: result.get().image.cgImage!)
                    completion(image)
                }catch{
                    completion(nil)
                    return
                }
                
            }
        }
        
        
    }
    
    func deleteAddress(id : String , completion : @escaping (Error?) -> Void){
        
        db.collection("users").document(AuthManager.getProfile()!.username).collection("addresses").document(id).delete { (error) in
            if let error = error{
                completion(error)
                return
            }
            completion(nil)
        }
        
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
                if user.username == AuthManager.getProfile()?.username{
                    return
                }
                datas.append(user)
            }
            
            completion(datas,nil)
            
        }
        
    }
    
    func sendRequest(username : String , completion : @escaping (Error?) -> Void){
        
        db.collection("users").document(AuthManager.getProfile()!.username).collection("requestProfiles").addDocument(data: ["username" : username])
        
        db.collection("users").document(username).collection("requests").addDocument(data: ["username" : AuthManager.getProfile()!.username]) { (error) in
            if let error = error{
                completion(error)
                return
            }
            
            completion(nil)
            
        }
        
        
    }
    
    func fetchRequest(username : String , completion : @escaping (Error?) -> Void){
        
        var users : [String] = [String]()
        
        db.collection("users").document(AuthManager.getProfile()!.username).collection("requests").addSnapshotListener { (snapshots, error) in
            if let error = error{
                completion(error)
                return
            }
            
            guard let documents = snapshots?.documents else {return}
            
            snapshots?.documentChanges.forEach({ (documentChange) in
                
                if documentChange.type == .added{
                    Link.sharedLinks.links.append((documentChange.document.data()["username"] as! String))
                }
                
                if documentChange.type == .removed{
                    Link.sharedLinks.links.remove(at: Int(documentChange.oldIndex))
                }
                completion(nil)
            })
            
        
    }
    }
    
    func compareRequest(username : String , completion : @escaping (relationshipStatus?,Error?) -> Void){
        
        db.collection("users").document(AuthManager.getProfile()!.username).collection("shared_users").whereField("username", isGreaterThanOrEqualTo: username).whereField("username", isLessThanOrEqualTo: username+"\u{f8ff}").getDocuments { (snapshots, error) in
            if let error = error{
                completion(nil,error)
                return
            }
            completion(.relation,nil)
            return
        }
        
        
        db.collection("users").document(AuthManager.getProfile()!.username).collection("requestProfiles").whereField("username", isGreaterThanOrEqualTo: username).whereField("username", isLessThanOrEqualTo: username+"\u{f8ff}").getDocuments { (snapshots, error) in
            
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
    
    func addUserSharedUsers(username : String , completion : @escaping (Error?) -> Void){
        
        db.collection("users").document(AuthManager.getProfile()!.username).collection("shared_users").addDocument(data: ["username" : username]) { [weak self] (error) in
            
            if let error = error{
                completion(error)
                return
            }
            
            self?.db.collection("users").document(username).collection("shared_users").addDocument(data: ["username" : AuthManager.getProfile()!.username], completion: { (error) in
                if let error = error{
                    completion(error)
                    return
                }
                self?.deleteRequestProfile(username: username) { [weak self] (error) in
                    if let error = error{
                        completion(error)
                        return
                    }
                    
                   
                    completion(nil)
                }
                
                
                
                
            })
            
           
         
            
            
        }
        
        
    }
    
    func deleteRequestProfile(username : String , completion : @escaping (Error?) -> Void){
        db.collection("users").document(username).collection("requestProfiles").whereField("username", in: [AuthManager.getProfile()!.username]).getDocuments { [weak self] (snapshot, error) in
            
            if let error = error{
                completion(error)
                return
            }
            let doc = snapshot?.documents[0].documentID
           
            
            self?.db.collection("users").document(username).collection("requestProfiles").document(doc!).delete { (error) in
                if let error = error{
                    completion(error)
                    return
                }
               
                
                self?.db.collection("users").document(AuthManager.getProfile()!.username).collection("requests").whereField("username", in: [username]).getDocuments { (snapshots, error) in
                    if let error = error{
                        completion(error)
                        return
                    }
                   
                    let doc2 = snapshots?.documents[0].documentID
                    
                    self?.db.collection("users").document(AuthManager.getProfile()!.username).collection("requests").document(doc2!).delete(completion: { (error) in
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
    
    func getSharedUsers( completion : @escaping ([String]?,Error?) -> Void){
        
        var users : [String] = [String]()
        
        db.collection("users").document(AuthManager.getProfile()!.username).collection("shared_users").getDocuments { (snapshots, error) in
            if let error = error{
                completion(nil,error)
                return
            }
            
            guard let snapshots = snapshots else { completion(nil,nil) ; return }
            
            for document in snapshots.documents{
                let user = document.data()["username"] as! String
                users.append(user)
            }
            completion(users,nil)
        }
        
    }
    
    func deleteSharedUser(username : String , completion : @escaping (Error?) -> Void){
        
       
        
    }
    
    
}
