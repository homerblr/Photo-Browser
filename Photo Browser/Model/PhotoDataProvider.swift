//
//  PhotoDataProvider.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 27.01.21.
//

import Foundation

protocol PhotoDataProviderProtocol {
    func photo(byID id : String, completion: @escaping (Result<Data?, Error>) -> Void)
    func fetchPhotos(_ completion: @escaping (Result<[PhotoObject], Error>) -> Void)
    var photoModel : [PhotoObject] {get set}
}

class PhotoDataProvider : PhotoDataProviderProtocol {
    
    enum ImageFormat : String {
        case jpg, png
    }
    
    private var loader: PhotoDataSourceProtocol
    private var cache: PhotoDataCacheProtocol
    var photoModel: [PhotoObject]
    var photoObjectArray = [PhotoRepresentable]()
    
    func fetchPhotos(_ completion: @escaping (Result<[PhotoObject], Error>) -> Void) {
        loader.fetchPhotoList { [weak self] (result) in
            switch result {
            case .success(let photoObject):
                self?.photoObjectArray = photoObject
                completion(.success(photoObject))
            case .failure(let error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
    }
    
    func photo(byID id : String, completion: @escaping (Result<Data?, Error>) -> Void) {
        //Read photo by ID from cache if it exists
        cache.readPhoto(withID: id, imageFormat: .jpg) { (result) in
            switch result {
            case .success(let photoData):
                completion(.success(photoData))
            case .failure(let _):
                //If photo doesn't exist, download it by it's ID
                guard let photoObject = photoObjectArray.first(where: {$0.id == id}) else {
                    let error = NSError(domain: "photoDataProvider.photo", code: -1, userInfo:["Reason": "Can't read photo"])
                    completion(.failure(error))
                    return
                }
                loader.downloadPhoto(photo: photoObject, completion: completion)
            }
        }
    }
    init(loader: PhotoDataSource, cache: PhotoDataCache, photoModel: [PhotoObject]) {
        self.loader = loader
        self.cache = cache
        self.photoModel = photoModel
    }
}
