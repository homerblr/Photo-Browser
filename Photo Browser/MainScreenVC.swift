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
    var photosURL : [URL?] = []
    var compactMap : [URL] = []
    
    var directoryURL : URL?
    
    let notificationName = Notification.Name("download complete")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).isEmpty {
            directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
        
        Networking.fetchData(PhotosAPITarget.photos, MainData.self, competionHandler: {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photoData):
                
                self.results.append(contentsOf: photoData.photos.photo)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
                photoData.photos.photo.forEach { photo in
                    guard let url = photo.thumbURL else { return }
                    Networking.downloadPhoto(url: url, competionHandler: {
                        [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let actualPhoto):
                            do {
                                if let directoryURL = self.directoryURL {
                                    let fileURL = URL(fileURLWithPath: photo.id, relativeTo: directoryURL).appendingPathExtension("jpg")
                                    do {
                                        try actualPhoto.write(to: fileURL)
                                        
                                        NotificationCenter.default.post(name: self.notificationName, object: nil)
                                    } catch {
                                        print(error.localizedDescription)
                                    }
      
                                }
                            }
                        case .failure(let err):
                            print(err)
                        }
                    })
                }
                
                
                
            case .failure(let err):
                print(err)
            }
        })
        
    }
    
    
}

extension MainScreenVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cellID, for: indexPath) as! CollectionViewCell
        
        cell.setModel(photo: results[indexPath.row])
        return cell
    }
    
    
    
}
