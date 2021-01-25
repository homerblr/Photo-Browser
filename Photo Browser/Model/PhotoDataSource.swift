//
//  PhotoDelegate.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 15.01.21.
//

import Foundation

protocol PhotosDelegate: class  {
    func didFetchPhotos(_ photos: [PhotoObject])
    func didDownloadPhotoWithID(_ id: String)
}

class PhotoDataSource {
    weak var delegate: PhotosDelegate?
    var photoDataService = PhotoDataService()
    
    
    func networkingAndSaving() {
        Networking.fetchData(PhotosAPITarget.photos, FetchPhotoResponse.self, competionHandler: {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let jsonData):
                self.delegate?.didFetchPhotos(jsonData.photos.photo)
                jsonData.photos.photo.enumerated()
                    .forEach { index, photo in
                        guard let url = photo.thumbURL else { return }
                        Networking.downloadPhoto(url: url, competionHandler: {
                            [weak self] result in
                            guard let self = self else { return }
                            switch result {
                            case .success(let actualPhoto):
                                self.photoDataService.savePhoto(photoID: photo.id, data: actualPhoto)
                                self.delegate?.didDownloadPhotoWithID(photo.id)
                            case .failure(let err):
                                print("Error downloading photo: \(err)")
                            }
                        })
                    }
            case .failure(let err):
                print("Error downloading JSON file \(err)")
            }
        })
    }
        
}


