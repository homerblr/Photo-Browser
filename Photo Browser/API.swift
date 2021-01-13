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
        return "www.flickr.com"
    }
    var queryItems: [URLQueryItem]? {
        return [URLQueryItem(name: "api_key", value: "8c5d03d43a4e14e8b80aafc5a1120f4b")]
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
        case .photos: return "/services/rest/"
        }
       
    }
    
    var method: Method {
        switch self {
        case .photos: return .get
        }
    }
    
    var queryItems: [URLQueryItem]? {
        var queryItem : [URLQueryItem] = [URLQueryItem(name: "method", value: "flickr.photos.getRecent"), URLQueryItem(name: "api_key", value: "8c5d03d43a4e14e8b80aafc5a1120f4b"), URLQueryItem(name: "format", value: "json"), URLQueryItem(name: "nojsoncallback", value: "1")]
      
        return queryItem
    }
    
}

enum Method: String {
    case get
    case post
}

//https://www.flickr.com/services/rest/%3Fmethod=flickr.photos.getRecent?api_key=8c5d03d43a4e14e8b80aafc5a1120f4b&format=json&nojsoncallback=1
