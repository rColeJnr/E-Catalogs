//
//  AnimeView.swift
//  E-Catalogs
//
//  Created by rColeJnr on 16/08/24.
//

import SwiftUI

struct AnimeView: View {
    
    private let isLoading: Bool!
    private let animes: [Anime]!
    private let errorMsg: String?
    private let viewWidth: CGFloat!
    
    init(_ viewWidth: CGFloat, animes: [Anime]!, isLoading: Bool!, errorMsg: String? = nil) {
        self.isLoading = isLoading
        self.animes = animes
        self.errorMsg = errorMsg
        self.viewWidth = viewWidth
    }
    
    var body: some View {
        
        if isLoading {
            AnimeLoadingView()
        } else if errorMsg != nil {
            AnimeErrorView()
        } else {
            AnimeListView.init(viewWidth, animes: animes)
        }
    }
}
