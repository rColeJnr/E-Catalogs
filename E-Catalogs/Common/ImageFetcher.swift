//
//  ImageFetcher.swift
//  E-Catalogs
//
//  Created by rColeJnr on 08/08/24.
//

import UIKit

private let imageStore = ImageStore()

func fetchImage(url: URL, key: String, session: URLSession, completion: @escaping (ImageResult) -> Void) {
    
    let imageKey = key
    if let image = imageStore.image(forKey: imageKey) {
        OperationQueue.main.addOperation {
            completion(.success(image))
        }
        return
    }
    
    let request = URLRequest(url: url)
    
    let task = session.dataTask(with: request) { (data, _, error) -> Void in
        let result = processImageRequest(data: data, error: error)
        
        if case let .success(image) = result {
            imageStore.setImage(image, forKey: key)
        }
        
        OperationQueue.main.addOperation {
            completion(result)
        }
        
    }
    task.resume()
    
}

func processImageRequest(data: Data?, error: Error?) -> ImageResult {
    guard
        let imageData = data,
        let image = UIImage(data: imageData) else {
        
        if data == nil {
            return .failure(error!)
        } else {
            return .failure(ImageError.imageCreationError)
        }
    }
    
    return .success(image)
}
