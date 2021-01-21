//
//  DetailCollectionViewCell.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 20.01.21.
//


import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var detailPhotoImage: UIImageView!
    static let cellID = "DetailCell"
    var photoObject : PhotoObject?
    var photoDataService = PhotoDataService()
    
    func setModel(photo: PhotoObject) {
        photoObject = photo
    }
    
    func setPhoto() {
        guard let photoID = photoObject?.id else {return}
        if let photoData = photoDataService.readSavedPhoto(photoID: photoID) {
            DispatchQueue.main.async {
                self.detailPhotoImage.image = UIImage(data: photoData)
                self.detailPhotoImage.contentMode = .scaleAspectFit
                self.detailPhotoImage.layer.cornerRadius = 10
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.detailPhotoImage.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

