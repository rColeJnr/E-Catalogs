//
//  AnimeLoadingView.swift
//  E-Catalogs
//
//  Created by rColeJnr on 16/08/24.
//

import SwiftUI

struct AnimeLoadingView: View {
    var body: some View {
        VStack(spacing: 20)  {
            Text("😸")
                .font(.system(size: 80))
            ProgressView()
            Text("Getting the good shit ...")
                .foregroundColor(.gray)
            
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        AnimeLoadingView()
    }
}
