//
//  AddressManager.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 10.06.2021.
//

import Foundation
import Firebase
import Kingfisher

class AddressManager{
   
    static let shared : AddressManager = AddressManager()
    
    private var db : Firestore
    private var storage : Storage
   
    private init(){
        self.db = Firestore.firestore()
        self.storage = Storage.storage()
    }
    
    func saveAddress(address : Address , completion : @escaping (Error?) -> Void){
        
        let storageReference = storage.reference(withPath: "users").child(AuthManager.shared.getProfile()!.id).child("address_photos/\(address.title)")
        
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
                self?.db.collection("users").document(AuthManager.shared.getProfile()!.id).collection("addresses").document(address.id).setData(address.convertKeyValueArray()) { (error) in
                    
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
        
       
        db.collection("users").document(AuthManager.shared.getProfile()!.id).collection("addresses").addSnapshotListener {[weak self] (snapshot, error) in
           
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
    
    func shareAddress(address : Address , toUser : User , completion : @escaping (Error?) -> Void){
        var owner = AuthManager.shared.getProfile()!.username
        address.owner = owner
        db.collection("users").document(toUser.id).collection("addresses").addDocument(data: address.convertKeyValueArray()) { (error) in
            if let error = error{
                completion(error)
                return
            }
            completion(nil)
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
        
        db.collection("users").document(AuthManager.shared.getProfile()!.id).collection("addresses").document(id).delete { (error) in
            if let error = error{
                completion(error)
                return
            }
            completion(nil)
        }
        
    }
    
}
