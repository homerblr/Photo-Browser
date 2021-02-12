//
//  Model.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 13.01.21.
//

import Foundation

struct FetchPhotoResponse: Codable {
    let photos: Photos
    let stat: String
}

struct Photos: Codable {
    let page, pages, perpage: Int
    let total: Int
    let photo: [PhotoObject]
}


struct PhotoObject: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let isPublic, isFriend, isFamily: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case secret
        case server
        case farm
        case title
        case isPublic = "ispublic"
        case isFriend = "isfriend"
        case isFamily = "isfamily"
    }

    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.owner = try container.decode(String.self, forKey: .owner)
        self.secret = try container.decode(String.self, forKey: .secret)
        self.server = try container.decode(String.self, forKey: .server)
        self.farm = try container.decode(Int.self, forKey: .farm)
        self.title = (try? container.decode(String.self, forKey: .title)) ?? ""
        self.isPublic = try container.decode(Int.self, forKey: .isPublic)
        self.isFriend = try container.decode(Int.self, forKey: .isFriend)
        self.isFamily = try container.decode(Int.self, forKey: .isFamily)
    }
    
}


protocol PhotoRepresentable {
    var id : String {get}
    var secret : String {get}
    var server : String {get}
    var thumbURL : URL? {get}
}

extension PhotoObject: PhotoRepresentable {
    var thumbURL: URL? {
        guard var urlComponents = URLComponents(string: "https://live.staticflickr.com") else {return nil}
        urlComponents.path = "/\(self.server)/\(self.id)_\(self.secret)_w.jpg"
        return urlComponents.url
    }
}
