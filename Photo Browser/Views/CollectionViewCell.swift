//
//  CollectionViewCell.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 14.01.21.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    static let cellID = "ImageCell"
    var photoObject : PhotoObject?
    var photoDataService = PhotoDataService()
    
    func setModel(photo: PhotoObject) {
        photoObject = photo
        
    }
    func setPhoto() {
        guard let photoID = photoObject?.id else {return}
        if let photoData = photoDataService.readSavedPhoto(photoID: photoID) {
            DispatchQueue.main.async {
                self.photoImage.image = UIImage(data: photoData)
                self.photoImage.contentMode = .scaleAspectFill
                self.photoImage.layer.cornerRadius = 10
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoImage.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

