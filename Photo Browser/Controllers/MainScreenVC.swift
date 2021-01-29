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
    let segueID = "goToDetail"
    lazy var photoProvider: PhotoDataProviderProtocol = PhotoDataProvider(loader: PhotoDataSource(), cache: PhotoDataCache(), photoModel: photoModel)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = createLayout()
        photoProvider.fetchPhotos {
            [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.photoModel = model
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
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
        cell.photoID = photoModel[indexPath.row].id
        let photoID = photoModel[indexPath.row].id
        DispatchQueue.main.async {
            cell.photoImageView.image = nil
        }
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
        cell.updateImageView()
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
            let selectedPhotoID = photoModel[row].id
            destinationVC.selectedPhotoID = selectedPhotoID
            photoProvider.photoModel = photoModel
            destinationVC.photoDataProvider = photoProvider as? PhotoDataProvider
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

