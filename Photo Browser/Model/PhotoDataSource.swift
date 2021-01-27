//
//  PhotoDelegate.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 15.01.21.
//

import Foundation


protocol PhotoDataProviderProtocol {
    //Передать через свойства класса, приватные поля
    var loader: PhotoDataSourceProtocol {get}
    var cache: PhotoDataCacheProtocol {get}
    func photo(byID id : String, completion: Result<Data?, Error>)
    func fetchPhotos(_ completion: Result<[PhotoObject], Error>)
    //добавить fetchPhotos
}

protocol PhotoDataCacheProtocol {
    func photo(byID id : String, completion: Result<Data?, Error>)
    func save(photoByID id: String, completion: Result<Data?, Error>)
}

protocol PhotoDataSourceProtocol {
    func fetchPhotos(_ completion: @escaping (Result<[PhotoObject], Error>) -> Void)
    func downloadPhoto(photoObject: PhotoObject, completion: @escaping (Result<Data?, Error>) -> Void)
}



protocol PhotosDelegate: class  {
    //избавляюсь
    func didFetchPhotos(_ photos: [PhotoObject])
    func didDownloadPhotoWithID(_ id: String)
}

class PhotoDataSource: PhotoDataSourceProtocol {

    func fetchPhotos(_ completion: @escaping (Result<[PhotoObject], Error>) -> Void) {
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

    func downloadPhoto(photoObject: PhotoObject, completion: @escaping (Result<Data?, Error>) -> Void) {
                        guard let url = photoObject.thumbURL else { return }
                        Networking.downloadPhoto(url: url, competionHandler: {
                            result in
                            switch result {
                            case .success(let actualPhoto):
                                completion(.success(actualPhoto))
                            case .failure(let err):
                            let error = NSError(domain: "json.download", code: -1, userInfo:["Reason": "Unable to download photo at downloadPhoto method"])
                            completion(.failure(error))
                            print("Error downloading photo: \(err)")}})
    }
                        
}
    
    

