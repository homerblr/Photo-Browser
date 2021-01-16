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
    var directoryURL : URL? = nil
    
    func networkingAndSaving() {
        if !FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).isEmpty {
            directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
        Networking.fetchData(PhotosAPITarget.photos, MainData.self, competionHandler: {
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
                                do {
                                    if let directoryURL = self.directoryURL {
                                        let fileURL = URL(fileURLWithPath: photo.id, relativeTo: directoryURL).appendingPathExtension("jpg")
                                        do {
                                            try actualPhoto.write(to: fileURL)
                                            self.delegate?.didDownloadPhotoWithID(photo.id)
                                        } catch {
                                            print(error.localizedDescription)
                                        }
                                    }
                                }
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


