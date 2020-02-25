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
    @EnvironmentObject var search: WorkSearch
    
    func loadData() {
        loading = true
        
        if (search.composerId != self.composerId) {
            search.loadingGenres = true
        }
        
        APIget(AppConstants.openOpusBackend+"/genre/list/composer/\(self.composerId).json") { results in
            let genresData: Genres = parseJSON(results)
            
            DispatchQueue.main.async {
                if let genr = genresData.genres {
                    self.genres = genr
                    
                    if (self.search.composerId != self.composerId) {
                        if genr.contains("Recommended") {
                            self.search.genreName = "Recommended"
                        } else {
                            self.search.genreName = "all"
                        }
                    }
                }
                else {
                    self.genres = [String]()
                }
                
                if (self.search.composerId != self.composerId) {
                    self.search.composerId = self.composerId
                    self.search.loadingGenres = false
                }
                self.loading = false
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 14) {
                ForEach(genres, id: \.self) { genre in
                    Button(action: { self.search.genreName = genre }, label: {
                        GenreButton(genre: genre, active: (self.search.genreName == genre))
                            .frame(maxWidth: .infinity)
                    })
                }
            }
            .padding(.top, 12)
        }
        .onAppear(perform: loadData)
    }
}

struct GenreBar_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
