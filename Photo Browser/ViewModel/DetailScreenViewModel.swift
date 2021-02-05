//
//  DetailScreenViewModel.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 5.02.21.
//

import UIKit

class DetailScreenViewModel {
    var photoModel : [PhotoObject] = []
    var photoProvider: PhotoDataProviderProtocol
    
    func configureCell(forIndexPath indexPath: IndexPath, cell: DetailCollectionViewCell) {
        photoModel = photoProvider.photoModel
        let model = photoModel[indexPath.row]
        cell.photoID = photoModel[indexPath.row].id
        let photoID = model.id
        cell.detailPhotoImageView.image = nil
        photoProvider.photo(byID: photoID) {  [photoID] (result) in
            switch result {
            case .success(let photoData):
                guard let photoData = photoData else {return}
                if photoID == cell.photoID {
                    DispatchQueue.main.async {
                        cell.detailPhotoImageView.image = UIImage(data: photoData)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    init(photoProvider: PhotoDataProviderProtocol) {
        self.photoProvider = photoProvider
        
    }
}
