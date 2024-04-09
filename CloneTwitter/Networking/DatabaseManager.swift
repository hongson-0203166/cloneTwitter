//
//  DatabaseManager.swift
//  CloneTwitter
//
//  Created by Phạm Hồng Sơn on 22/02/2024.
//

import Foundation
import Firebase
import FirebaseFirestore


class DatabaseManager{
    static let shared = DatabaseManager()
    let db = Firestore.firestore()
    let usersPath :String = "users"
    let tweetsPath:String = "tweets"
    
    func collectionUsers(add user:User,completion:@escaping (Result<Void,Error>) ->Void){
        let twitterUser = TwitterUser(from: user)
        guard let userId = twitterUser.id else {
                completion(.failure(MyError.invalidUserId))
                return
            }
        do{
            try db.collection(usersPath).document(userId).setData(from: twitterUser){ error in
                if let error = error{
                    completion(.failure(error))
                }
                print("Thêm người dùng vào firestore thành công")
            }
        }catch let error as NSError{
            print("Không thể thêm người dùng \(error.localizedDescription)")
            completion(.failure(MyError.dontAddUser))
        }
    }
    
    func collectionUsers(id :String,completion:@escaping (Result<TwitterUser,Error>)->Void){
        db.collection(usersPath).document(id).getDocument { data, error in
            if let data = data {
                do{
                    try  completion(.success(data.data(as: TwitterUser.self)))
                }catch let err as NSError{
                    print(err)
                }
               
            }else if let error = error {
                completion(.failure(error))
            }
        }
    }
    func collectionUsers(updateFields:[String:Any],id:String,completion:@escaping (Result<Void,Error>)->Void){
        db.collection(usersPath).document(id).updateData(updateFields) { err in
            if let error = err{
                completion(.failure(error))
            }
            
            print("update thong tin nguoi dung thanh con thành công")
        }
    }
    
    
    
    //MARK: tweetContent
    func collectionTweets(tweet:Tweet,completion:@escaping (Result<Void,Error>) ->Void){
        do{
            try db.collection(tweetsPath).document(tweet.id).setData(from: tweet){err in
                if let err = err{
                    completion(.failure(err))
                }
            }
        }catch let err as NSError{
            print("Không thể thêm người dùng \(err.localizedDescription)")
            completion(.failure(MyError.dontaddtweet))
        }
    }
    
    func collectionTweets(get forUserID:String,completion:@escaping (Result<[Tweet],Error>) ->Void){
        db.collection(tweetsPath).whereField("authorID", isEqualTo: forUserID).getDocuments { querySnapshot, error in
            if let error = error {
                        completion(.failure(error))
                        return
                    }
            guard let documents = querySnapshot?.documents else {
                       completion(.success([])) // Trả về một mảng rỗng nếu không có tài liệu
                       return
                   }
            // Sử dụng map để lặp qua danh sách documents và chuyển đổi chúng thành một mảng các Tweet
                    let tweets = documents.compactMap { document -> Tweet? in
                        do {
                            // Sử dụng data(as:) để parse từ DocumentSnapshot thành một đối tượng Tweet
                            let tweet = try document.data(as: Tweet.self)
                            return tweet
                        } catch {
                            print("Error parsing document: \(error)")
                            return nil
                        }
                    }
                    
                    completion(.success(tweets))
            }
        }

    
    //MARK: Search users
    func collectionUsers(search query: String, completion: @escaping (Result<[TwitterUser], Error>)-> Void){
        db.collection(usersPath).whereField("username", isEqualTo: query).getDocuments {querySnapshot, error in
            if let error = error {
                        completion(.failure(error))
                        return
                    }
            guard let documents = querySnapshot?.documents else {
                       completion(.success([])) // Trả về một mảng rỗng nếu không có tài liệu
                       return
                   }
            // Sử dụng map để lặp qua danh sách documents và chuyển đổi chúng thành một mảng các Tweet
                    let users = documents.compactMap { document -> TwitterUser? in
                        do {
                            // Sử dụng data(as:) để parse từ DocumentSnapshot thành một đối tượng Tweet
                            let user = try document.data(as: TwitterUser.self)
                            return user
                        } catch {
                            print("Error parsing document: \(error)")
                            return nil
                        }
                    }
                    
                    completion(.success(users))
        }
        
    }
    
    func collectionAllTweets(completion:@escaping (Result<[Tweet],Error>)->Void){
        db.collection(tweetsPath).getDocuments { querySnapshot, error in
            if let error = error {
                        completion(.failure(error))
                        return
                    }
            guard let documents = querySnapshot?.documents else {
                       completion(.success([])) // Trả về một mảng rỗng nếu không có tài liệu
                       return
                   }
            // Sử dụng map để lặp qua danh sách documents và chuyển đổi chúng thành một mảng các Tweet
                    let tweet = documents.compactMap { document -> Tweet? in
                        do {
                            // Sử dụng data(as:) để parse từ DocumentSnapshot thành một đối tượng Tweet
                            let tweet = try document.data(as: Tweet.self)
                            return tweet
                        } catch {
                            print("Error parsing document: \(error)")
                            return nil
                        }
                    }
                    
                    completion(.success(tweet))
            
        }
    }
    enum MyError:Error{
        case invalidUserId
        case dontAddUser
        case dontUpLoadImage
        case dontaddtweet
    }
}
