//
//  CellViewModel.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 4.02.21.
//

import UIKit

protocol IMainScreenViewModel {
    func fetchPhotoModel()
    func configureCell(forIndexPath indexPath: IndexPath, cell: CollectionViewCell)
    var boxPhotoModel : Box<[PhotoObject]> {get}
    var photoModel : [PhotoObject] {get}
    var photoProvider: PhotoDataProviderProtocol {get}
    var loadingButtonBox: Box<ButtonState> {get}
}

class MainScreenViewModel: IMainScreenViewModel {
    var photoModel : [PhotoObject] = []
    var photoProvider: PhotoDataProviderProtocol = PhotoDataProvider(loader: PhotoDataSource(), cache: PhotoDataCache())
    
    var boxPhotoModel: Box<[PhotoObject]> = Box([PhotoObject]())
    let loadingButtonBox = Box<ButtonState>(.doingNothing)
    
    func fetchPhotoModel() {
        loadingButtonBox.value = .downloading
        photoProvider.fetchPhotos {
            [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.photoModel = response
                self.boxPhotoModel.value = response
                self.loadingButtonBox.value = .doingNothing
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
