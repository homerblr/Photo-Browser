//
//  CollectionViewCell.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 14.01.21.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    static let cellID = "ImageCell"
    var directoryURL : URL?
    var photoObject : Photo?
    func setModel(photo: Photo) {
        photoObject = photo
    }
    
    @objc func onDidReceiveData(_ notification: Notification) {
        guard let photo = photoObject else { fatalError("chto-to ne tak")}
        if !FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).isEmpty {
           directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
        if let directoryURL = self.directoryURL {
            let fileURL = URL(fileURLWithPath: photo.id, relativeTo: directoryURL).appendingPathExtension("jpg")
        do {
        let savedImage = try Data(contentsOf: fileURL)
            DispatchQueue.main.async {
                self.image.image = UIImage(data: savedImage)
            }
        } catch {
            print("unable to read data")
        } } else {
            print("directory not found")
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: Notification.Name("download complete"), object: nil)
        print("init")
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: Notification.Name("download complete"), object: nil)
        
    }
}
