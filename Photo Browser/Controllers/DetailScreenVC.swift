//
//  DetailScreenVC.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 19.01.21.
//

import UIKit

class DetailScreenVC: UICollectionViewController {
    var photoModel : [PhotoObject] = []
    var selectedPhoto : PhotoObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedPhoto = selectedPhoto {
            guard let index = photoModel
                    .firstIndex(where: {$0.id == selectedPhoto.id}) else {return}
            collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            collectionView.isPagingEnabled = true
        }
   
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModel.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.cellID, for: indexPath) as! DetailCollectionViewCell
        cell.setModel(photo: photoModel[indexPath.row])
        cell.updatePhoto()
      
        return cell
    }

}

extension DetailScreenVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameSize = collectionView.frame.size
        return CGSize(width: frameSize.width, height: frameSize.height)
}
}
