//
//  PhotoFM.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 21.01.21.
//

import UIKit

class PhotoDataService {
    
    var directoryURL : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    func readSavedPhoto(photoID: String) -> Data? {
        var data : Data?
            let fileURL = URL(fileURLWithPath: photoID, relativeTo: directoryURL).appendingPathExtension("jpg")
            do {
                data = try Data(contentsOf: fileURL)
            } catch {
                print("Can't load photo from disk, \(error.localizedDescription)")
            }
        return data
    }
    
    func savePhoto(photoID : String, data : Data) {
            let fileURL = URL(fileURLWithPath: photoID, relativeTo: directoryURL).appendingPathExtension("jpg")
            do {
                try data.write(to: fileURL)
            } catch {
                print("Can't save photo to disk, \(error.localizedDescription)")
            }
    }
}
