//
//  Networking.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 13.01.21.
//

import Foundation

struct Networking {
    
    static func fetchData<T>(_ request: APITarget, _ modelType: T.Type, competionHandler: @escaping (Result <T, Error>) -> Void) where T : Codable {
        
        
        var urlComponents = URLComponents()
        urlComponents.scheme = request.scheme
        urlComponents.host = request.host
        urlComponents.path = request.path
        urlComponents.queryItems = request.queryItems
        
        
        guard let stringURL = urlComponents.url?.absoluteString, let url = URL(string: stringURL) else {return}
        
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error)
            in
            guard let data = data, let response = response else {return}
        
            do {
                let jsonData = try JSONDecoder().decode(T.self, from: data)
                competionHandler(.success(jsonData))
            } catch let jsonError {
                competionHandler(.failure(jsonError))
            }
        }.resume()
        
    }
    
//    static func fetchPhoto<T>(url : URL, _ modelType: T.Type, competionHandler: @escaping (Result <T, Error>) -> Void) where T : Codable {
//        let session = URLSession.shared
//        session.dataTask(with: url) { (data, response, error)
//            in
//            guard let data = data, let response = response else {return}
//        
//            do {
//                let photoData = try JSONDecoder().decode(T.self, from: data)
//                competionHandler(.success(photoData))
//            } catch let jsonError {
//                competionHandler(.failure(jsonError))
//            }
//            
//        }.resume()
//    }
    
}
