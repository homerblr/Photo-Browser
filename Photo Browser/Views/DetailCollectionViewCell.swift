//
//  DetailCollectionViewCell.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 20.01.21.
//


import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var detailPhotoImageView: UIImageView!
    static let cellID = "DetailCell"
    var photoObject : PhotoObject?
    var photoDataService = PhotoDataService()
    
    func setModel(photo: PhotoObject) {
        photoObject = photo
    }
    
    func updatePhoto() {
        guard let photoID = photoObject?.id else {return}
        if let photoData = photoDataService.readSavedPhoto(photoID: photoID) {
            DispatchQueue.main.async {
                self.detailPhotoImageView.image = UIImage(data: photoData)
                self.detailPhotoImageView.contentMode = .scaleAspectFit
                self.detailPhotoImageView.layer.cornerRadius = 10
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.detailPhotoImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

