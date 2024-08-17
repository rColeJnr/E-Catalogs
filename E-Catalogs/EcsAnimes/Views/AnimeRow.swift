//
//  AnimeRow.swift
//  E-Catalogs
//
//  Created by rColeJnr on 16/08/24.
//

import SwiftUI

struct AnimeRow: View {
    let anime: Anime
    let viewWidth: CGFloat!
    var body: some View {
        VStack {
            let viewHeight = viewWidth * 1.1
            Text(anime.title!)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.headline)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20) )
            if anime.image != nil {
                AsyncImage(url: anime.image! as URL) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .scaledToFill()
                            .frame(width: viewWidth, height: viewHeight)
                            .clipped()
                    } else if phase.error != nil {
                        Text(phase.error?.localizedDescription ?? "Error")
                            .foregroundColor(Color.brown)
                            .frame(width: viewWidth, height: viewHeight)
                    } else {
                        ProgressView()
                            .frame(width: viewWidth, height: viewHeight)
                    }
                    
                }
            } else {
                Color.brown.frame(width: viewWidth, height: viewHeight)
            }
            Text(anime.synopsis!)
                .font(.footnote)
                .lineLimit(3)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 2, trailing: 20))
        }
    }
}
