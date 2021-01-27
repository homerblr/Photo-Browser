//
//  API.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 13.01.21.
//

import Foundation
//вынести в xconfig

struct AppConfiguration {
    var baseURL : URL? {
        return URL(string: "https://flickr.com/services/rest/")
    }
}

protocol APITarget {
    var path : String {get}
    var method : Method {get}
    var host : String {get}
    var queryItems: [URLQueryItem]? {get}
    var scheme : String? {get}
}

extension APITarget {
    var host : String {
        if let host = ConfigRepository.getHost() {
            return host
        }
    }

    var scheme : String? {
        return "https"
    }
}

enum PhotosAPITarget {
    case photos
}

extension PhotosAPITarget: APITarget {
    var path: String {
        switch self {
        case .photos:
            if let path = ConfigRepository.getPath() {
                return path
            }
        }
       
    }
    
    var method: Method {
        switch self {
        case .photos: return .get
            //rawvalue, избавиться, передаю снаружи
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


