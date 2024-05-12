//
//  FeedModel.swift
//  MusicMaxx
//
//  Created by Smart Castle M1A2009 on 14.04.2024.
//

import Foundation

struct Feeds: Decodable {
    let feed: FeedModel
    
    enum CodingKeys: String, CodingKey {
        case feed
    }
}

struct FeedModel: Decodable {
    let title: String
    
    let results: [ResultModel]
    
    enum CodingKeys: String, CodingKey {
        case title, results
    }
}

struct ResultModel: Decodable {
    let artistName: String
    let id: String
    let name: String
    let artworkUrl100: String
    
    enum CodingKeys: String, CodingKey {
        case artistName, id, name, artworkUrl100
    }
}

struct SearchResult: Decodable {
//    let result: SResult
    let tracks: Tracks
    
//    struct SResult: Decodable {
//        
//    }
    
    enum CodingKeys: String, CodingKey {
        case tracks
    }
}

struct Tracks: Decodable {
    let items: [SearchResultModel]
}

struct SearchResultModel: Decodable {
    let title: String?
    let artworkUrl: String?
    let id: Int?
    let user: SearchResultUser?
    
//    var hasLiked: Bool? = false
    
}

struct SearchResultUser: Decodable {
    let name: String?
}

struct PlayMusicResult: Decodable {
    let audio: [PlayMusicAudio]?
    let name: String?
}

struct PlayMusicAudio: Decodable {
    let type: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case type = "extension"
        case url
    }
    
}

struct SavedMusicModel: Codable {
    let title: String
    let playURL: URL
    let avatarUrl: String?
    let artistName: String
}
