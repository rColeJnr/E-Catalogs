//
//  AnimeView.swift
//  E-Catalogs
//
//  Created by rColeJnr on 16/08/24.
//

import SwiftUI

struct AnimeView: View {
    
    private let viewModel = AnimeViewModel()
    private let animes: [Anime]!
    
    init(animes: [Anime]!) {
        self.animes = animes
    }
    
    var body: some View {
        
        if viewModel.isLoading.value ?? true {
            AnimeLoadingView()
        } else if viewModel.errorMsg.value != nil {
            AnimeErrorView()
        } else {
            
            AnimeListView(animes: animes)
        }
    }
}
