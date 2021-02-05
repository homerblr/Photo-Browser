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
    var photoID : String?
    
    private func updateImageViewLayer() {
        DispatchQueue.main.async {
            self.detailPhotoImageView.contentMode = .scaleAspectFit
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateImageViewLayer()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

