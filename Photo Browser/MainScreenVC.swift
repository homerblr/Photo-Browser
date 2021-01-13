//
//  ViewController.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 13.01.21.
//

import UIKit

class MainScreenVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellID = "ImageCell"
    var results : [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        Networking.fetchData(PhotosAPITarget.photos, MainData.self, competionHandler: {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photoData):
                self.results.append(contentsOf: photoData.photos.photo)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    print(self.results)
                }
            case .failure(let err):
                print(err)
            }
        })
        
    }


}

extension MainScreenVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        return cell
    }
    
    
}
