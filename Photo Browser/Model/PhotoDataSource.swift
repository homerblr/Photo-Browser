//
//  PhotoDelegate.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 15.01.21.
//

import Foundation

protocol PhotoDataSourceProtocol {
    func fetchPhotoList(_ completion: @escaping (Result<[PhotoObject], Error>) -> Void)
    func downloadPhoto(photo: PhotoRepresentable, completion: @escaping (Result<Data?, Error>) -> Void)
}

class PhotoDataSource: PhotoDataSourceProtocol {

    func fetchPhotoList(_ completion: @escaping (Result<[PhotoObject], Error>) -> Void) {
        Networking.fetchData(PhotosAPITarget.photos, FetchPhotoResponse.self, competionHandler: {
                        result in
                        switch result {
                        case .success(let jsonData):
                        completion(.success(jsonData.photos.photo))
                        case .failure(let err):
                        let error = NSError(domain: "json.download", code: -1, userInfo:["Reason": "Unable to download photo at fetchPhotos method"])
                            completion(.failure(error))
                        print(err.localizedDescription)}})
    }

    func downloadPhoto(photo: PhotoRepresentable, completion: @escaping (Result<Data?, Error>) -> Void) {
                            guard let url = photo.thumbURL else {
                                let error = NSError(domain: "PhotoDataSource.downloadPhoto", code: -1, userInfo:["Reason": "URL is nil"])
                                completion(.failure(error))
                                return
                            }
                        Networking.downloadPhoto(url: url, competionHandler: {
                            result in
                            switch result {
                            case .success(let data):
                                completion(.success(data))
                            case .failure(let err):
                            let error = NSError(domain: "json.download", code: -1, userInfo:["Reason": "Unable to download photo at downloadPhoto method"])
                            completion(.failure(error))
                            print("Error downloading photo: \(err)")}})
    }
}
