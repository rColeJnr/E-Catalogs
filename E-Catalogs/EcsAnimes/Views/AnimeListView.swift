//
//  AnimeListView.swift
//  E-Catalogs
//
//  Created by rColeJnr on 16/08/24.
//

import SwiftUI

struct AnimeListView: View {
    let animes: [Anime]
    let viewWidth: CGFloat!
    
    init(_ viewWidth: CGFloat, animes: [Anime]) {
        self.animes = animes
        self.viewWidth = viewWidth
    }
    
    var body: some View {
        NavigationView{
            List {
                ForEach(animes) { anime in
                    NavigationLink {
                        AnimeDetailsView(anime: anime, viewWidth: viewWidth)
                    } label: {
                        AnimeRow(anime: anime, viewWidth: viewWidth)
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}
