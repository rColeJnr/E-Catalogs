//
//  AnimeResponse.swift
//  E-Catalogs
//
//  Created by rColeJnr on 16/08/24.
//

import Foundation

struct AnimeResponse: Codable {
    
    struct Pagination: Codable {
        let last_visible_page: Int
        let has_next_page: Bool
        let current_page: Int
        let items: [Item]
    }
    
    struct Item: Codable {
        let count: Int
        let total: Int
        let per_page: Int
    }
    
    let pagination: Pagination
    let data: [NetworkAnime]
    
    enum CodingKeys: String, CodingKey {
        case pagination
        case data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pagination = try values.decode(Pagination.self, forKey: .pagination)
        data = try values.decode([NetworkAnime].self, forKey: .data)
    }
    
    init(pagination: Pagination, data: [NetworkAnime]) {
        self.pagination = pagination
        self.data = data
    }
}
