//
//  Anime.swift
//  E-Catalogs
//
//  Created by rColeJnr on 16/08/24.
//

import Foundation
struct NetworkAnime: Codable{
    struct Image: Codable {
        let jpg: Jpg
        struct Jpg: Codable {
            let image_url: String
        }
    }
    
    struct Aired: Codable {
        let string: String
    }
    
    struct Genre: Codable {
        let name: String
    }
    
    let mal_id: Int
    let images: Image?
    let title: String
    let source: String
    let episodes: Int
    let airing: Bool
    let aired: Aired?
    let duration: String
    let rating: String
    let rank: Int
    let popularity: Int
    let synopsis: String
    let background: String
    let genres: [Genre]
    

}

