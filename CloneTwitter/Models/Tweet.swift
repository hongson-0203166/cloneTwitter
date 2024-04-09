//
//  Tweet.swift
//  CloneTwitter
//
//  Created by Phạm Hồng Sơn on 19/03/2024.
//

import Foundation

struct Tweet:Codable{
    let id = UUID().uuidString
    let author:TwitterUser
    let authorID:String
    let tweetContent:String
    var likesCount:Int
    var likes:[String]
    let isReply:Bool
    let parentReference:String?
}
