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
                    self.detailPhotoImage.image = UIImage(data: savedImage)
                    self.detailPhotoImage.contentMode = .scaleAspectFit
                    self.detailPhotoImage.layer.cornerRadius = 10
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
        self.detailPhotoImage.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

