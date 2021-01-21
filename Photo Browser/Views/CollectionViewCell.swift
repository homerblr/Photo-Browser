//
//  CollectionViewCell.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 14.01.21.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    static let cellID = "ImageCell"
    var photoObject : PhotoObject?
    var photoDataService = PhotoDataService()
    
    func setModel(photo: PhotoObject) {
        photoObject = photo
        
    }
    func updatePhoto() {
        guard let photoID = photoObject?.id else {return}
        if let photoData = photoDataService.readSavedPhoto(photoID: photoID) {
            DispatchQueue.main.async {
                self.photoImageView.image = UIImage(data: photoData)
                self.photoImageView.contentMode = .scaleAspectFill
                self.photoImageView.layer.cornerRadius = 10
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

