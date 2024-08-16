//
//  AnimeRow.swift
//  E-Catalogs
//
//  Created by rColeJnr on 16/08/24.
//

import SwiftUI

struct AnimeRow: View {
    let anime: Anime
    var body: some View {
        VStack {
            Text(anime.title!)
            Text(anime.synopsis!)
            Spacer(minLength: 10)
        }
     
    }
}
