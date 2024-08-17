//
//  AnimeDetailsView.swift
//  E-Catalogs
//
//  Created by rColeJnr on 17/08/24.
//

import SwiftUI

struct AnimeDetailsView: View {
    
    let anime: Anime
    let viewWidth: CGFloat
    
    var body: some View {
        ScrollView {
            let viewHeight = viewWidth * 1.2
            VStack(alignment: .leading, spacing: 10) {
                Text(anime.title!)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)
                    .padding()
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
                
                Text("Rank: \(anime.rank)")
                    .font(.footnote)
                
                Text("Rating: \(anime.rating!)")
                    .font(.footnote)
                
                Text("Based on: \(anime.source!)")
                    .font(.footnote)
   
                Text("Duration: \(anime.duration!)")
                    .font(.footnote)
            }
        }
    }
}
