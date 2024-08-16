//
//  MovieStore.swift
//  E-Catalogs
//
//  Created by rColeJnr on 13/08/24.
//

import UIKit
import CoreData

enum MovieResponseResult {
    case success([MovieResponse])
    case failure(Error)
}

class MovieStore {
    
    func fetchTrendingMovies(_ page: Int, completion: @escaping (MovieResponseResult) -> Void) {
        let url = MovieApi.fetchTrendingMovies(page: page)
        let request = URLRequest(url: url)
        let task = EcsStore.shared.session.dataTask(with: request, completionHandler: { (data, _, error) -> Void in
            print(url.absoluteString)
            
           self.processMovieResponseRequest(data: data, error: error, completion: { result in
                OperationQueue.main.addOperation {
                    completion(result)
                }
            })
        })
        task.resume()
    }

    // Cache all books fetched from api, return cached books.
    private func processMovieResponseRequest(data: Data?, error: Error?, completion: @escaping (MovieResponseResult) -> Void) {
        guard let jsonData = data else {
            completion(.failure(error!))
            return
        }
        
        EcsStore.shared.persistentContainer.performBackgroundTask { context in
            let result = MovieApi.movieResponses(fromJson: jsonData, into: context)
            
            do {
                try context.save()
            } catch {
                print("Error saving to core data: \(error)")
                completion(.failure(error))
                return
            }
            
            switch result {
            case .success(let array):
                let movieIds = array.map { return $0.objectID }
                let viewContext = EcsStore.shared.persistentContainer.viewContext
                let viewContextMovies = movieIds.map { return viewContext.object(with: $0) } as! [MovieResponse]
                completion(.success(viewContextMovies))
            case .failure:
                completion(result)
            }
        }
    }
    
    /// Download the image from the image urlString, the image is cached during this function call.
  
    
    /// Fetch core data for previously cached books
    func fetchAllMovies(completion: @escaping (MovieResponseResult) -> Void) {
        let fetchRequest: NSFetchRequest<MovieResponse> = MovieResponse.fetchRequest()
        
        let viewContext = EcsStore.shared.persistentContainer.viewContext
        viewContext.perform {
            do {
                let allMovies = try viewContext.fetch(fetchRequest)
                completion(.success(allMovies))
            } catch {
                completion(.failure(error))
            }
        }
        
    }
}
