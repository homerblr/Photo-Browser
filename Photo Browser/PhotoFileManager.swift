//
//  FileManager.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 21.01.21.
//

import UIKit

struct PhotoFileManager {
    
    var directoryURL : URL?
  
    mutating func searchSavedAndSetImage(_ photoImage : UIImageView, photoObject: PhotoObject?) {
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
                    photoImage.image = UIImage(data: savedImage)
                    photoImage.contentMode = .scaleAspectFill
                    photoImage.layer.cornerRadius = 10
                }
            } catch {
                print("unable to read data")
            } } else {
                print("directory not found")
            }
    }
}
