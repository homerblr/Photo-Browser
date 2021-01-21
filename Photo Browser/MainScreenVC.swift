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
    let segueID = "goToDetail"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoDataSource.delegate = self
        photoDataSource.networkingAndSaving()
        collectionView.collectionViewLayout = createLayout()
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
            cell?.setPhoto()
            
        }
    }
}
//MARK: Delegate and Datasource
extension MainScreenVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cellID, for: indexPath) as! CollectionViewCell
        cell.setModel(photo: photoModel[indexPath.row])
        cell.setPhoto()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueID, sender: indexPath)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    //MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID {
            guard let destinationVC = segue.destination as? DetailScreenVC else {return}
            guard let row = (sender as? NSIndexPath)?.row else {return}
            let model = photoModel[row]
            destinationVC.selectedPhoto = model
            destinationVC.photoModel = photoModel
        }
    }
}


//MARK: Layout
extension MainScreenVC {
    func createLayout() -> UICollectionViewLayout {
        
        let leadingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalHeight(1.0)))
        leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let trailingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.25)))
        trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let trailingGroupLeft = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                               heightDimension: .fractionalHeight(1.0)),
            subitem: trailingItem, count: 2)
        let trailingGroupRight = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                               heightDimension: .fractionalHeight(1.0)),
            subitem: trailingItem, count: 2)
        
        let topNestedGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)),
            subitems: [leadingItem, trailingGroupLeft, trailingGroupRight])
        
        
        let bottomNestedGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)),
            subitems: [trailingGroupRight, trailingGroupLeft, leadingItem])
        
        
        let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                   heightDimension: .fractionalHeight(1.0)),
            subitems: [topNestedGroup, bottomNestedGroup])
        nestedGroup.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0)
        let section = NSCollectionLayoutSection(group: nestedGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

