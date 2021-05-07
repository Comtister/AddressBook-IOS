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
                self?.db.collection("users").document(username).collection("addresses").document(UUID().uuidString).setData(address.convertKeyValueArray()) { (error) in
                    
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
            print("kaç kez çalıştı")
            if let error = error {
                completion(nil,error)
                return
            }
            
            if let snapshot = snapshot{
                    
                for document in snapshot.documents{
                    print("çalıştı aaa")
                    print(document.data())
                    
                    let address = Address(keyValue: document.data())
                    self?.getPhotos(address: address, completion: { (image) in
                        address.photo = image
                        completion(address,nil)
                    })
                }
                
                
            }
            
            
        
        }
        
    }
    
    private func getPhotos(address : Address , completion : @escaping (UIImage?) -> Void){
        
        let resource = ImageResource(downloadURL: URL(string: address.getPhotoUrl())!)
        
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
