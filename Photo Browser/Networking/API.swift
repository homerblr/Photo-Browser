//
//  API.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 13.01.21.
//

import Foundation

protocol APITarget {
    var path : String {get}
    var method : Method {get}
    var host : String {get}
    var queryItems: [URLQueryItem]? {get}
    var scheme : String? {get}
}

extension APITarget {
    var host : String {
        return ConfigRepository.getHost() ?? "No host at ConfigRepo()"
    }

    var scheme : String? {
        return "https"
    }
}

enum PhotosAPITarget {
    case getPhotos
}

extension PhotosAPITarget: APITarget {
    var path: String {
        switch self {
        case .getPhotos:
            return ConfigRepository.getPath() ?? "No path at ConfigRepo"
        }
    }
    
    var method: Method {
        switch self {
        case .getPhotos: return .get
        }
    }
    
    var queryItems: [URLQueryItem]? {
        let queryItem : [URLQueryItem] = [URLQueryItem(name: "method", value: "flickr.photos.getRecent"), URLQueryItem(name: "api_key", value: ConfigRepository.getAPIKey()), URLQueryItem(name: "format", value: "json"), URLQueryItem(name: "nojsoncallback", value: "1")]
        return queryItem
    }
    
}

enum Method: String {
    case get
    case post
}


