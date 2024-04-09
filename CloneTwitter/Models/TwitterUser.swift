//
//  TwitterUser.swift
//  CloneTwitter
//
//  Created by Phạm Hồng Sơn on 22/02/2024.
//
import Firebase
import Foundation
struct TwitterUser:Codable {
    let id: String?
    var displayName:String? = ""
    var username:String? = ""
    var followerCount:Int = 0
    var followingCount:Int = 0
    var createdOn:Date = Date()
    var bio:String? = ""
    var avatarPath:String? = ""
    var isUserOnboarded:Bool = false
    
    init(from user: User) {
        self.id = user.uid
    }
    init() {
        id = ""
    }
}
