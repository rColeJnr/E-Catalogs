//
//  AnimeApiError.swift
//  E-Catalogs
//
//  Created by rColeJnr on 16/08/24.
//

import Foundation

enum AnimeApiError: Error {
    case coreDataError
    case badURL
    case badResponse(statusCode: Int)
    case url(URLError?)
    case parsing(DecodingError?)
    case unknown
    
    var localizedDescription: String {
        // User feedback
        switch self {
        case .coreDataError:
            return "Error trying to save to core data"
        case .badURL, .parsing, .unknown:
            return "Srry, something went wrong."
        case .badResponse(statusCode: _):
            return "Sorry, the server connection failed."
        case .url(let error):
            return error?.localizedDescription ?? "Something went wrong"
        }
    }
    
    var description: String {
        //info for debugging
        switch self {
        case .coreDataError: return "Core data error"
        case .unknown: return "unknown error"
        case .badURL: return "invalid URL"
        case .url(let error):
            return error?.localizedDescription ?? "url session error"
        case .parsing(let error):
            return "parsing error \(error?.localizedDescription ?? "")"
        case .badResponse(statusCode: let statusCode):
            return "bad response with status code \(statusCode)"
        }
    }
}
