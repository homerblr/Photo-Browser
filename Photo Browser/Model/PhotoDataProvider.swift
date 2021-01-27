//
//  PhotoDataProvider.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 27.01.21.
//

import Foundation


class PhotoDataProvider : PhotoDataProviderProtocol {
    var loader: PhotoDataSourceProtocol
    var cache: PhotoDataCacheProtocol
    
    
    func fetchPhotos(_ completion: Result<[PhotoObject], Error>) {
        loader.fetchPhotos { (result) in
            switch result {
            case .success(let photoObject):
                photoObject.enumerated()
                .forEach({ [weak self] index, photo in
                    guard let self = self else {return}
                    self.loader.downloadPhoto(photoObject: photo) {
                        (result) in
                        switch result {
                        case .success(let actualPhoto):
                            print(actualPhoto)
                        case .failure(let error):
                            print(error)
                        }
                    }
                })
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func photo(byID id: String, completion: Result<Data?, Error>) {
        
    }
    
    private init() {
        self.loader = PhotoDataSource()
        self.cache = PhotoDataCache()
    }
    
}
