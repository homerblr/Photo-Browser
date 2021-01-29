//
//  PhotoDataCache.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 27.01.21.
//

import Foundation

protocol PhotoDataCacheProtocol {
    func readPhoto(withID id: String, imageFormat: ImageFormat, completion: (Result<Data?, Error>) -> Void)
    func save(photoData: Data, withID id: String, imageFormat: ImageFormat, completion: (Error?) -> Void)
}

enum ImageFormat : String {
    case jpg, png
}

class PhotoDataCache: PhotoDataCacheProtocol
{
    var directoryURL : URL?
    init() {
        if FileManager.default.fileExists(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path) && !FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).isEmpty  {
            self.directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        } else {
            do {
               try FileManager.default.createDirectory(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path, withIntermediateDirectories: true, attributes: nil)
                self.directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func readPhoto(withID id: String, imageFormat: ImageFormat, completion: (Result<Data?, Error>) -> Void) {
        var data: Data?
        let fileURL = URL(fileURLWithPath: id, relativeTo: directoryURL).appendingPathExtension(imageFormat.rawValue)
            do {
                data = try Data(contentsOf: fileURL)
                completion(.success(data))
            } catch {
                let error = NSError(domain: "photoDataCache.readPhoto", code: -1, userInfo:["Reason": "Can't read photo"])
                completion(.failure(error))
            }
    }
    
    func save(photoData: Data, withID id: String, imageFormat: ImageFormat, completion: (Error?) -> Void) {
        let fileURL = URL(fileURLWithPath: id, relativeTo: directoryURL).appendingPathExtension(imageFormat.rawValue)
            do {
                try photoData.write(to: fileURL)
            } catch {
                print("Can't save photo to disk, \(error.localizedDescription)")
            }
    }
   
}
