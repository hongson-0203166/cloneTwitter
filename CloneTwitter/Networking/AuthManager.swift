//
//  AuthManager.swift
//  CloneTwitter
//
//  Created by Phạm Hồng Sơn on 20/02/2024.
//

import Foundation
import Firebase
import FirebaseAuth
class AuthManager{
    static let shared = AuthManager()
    func registerUser(email:String,password:String,completion:@escaping (Result<User,Error>)->Void){
        Auth.auth().createUser(withEmail: email, password: password){Authresult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = Authresult?.user {
                completion(.success(user))
         }
        }
    }
    
    func loginUser(email:String,password:String,completion:@escaping (Result<User,Error>)->Void){
        Auth.auth().signIn(withEmail: email, password: password) { Authresult, error in
            if let error = error {
                completion(.failure(error))
            }else if let user = Authresult?.user {
                completion(.success(user))
            }
        }
        
    }
}
