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
    var photoID : String?
    func updateImageViewLayer() {
            DispatchQueue.main.async {
                self.photoImageView.contentMode = .scaleAspectFill
                self.photoImageView.layer.cornerRadius = 10
            }
        }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    }
    
    



