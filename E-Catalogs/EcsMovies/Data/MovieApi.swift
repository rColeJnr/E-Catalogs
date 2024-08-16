//
//  MovieApi.swift
//  E-Catalogs
//
//  Created by rColeJnr on 13/08/24.
//

import Foundation
import CoreData

struct MovieApi {
    private static let baseUrl = "https://api.themoviedb.org/3/"
    private static let apiKey = ""
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy=MM-dd HH:mm:ss"
        return formatter
    }()
    
    static func fetchTrendingMovies(page: Int) -> URL {
        return movieUrl(method: .fetchTrendingMovies, page: page, parameters: nil).absoluteURL
    }
    
    /// Build book url
    private static func movieUrl(method: MovieMethod, page: Int, parameters: [String:String]? ) -> URL {
        
        var components: URLComponents = URLComponents(string: baseUrl+method.rawValue)!
        var queryItems: [URLQueryItem] = []
        
        let baseParams = [
            "api_key": apiKey,
            "page": "\(page)"
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
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
    static func movieResponses(fromJson json: Data, into context: NSManagedObjectContext) -> MovieResponseResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: json, options: [])
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let results = jsonDictionary["results"] as? [[String:Any]] else {
                // The Json structure doesn't match our expectations
                print("Print: movie json structure does not match")
                return .failure(EcsError.invalidJsonData)
            }
            
            guard let moviePage = jsonDictionary["page"] as? Int else {
                print("failed to convert json page")
                return .failure(EcsError.invalidJsonData)
            }
            
            var finalMovies = [MovieResponse]()
            for json in results {
                if let movie = trendingMovie(fromJson: json, page: moviePage, into: context) {
                    finalMovies.append(movie)
                }
            }
            
            if finalMovies.isEmpty && !results.isEmpty {
                // we weren't able to parse any of the books
                // maybe the json format for books has changed
                print("Unable to parse movie data ")
                return .failure(EcsError.invalidJsonData)
            }
            return .success(finalMovies)
        } catch let error {
            return .failure(error)
        }
    }
    
    /// Construct a book from JsonData, fetch CoreData for a match, if core data has book with same isbn10 return coreData book, else return book constructed from jsonData
    private static func trendingMovie(fromJson json: [String: Any], page: Int, into context: NSManagedObjectContext) -> MovieResponse? {
        guard
            let movieId = json["id"] as? Int,
            let title = json["title"] as? String,
            let overview = json["overview"] as? String,
            let imageUrlString = json["backdrop_path"] as? String,
            let imageUrl = URL(string: imageUrlString) else {
            
            // Don't have enough information to construct a Book
            return nil
        }
        
        let fetchRequest: NSFetchRequest<MovieResponse> = MovieResponse.fetchRequest()
        let predicate1 = NSPredicate(format: "\(#keyPath(MovieResponse.movieId)) == \"\(movieId)\"")
        let predicate2 = NSPredicate(format: "\(#keyPath(MovieResponse.title)) == \"\(title)\"")
        let compoundPredicate = NSCompoundPredicate.init(type: .and, subpredicates: [predicate1, predicate2])
        
        fetchRequest.predicate = compoundPredicate
        
        var cachedMovie: [MovieResponse]?
        context.performAndWait{
            cachedMovie = try? fetchRequest.execute()
        }
        
        if let existing = cachedMovie?.first {
            return existing
        }
        
        var movie: MovieResponse!
        context.performAndWait({
            movie = MovieResponse(context: context)
            movie.movieId = Int64(movieId)
            movie.title = title
            movie.image = imageUrl as NSURL
            movie.overview = overview
            movie.page = Int16(page)
        })
        return movie
    }
}

enum MovieMethod: String {
    case fetchTrendingMovies = "trending/movie/week"
}

/// https://api.nytimes.com/svc/books/v3/lists/current/hardcover-fiction.json?api-key=yourkey
