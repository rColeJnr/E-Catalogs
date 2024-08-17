//
//  AnimeListView.swift
//  E-Catalogs
//
//  Created by rColeJnr on 08/08/24.
//

import SwiftUI

struct AnimeErrorView: View {
   
    
    var body: some View {
        VStack {
            
            Text("🥲")
                .font(.system(size: 80))
            
            Text("Error getting the good shit")
                
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        AnimeErrorView()
    }
}
