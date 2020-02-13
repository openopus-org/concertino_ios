//
//  GenreBar.swift
//  Concertino
//
//  Created by Adriano Brandao on 11/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct GenreBar: View {
    var composerId: String
    @State private var genres = [String]()
    @State private var loading = true
    
    func loadData() {
        loading = true
        
        APIget(AppConstants.openOpusBackend+"/genre/list/composer/\(self.composerId).json") { results in
            let genresData: Genres = parseJSON(results)
            
            DispatchQueue.main.async {
                if let genr = genresData.genres {
                    self.genres = genr
                    self.loading = false
                }
                else {
                    self.genres = [String]()
                }
                
                self.loading = false
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Works".uppercased())
                .foregroundColor(Color(hex: 0x717171))
                .font(.custom("Nunito", size: 12))
                .padding(EdgeInsets(top: 12, leading: 20, bottom: 0, trailing: 0))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 14) {
                    ForEach(genres, id: \.self) { genre in
                        Text(genre)
                    }
                }
                .frame(minHeight: 174)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
        }
        .onAppear(perform: loadData)
    }
}

struct GenreBar_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
