//
//  PhotoFM.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 21.01.21.
//

import UIKit

class PhotoDataService {
    
    
    var directoryURL : URL?
    init() {
        if !FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).isEmpty {
            self.directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
      
    }
    
    func readSavedPhoto(photoID: String) -> Data? {
        var data : Data?
            let fileURL = URL(fileURLWithPath: photoID, relativeTo: directoryURL).appendingPathExtension("jpg")
            do {
                data = try Data(contentsOf: fileURL)
            } catch {
               
            }
        return data
    }
    
    func savePhoto(photoID: String, data: Data) {
            let fileURL = URL(fileURLWithPath: photoID, relativeTo: directoryURL).appendingPathExtension("jpg")
            do {
                try data.write(to: fileURL)
            } catch {
                print("Can't save photo to disk, \(error.localizedDescription)")
            }
    }
}


