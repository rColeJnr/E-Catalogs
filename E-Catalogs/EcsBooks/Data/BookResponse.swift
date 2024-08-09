//
//  BookResponse.swift
//  E-Catalogs
//
//  Created by rColeJnr on 08/08/24.
//

import Foundation

struct BookResponse {
    let status: String
    let copyright: String
    let num_results: Int
    let last_modified: Date
    let results: BookResult
    
    struct BookResult {
        let list_name: String
        let bestsellers_date: Date
        let published_date: Date
        let books: [Book]
    }
}
