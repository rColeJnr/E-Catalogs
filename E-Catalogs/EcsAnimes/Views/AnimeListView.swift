//
//  AnimeListView.swift
//  E-Catalogs
//
//  Created by rColeJnr on 16/08/24.
//

import SwiftUI

struct AnimeListView: View {
    let animes: [Anime]
    
    init(animes: [Anime]) {
        self.animes = animes
    }
    
    var body: some View {

                    VStack{
                        AnimeRow(anime: animes.first!)
                        Spacer()
                        AnimeRow(anime: animes[1])
                        Spacer()
                        AnimeRow(anime: animes.last!)
                        Spacer()
                    }
                    
              
        
    }
}

//struct BreedListView_Previews: PreviewProvider {
//    static var previews: some View {
//    }
//}
