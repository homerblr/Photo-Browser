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
    var directoryURL : URL?
    var photoObject : PhotoObject?
    
    func setModel(photo: PhotoObject) {
        photoObject = photo
        searchSavedAndSetImage()
    }
    
    
    func searchSavedAndSetImage() {
        //TO DO: Make a seperate class for saving and reading data
        guard let photo = photoObject else { fatalError("Error while unwrapping PhotoObject")}
        if !FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).isEmpty {
            directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
        if let directoryURL = self.directoryURL {
            let fileURL = URL(fileURLWithPath: photo.id, relativeTo: directoryURL).appendingPathExtension("jpg")
            do {
                let savedImage = try Data(contentsOf: fileURL)
                DispatchQueue.main.async {
                    self.photoImage.image = UIImage(data: savedImage)
                }
            } catch {
                print("unable to read data")
            } } else {
                print("directory not found")
            }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoImage.image = nil
    }
}

