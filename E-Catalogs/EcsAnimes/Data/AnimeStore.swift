//
//  AnimeFetcher.swift
//  E-Catalogs
//
//  Created by rColeJnr on 16/08/24.
//

import Foundation
import CoreData

enum AnimeResult {
    case success([Anime])
    case failure(AnimeApiError)
}

class AnimeStore: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var errorMsg: String? = nil
    
 
    func fetchTopAnime(completion: @escaping (AnimeResult) -> Void) {
        isLoading = true
        errorMsg = nil
        
        let url = AnimeApi.fetchTopAnime
        let request = URLRequest(url: url)
        let task = EcsStore.shared.session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in

//            if let jsonData = data {
//                if let josnString = String(data: jsonData, encoding: .utf8) {
//                    print(josnString)
//                } else if let requestError = error {
//                        print("error fetching: \(requestError)")
//                    }
//            } else {
//                print("unxecpected error")
//            }

            
           self.processAnimeRequest(data: data, response: response, error: error, completion: { result in
                OperationQueue.main.addOperation {
                    self.isLoading = false
                    completion(result)
                }
            })
        })
        task.resume()
    }

    private func processAnimeRequest(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (AnimeResult) -> Void) {
        if let error = error as? URLError {
            errorMsg = error.localizedDescription
            completion(.failure(AnimeApiError.url(error)))
        } else if let response = response as? HTTPURLResponse,
                  !(200...299).contains(response.statusCode) {
            self.errorMsg = "http response error"
            completion(.failure(AnimeApiError.badResponse(statusCode: response.statusCode)))
        } else if let data = data {
            EcsStore.shared.persistentContainer.performBackgroundTask{context in
          
                let result = AnimeApi.animeResponse(fromJson: data, into: context)
                
                do {
                    try context.save()
                } catch {
                    self.errorMsg = "Error saving to core data"
                    print("Error saving to core data: \(error)")
                    completion(.failure(AnimeApiError.coreDataError))
                    return
                }
                
                switch result {
                case .success(let array):
                    let animeIds = array.map { return $0.objectID }
                    let viewContext = EcsStore.shared.persistentContainer.viewContext
                    let viewContextAnimes = animeIds.map { return viewContext.object(with: $0) } as! [Anime]
                    completion(.success(viewContextAnimes))
                case .failure:
                    print(String(describing: result))
                    completion(result)
                }
            
            }
        }
    }
    
    func fetchAllAnimes(completion: @escaping (AnimeResult) -> Void) {
        let fetchRequest: NSFetchRequest<Anime> = Anime.fetchRequest()
        
        let viewContext = EcsStore.shared.persistentContainer.viewContext
        viewContext.perform {
            do {
                let allMovies = try viewContext.fetch(fetchRequest)
                completion(.success(allMovies))
            } catch {
                completion(.failure(AnimeApiError.coreDataError))
            }
        }
    }
}
