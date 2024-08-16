//
//  EcsStore.swift
//  E-Catalogs
//
//  Created by rColeJnr on 16/08/24.
//

import Foundation
import CoreData

class EcsStore {
    
    public static var shared: EcsStore = EcsStore()
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    let persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "EcsCoreData")
        container.loadPersistentStores(completionHandler: {description, error in
            if let error = error {
                print("Error setting up core data: \(error)")
            }
        })
        return container
    }()
    
    func ecsFetchImage(url: NSURL?, key: String?, completion: @escaping (EcsImageResult) -> Void) {
        guard
            let imageURL = url as URL?,
            let keyString = key else {
            return
        }
        EcsImageFetcher.imageFetcher.fetchImage(url: imageURL, key: keyString, session: session, completion: completion)
    }
    
}
