//
//  UserObject.swift
//  CodeTask17
//
//  Created by lohsts on 2019/6/3.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

struct UserObject: Codable {
    
    let totalAccount: Int
    
    let incompleteResults: Bool
    
    let items: UserItem
}

struct UserItem: Codable {
    
    let login: String
    
    let id: Int
    
    let nodeId: String
    
    let avatarUrl: String
    
    let gravatarId: String
    
    let url: String
    
    let htmlUrl: String
    
    let followersUrl: String
    
    let subscriptionsUrl: String
    
    let organizationsUrl: String
    
    let reposUrl: String
    
    let receivedEventsUrl: String
    
    let type: String
    
    let score: Double
    
    enum CodingKeys: String, CodingKey {
        
        case login
        
        case id
        
        case nodeId = "node_id"
        
        case avatarUrl = "avatar_url"
        
        case gravatarId = "gravatar_id"
        
        case url
        
        case htmlUrl = "html_url"
        
        case followersUrl = "followers_url"
        
        case subscriptionsUrl = "subscriptions_url"
        
        case organizationsUrl = "organizations_url"
        
        case reposUrl = "repos_url"
        
        case receivedEventsUrl = "received_events_url"
        
        case type
        
        case score
    }
}
