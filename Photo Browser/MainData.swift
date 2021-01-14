//
//  Model.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 13.01.21.
//

import Foundation

struct MainData: Codable {
    let photos: Photos
    let stat: String
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage: Int
    let total: Int
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
    
}

extension Photo {
//    https://live.staticflickr.com/{server-id}/{id}_{secret}_{size-suffix}.jpg
    var fullSizeURL: URL? {
        guard var urlComponents = URLComponents(string: "https://live.staticflickr.com") else { return nil }
        urlComponents.path = "\(self.server)/\(self.id)_\(self.secret)_w.jpg"
        return urlComponents.url
    }
}
