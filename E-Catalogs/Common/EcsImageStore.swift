//
//  ImageStore.swift
//  E-Catalogs
//
//  Created by rColeJnr on 08/08/24.
//

import UIKit

/// Cache web fetched images in NSCache
class EcsImageStore {
    
    let cache = NSCache<NSString, UIImage>()
    
    func imageURL(forKey key: String) -> URL {
        
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory,
            in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
    }
    
    /// Save image to NSCache and FileSystem
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        // Create full URL for image
        let url = imageURL(forKey: key)
        
        // Turn image into JPEG data
        if let data = image.jpegData(compressionQuality: 0.5) {
            // Write it to full URL
            let _ = try? data.write(to: url, options: [.atomic])
        }
    }
    
    /// Get image
    func image(forKey key: String) -> UIImage? {
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        } else {
            let url = imageURL(forKey: key)
            
            guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
                return nil
            }
            
            cache.setObject(imageFromDisk, forKey: key as NSString)
            return imageFromDisk
        }
    }
    
    /// Delete image from NSCache and filysystem
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error removing the image from disk: \(error)")
        }
    }
    
}

