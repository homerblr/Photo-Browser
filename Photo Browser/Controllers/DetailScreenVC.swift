//
//  DetailScreenVC.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 19.01.21.
//

import UIKit

class DetailScreenVC: UICollectionViewController {
    var selectedPhotoID : String?
    var viewModel : DetailScreenViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let viewModel = viewModel else {return}
        if let selectedPhoto = selectedPhotoID {
            guard let selectedPhotoIndex = viewModel.photoProvider.photoModel
                    .firstIndex(where: {$0.id == selectedPhoto}) else {return}
            collectionView.scrollToItem(at: IndexPath(item: selectedPhotoIndex, section: 0), at: .centeredHorizontally, animated: true)
            collectionView.isPagingEnabled = true
        }
    }
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photoProvider.photoModel.count ?? 0
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.cellID, for: indexPath) as! DetailCollectionViewCell
        viewModel?.configureCell(forIndexPath: indexPath, cell: cell)
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
