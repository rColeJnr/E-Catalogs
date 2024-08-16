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
    
 
    func fetchTopAnime(completion: @escaping (AnimeResult) -> Void) {
        isLoading = true
        
        let url = AnimeApi.fetchTopAnime
        let request = URLRequest(url: url)
        let task = EcsStore.shared.session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
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
            print("ERror urlError")
            completion(.failure(AnimeApiError.url(error)))
        } else if let response = response as? HTTPURLResponse,
                  !(200...299).contains(response.statusCode) {
            print("Error 200.2099")
            completion(.failure(AnimeApiError.badResponse(statusCode: response.statusCode)))
        } else if let data = data {
            EcsStore.shared.persistentContainer.performBackgroundTask{context in
          
                let result = AnimeApi.animeResponse(fromJson: data, into: context)
                
                do {
                    try context.save()
                } catch {
                    print("Error saving to core data: \(error)")
                    completion(.failure(AnimeApiError.coreDataError))
                    return
                }
                
                switch result {
                case .success(let array):
                    let animeIds = array.map { return $0.objectID }
                    let viewContext = EcsStore.shared.persistentContainer.viewContext
                    let viewContextAnimes = animeIds.map { return viewContext.object(with: $0) } as! [Anime]
                    print("success viewcontexts: \(viewContextAnimes.count)")
                    completion(.success(viewContextAnimes))
                case .failure:
                    print("error return viewContextAnimes")
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
                print("did get all cunts \(allMovies.count)")
                completion(.success(allMovies))
            } catch {
                print("Error parsing coredata all animes")
                completion(.failure(AnimeApiError.coreDataError))
            }
        }
    }
}
