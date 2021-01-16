//
//  ViewController.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 13.01.21.
//

import UIKit

class MainScreenVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var photoModel : [PhotoObject] = []
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        photoDataSource.delegate = self
        photoDataSource.networkingAndSaving()
    }
}

extension MainScreenVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cellID, for: indexPath) as! CollectionViewCell
        cell.setModel(photo: photoModel[indexPath.row])
        return cell
    }
}

extension MainScreenVC: PhotosDelegate {
    func didFetchPhotos(_ photos: [PhotoObject]) {
        photoModel = photos
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    func didDownloadPhotoWithID(_ id: String) {
        DispatchQueue.main.async {
            let cell = self.collectionView.visibleCells
                .compactMap{$0 as? CollectionViewCell}
                .first(where: {$0.photoObject?.id == id})
            cell?.searchSavedAndSetImage()
        }
    }
}
