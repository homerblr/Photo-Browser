//
//  PhotoFM.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 21.01.21.
//

import UIKit

class PhotoDataService {
    
    enum ImageFormat : String {
        case jpg, png
    }
    //.isEmpty
    var directoryURL : URL?
    init() {
        if FileManager.default.fileExists(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path) && !FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).isEmpty  {
            self.directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        } else {
            do {
               try FileManager.default.createDirectory(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path, withIntermediateDirectories: true, attributes: nil)
                self.directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                //собственная директория в .documentDirectory
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func readSavedPhoto(photoID: String, imageFormat : ImageFormat) -> Data? {
        var data : Data?
        let fileURL = URL(fileURLWithPath: photoID, relativeTo: directoryURL).appendingPathExtension(imageFormat.rawValue)
            do {
                data = try Data(contentsOf: fileURL)
            } catch {
               
            }
        return data
    }
    
    func savePhoto(photoID: String, data: Data, imageFormat : ImageFormat) {
        let fileURL = URL(fileURLWithPath: photoID, relativeTo: directoryURL).appendingPathExtension(imageFormat.rawValue)
            do {
                try data.write(to: fileURL)
            } catch {
                print("Can't save photo to disk, \(error.localizedDescription)")
            }
    }
}


