//
//  DetailScreenVC.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 19.01.21.
//

import UIKit

class DetailScreenVC: UICollectionViewController {
    var photoModel : [PhotoObject] = []
    var selectedPhotoID : String?
    var photoDataProvider : PhotoDataProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let photoDataProvider = photoDataProvider else {return}
        photoModel = photoDataProvider.photoModel
        if let selectedPhoto = selectedPhotoID {
            guard let selectedPhotoIndex = photoModel
                    .firstIndex(where: {$0.id == selectedPhoto}) else {return}
            collectionView.scrollToItem(at: IndexPath(item: selectedPhotoIndex, section: 0), at: .centeredHorizontally, animated: true)
            collectionView.isPagingEnabled = true
        }
    }
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModel.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.cellID, for: indexPath) as! DetailCollectionViewCell
        cell.photoID = photoModel[indexPath.row].id
        let photoID = photoModel[indexPath.row].id
        if let photoDataProvider = photoDataProvider {
        photoDataProvider.photo(byID: photoID) {  [photoID] (result) in
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
            }}
        }
        cell.updateImageViewLayer()
        return cell
    }
}

//MARK: Layout
extension DetailScreenVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameSize = collectionView.frame.size
        return CGSize(width: frameSize.width, height: frameSize.height)
}
}
