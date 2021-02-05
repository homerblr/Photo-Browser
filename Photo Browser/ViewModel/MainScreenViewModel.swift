//
//  CellViewModel.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 4.02.21.
//

import UIKit

class MainScreenViewModel {
    
    var photoModel : [PhotoObject] = []
    var photoProvider: PhotoDataProviderProtocol = PhotoDataProvider(loader: PhotoDataSource(), cache: PhotoDataCache())
    
    func fetchPhotoModel(completion: @escaping () -> ()) {
        photoProvider.fetchPhotos {
            [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success( _):
                self.photoModel = self.photoProvider.photoModel
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func configureCell(forIndexPath indexPath: IndexPath, cell: CollectionViewCell) {
        let model = photoModel[indexPath.row]
        cell.photoID = photoModel[indexPath.row].id
        let photoID = model.id
        cell.photoImageView.image = nil
        photoProvider.photo(byID: photoID) {  [photoID] (result) in
            switch result {
            case .success(let photoData):
                guard let photoData = photoData else {return}
                if photoID == cell.photoID {
                    DispatchQueue.main.async {
                        cell.photoImageView.image = UIImage(data: photoData)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
