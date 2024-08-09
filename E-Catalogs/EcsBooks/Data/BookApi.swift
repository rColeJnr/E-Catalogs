//
//  BookApi.swift
//  E-Catalogs
//
//  Created by rColeJnr on 08/08/24.
//

import Foundation
import CoreData

struct BookApi {
    private static let baseUrl = "https://api.nytimes.com/"
    private static let apiKey = ""
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy=MM-dd HH:mm:ss"
        return formatter
    }()
    static var fictionBestsellersUrl: URL {
        return bookUrl(method: .getFictionBestsellers, parameters: nil)
    }
    
    static var nonFictionBestsellersUrl: URL {
        return bookUrl(method: .getNonFictionBestsellers, parameters: nil)
    }
    
    static var miscellaneousBestsellersUrl: URL {
        return bookUrl(method: .getMiscellaneousBestsellers, parameters: nil)
    }
    
    static var graphicBestsellersUrl: URL {
        return bookUrl(method: .getGraphicBestsellers, parameters: nil)
    }
    
    private static func bookUrl(method: Method, parameters: [String:String]? ) -> URL {
        
        var components: URLComponents = URLComponents(string: baseUrl+method.rawValue)!
        var queryItems: [URLQueryItem] = []
        
        let baseParams = [
            "api-key": apiKey
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
        
    static func books(fromJson json: Data, into context: NSManagedObjectContext) -> BooksResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: json, options: [])
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let books = jsonDictionary["results"] as? [String:Any],
                let booksArray = books["books"] as? [[String:Any]] else {
                // The Json structure doesn't match our expectations
                print("Print: json structure doenst match")
                return .failure(EcsError.invalidJsonData)
            }
            
            var finalBooks = [Book]()
            for bookJson in booksArray {
                if let book = book(fromJson: bookJson, into: context) {
                    finalBooks.append(book)
                }
            }
            
            if finalBooks.isEmpty && !booksArray.isEmpty {
                // we weren't able to parse any of the books
                // maybe the json format for books has changed
                print("Unable to parse book data ")
                return .failure(EcsError.invalidJsonData)
            }
            return .success(finalBooks)
        } catch let error {
            return .failure(error)
        }
    }
    
    private static func book(fromJson json: [String: Any], into context: NSManagedObjectContext) -> Book? {
        guard
            let bookIsbn = json["primary_isbn10"] as? String,
            let rank = json["rank"] as? Int,
            let rankLastWeek = json["rank_last_week"] as? Int,
            let weeksOnList = json["weeks_on_list"] as? Int,
            let description = json["description"] as? String,
            let title = json["title"] as? String,
            let author = json["author"] as? String,
            let imageUrlString = json["book_image"] as? String,
            let amazonUrlString = json["amazon_product_url"] as? String,
            let imageUrl = URL(string: imageUrlString),
            let amazonUrl = URL(string: amazonUrlString) else {
            
            // Don't have enough information to construct a Book
            return nil
        }
        
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        let predicate = NSPredicate(format: "\(#keyPath(Book.isbn10)) == \(bookIsbn)")
        fetchRequest.predicate = predicate
        
        var fetchedBooks: [Book]?
        context.performAndWait{
            fetchedBooks = try? fetchRequest.execute()
        }
        
        if let existingBook = fetchedBooks?.first {
            return existingBook
        }
        
        var book: Book!
        context.performAndWait({
            book = Book(context: context)
            book.title = title
            book.author = author
            book.bookDescription = description
            book.amazonLiink = amazonUrl as NSURL
            book.image = imageUrl as NSURL
            book.isbn10 = bookIsbn
            book.rank = Int16(rank)
            book.rankLastWeek = Int16(rankLastWeek)
            book.weeksOnLIst = Int16(weeksOnList)
    
        })
        
        return book
    }
}

enum Method: String {
    case getFictionBestsellers = "svc/books/v3/lists/current/hardcover-fiction.json"
    case getNonFictionBestsellers = "svc/books/v3/lists/current/hardcover-nonfiction.json"
    case getMiscellaneousBestsellers = "svc/books/v3/lists/current/advice-how-to-and-miscellaneous.json"
    case getGraphicBestsellers = "svc/books/v3/lists/current/graphic-books-and-manga.json"
}

enum EcsError: Error {
    case invalidJsonData
}

/// https://api.nytimes.com/svc/books/v3/lists/current/hardcover-fiction.json?api-key=yourkey
