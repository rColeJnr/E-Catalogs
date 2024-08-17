//
//  AnimeApi.swift
//  E-Catalogs
//
//  Created by rColeJnr on 16/08/24.
//

import Foundation
import CoreData

struct AnimeApi {
    
    private static let baseUrl = "https://api.jikan.moe/"
    
    static var fetchTopAnime: URL {
        return animeUrl(method: .fetchTopAnime, parameters: nil)
    }
    
    /// Build book url
    private static func animeUrl(method: AnimeMethod, parameters: [String:String]? ) -> URL {
        
        var components: URLComponents = URLComponents(string: baseUrl+method.rawValue)!
        var queryItems: [URLQueryItem] = []
        
        if let additionalParameters = parameters {
            for (key, value) in additionalParameters {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        
        components.queryItems = queryItems
        
        return components.url!
    }
     
    /// Build an array list fo books from json, then call func book on each book, return final array of books
    static func animeResponse(fromJson json: Data, into context: NSManagedObjectContext) -> AnimeResult {
        do {
            
            let jsonObject = try JSONSerialization.jsonObject(with: json)
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let results = jsonDictionary["data"] as? [[String:Any]] else {
                print("Failed to parse anime jsonDictionary")
                    return .failure(AnimeApiError.parsing(nil))
            }
            
            // TODO WE need to remove currently cached anime before calling topAnime
            
            var finalAnimes = [Anime]()
            for anime in results {
                if let anime = topAnime(from: anime, into: context) {
                    finalAnimes.append(anime)
                }
            }
            
            return .success(finalAnimes)
        } catch {
            print(String(describing: error))
            return .failure(AnimeApiError.parsing(error as? DecodingError))
        }
    }
    
    /// Construct a book from JsonData, fetch CoreData for a match, if core data has book with same isbn10 return coreData book, else return book constructed from jsonData
    private static func topAnime(from networkAnime: [String:Any], into context: NSManagedObjectContext) -> Anime? {
        
        guard
            let animeId = networkAnime["mal_id"] as? Int,
            let title = networkAnime["title"] as? String,
            let source = networkAnime["source"] as? String,
            let duration = networkAnime["duration"] as? String,
            let rating = networkAnime["rating"] as? String,
            let rank = networkAnime["rank"] as? Int,
            let synopsis = networkAnime["synopsis"] as? String else {
            print("Failed to parse anime json")
            return nil
        }
        
        guard
            let images = networkAnime["images"] as? [String:Any],
            let jpg = images["jpg"] as? [String:Any],
            let imageUrlString = jpg["image_url"] as? String,
            let imageUrl = URL(string: imageUrlString) else {
            print("Failed to parse anime image")
            return nil
        }
        
        let fetchRequest: NSFetchRequest<Anime> = Anime.fetchRequest()
        fetchRequest.predicate = 
            NSPredicate(format: "\(#keyPath(Anime.animeId)) == \(animeId)")
        
        var cachedAnime: [Anime]?
        context.performAndWait{
            cachedAnime = try? fetchRequest.execute()
        }
        
        if let existing = cachedAnime?.first {
            return existing
        }
        
        var anime: Anime!
        context.performAndWait({
            anime = Anime(context: context)
            anime.animeId = Int32(animeId)
            anime.duration = duration
            anime.image = imageUrl as NSURL
            anime.rank = Int32(rank)
            anime.rating = rating
            anime.source = source
            anime.synopsis = synopsis
            anime.title = title
        })
        return anime
    }
}

enum AnimeMethod: String {
    case fetchTopAnime = "v4/top/anime"
}
