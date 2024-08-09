//
//  BookStore.swift
//  E-Catalogs
//
//  Created by rColeJnr on 08/08/24.
//

import UIKit
import CoreData

enum BooksResult {
    case success([Book])
    case failure(Error)
}

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum ImageError: Error {
    case imageCreationError
}

class BookStore {
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EcsCoreData")
        container.loadPersistentStores(completionHandler: {description, error in
            if let error = error {
                print("Error setting up core data: \(error)")
            }
        })
        return container
    }()
    
    func fetchFictionBestsellers(completion: @escaping (BooksResult) -> Void) {
        let url = BookApi.fictionBestsellersUrl
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completionHandler: { (data, _, error) -> Void in
            
            // Print json response
//            if let jsonData = data {
//                if let josnString = String(data: jsonData, encoding: .utf8) {
//                    print(josnString)
//                } else if let requestError = error {
//                        print("error fetching: \(requestError)")
//                    }
//            } else {
//                print("unxecpected error")
//            }
//
            // Before core data caching
//            let result = self.processBooksRequest(data: data, error: error)
          
            self.processBooksRequest(data: data, error: error, completion: { result in
                OperationQueue.main.addOperation {
                    completion(result)
                }
            })
        })
        task.resume()
        
    }
    
    private func processBooksRequest(data: Data?, error: Error?, completion: @escaping (BooksResult) -> Void) {
        guard let jsonData = data else {
            completion(.failure(error!))
            return
        }
        
        persistentContainer.performBackgroundTask { context in
            let result = BookApi.books(fromJson: jsonData, into: context)
            
            do {
                try context.save()
            } catch {
                print("Error saving to core data: \(error)")
                completion(.failure(error))
                return
            }
            
            switch result {
            case .success(let array):
                let bookIds = array.map { return $0.objectID }
                let viewContext = self.persistentContainer.viewContext
                let viewContextBooks = bookIds.map { return viewContext.object(with: $0) } as! [Book]
                completion(.success(viewContextBooks))
            case .failure:
                completion(result)
            }
            
        }
    }
    
    func fetchBookImage(url: NSURL?, key: String?, completion: @escaping (ImageResult) -> Void) {
        guard 
            let imageURL = url as URL?,
            let keyString = key else {
            return
        }
        fetchImage(url: imageURL, key: keyString, session: session, completion: completion)
    }
    
    /// Fetch core data for previously cached books
    func fetchAllBooks(completion: @escaping (BooksResult) -> Void) {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        let sortByRank = NSSortDescriptor(key: #keyPath(Book.rank), ascending: true)
        
        fetchRequest.sortDescriptors = [sortByRank]
        
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            do {
                let allBooks = try viewContext.fetch(fetchRequest)
                completion(.success(allBooks))
            } catch {
                completion(.failure(error))
            }
        }
        
    }
}
