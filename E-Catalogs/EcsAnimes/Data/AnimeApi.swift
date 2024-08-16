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
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy=MM-dd HH:mm:ss"
        return formatter
    }()
    
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
                print("ANIME JSON STRUCTURE does not match expected")
                return .failure(AnimeApiError.parsing(nil))
            }
            
            // WE need to remove currently cached anime before calling topAnime
            
            var finalAnimes = [Anime]()
            for anime in results {
                if let anime = topAnime(from: anime, into: context) {
                    finalAnimes.append(anime)
                }
            }
            
            return .success(finalAnimes)
        } catch {
            print("Error decoding error")
            print(String(describing: error))
            return .failure(AnimeApiError.parsing(error as? DecodingError))
        }
    }
    
    /// Construct a book from JsonData, fetch CoreData for a match, if core data has book with same isbn10 return coreData book, else return book constructed from jsonData
    private static func topAnime(from networkAnime: [String:Any], into context: NSManagedObjectContext) -> Anime? {
        
        guard
            let animeId = networkAnime["mal_id"] as? Int,
//            let images = networkAnime["images"] as? NetworkAnime.Image,
            let title = networkAnime["title"] as? String,
            let source = networkAnime["source"] as? String,
            let episodes = networkAnime["episodes"] as? Int,
            let airing = networkAnime["airing"] as? Bool,
            let duration = networkAnime["duration"] as? String,
            let rating = networkAnime["rating"] as? String,
            let rank = networkAnime["rank"] as? Int,
            let background = networkAnime["background"] as? String,
            let synopsis = networkAnime["synopsis"] as? String else {
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
            let image = AnimeImage(context: context)
            let jpg = AnimeJpg(context: context)
//            jpg.imageUrl = NSURL(string: images.jpg.image_url)
            image.jpg = jpg
            
            anime.images = image
            anime.title = title
            anime.source = source
            anime.episodes = Int32(episodes)
            anime.airing = airing
            anime.duration = duration
            anime.rating = rating
            anime.rank = Int32(rank)
            anime.synopsis = synopsis
            anime.background = background
        })
        return anime
    }
}

enum AnimeMethod: String {
    case fetchTopAnime = "v4/top/anime"
}
