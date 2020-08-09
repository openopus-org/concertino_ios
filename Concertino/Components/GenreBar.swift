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
    @EnvironmentObject var settingStore: SettingStore
    
    func loadData() {
        loading = true
        
        if (search.composerId != self.composerId) {
            search.loadingGenres = true
        }
        
        APIget(AppConstants.openOpusBackend+"/genre/list/composer/\(self.composerId).json") { results in
            if let genresData: Genres = safeJSON(results) {
                DispatchQueue.main.async {
                    if let genr = genresData.genres {
                        var genreslist = genr.filter(){$0 != "Popular"}
                        
                        if self.settingStore.composersFavoriteWorks.contains(self.composerId) {
                            genreslist.insert("Favorites", at: 0)
                        }
                        
                        self.genres = genreslist
                        
                        if (self.search.composerId != self.composerId || (self.search.genreName == "Favorites" && !self.settingStore.composersFavoriteWorks.contains(self.composerId))) {
                            if genr.contains("Favorites") {
                                self.search.genreName = "Favorites"
                            } else if genr.contains("Recommended") {
                                self.search.genreName = "Recommended"
                            } else {
                                self.search.genreName = genr[0]
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
        .onAppear(perform: {
            if self.genres.count == 0 {
                self.loadData()
            }
        })
        .onReceive(settingStore.composersFavoriteWorksDidChange, perform: loadData)
    }
}

struct GenreBar_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
