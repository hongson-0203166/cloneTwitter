//
//  StorageManager.swift
//  CloneTwitter
//
//  Created by Phạm Hồng Sơn on 25/02/2024.
//

import Foundation
import FirebaseStorage
class StorageManager{
    enum MyError:Error{
        case invalidUserId
        case dontAddUser
        case dontUpLoadAvt
        case dontDownloadAvt
    }
    static let shared = StorageManager()
    let storage = Storage.storage()
   
    func uploadProfilePhoto(with randomID:String,image:Data,metaData:StorageMetadata, completion: @escaping (StorageMetadata?,Error?)-> Void){
       
        storage.reference().child("images/\(randomID).jpg").putData(image, metadata: metaData) { data, err in
            guard err == nil else {
                completion(nil, err)
                return
            }
            guard let data = data else {
                completion(nil,err)
                return
            }
            completion(data,nil)
        }
    }
    
    func getDownload(path:String?,completion: @escaping (URL?,Error?)->Void){
        guard let path = path else{
            return
        }
        storage.reference(withPath: path).downloadURL { url, err in
            guard err == nil else{
                completion(nil,err)
                return
            }
            guard let url = url else{
                completion(nil,err)
                return
            }
            completion(url, nil)
        }
    }
}
