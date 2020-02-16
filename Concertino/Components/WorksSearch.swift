//
//  WorksSearch.swift
//  Concertino
//
//  Created by Adriano Brandao on 12/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct WorksSearch: View {
    var composer: Composer
    @EnvironmentObject var search: WorkSearch
    @State private var loading = true
    @State private var works = [Work]()
    @State private var genresAvail = [String]()
    @State private var hasEssential = false
    
    init(composer: Composer) {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        self.composer = composer
    }
    
    func loadData() {
        if !self.search.loadingGenres {
            loading = true
            
            APIget(AppConstants.openOpusBackend+"/work/list/composer/\(self.composer.id)/\(self.search.genreName).json") { results in
                let worksData: Works = parseJSON(results)
                
                DispatchQueue.main.async {
                    self.genresAvail.removeAll()
                    if let wrks = worksData.works {
                        self.works = wrks
                        self.hasEssential = (self.works.filter({$0.recommended == "1"}).count > 0)
                        
                        for genre in AppConstants.genreList {
                            if self.works.filter({$0.genre == genre}).count > 0 {
                                self.genresAvail.append(genre)
                            }
                        }
                    }
                    else {
                        self.works = [Work]()
                    }
                    
                    self.loading = false
                }
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if self.loading {
                HStack {
                    Spacer()
                    ActivityIndicator(isAnimating: loading)
                    .configure { $0.color = .white; $0.style = .large }
                    Spacer()
                }
                .padding(40)
            }
            else {
                if self.works.count > 0 {
                    WorksList(genre: search.genreName, genrelist: genresAvail, works: works, composer: self.composer, essential: hasEssential)
                    .padding(.top, 14)
                    .gesture(DragGesture().onChanged{_ in self.endEditing(true) })
                }
                else {
                    ErrorMessage(msg: "No works found.")
                }
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear(perform: { if self.loading { self.loadData() }})
        .onReceive(search.objectWillChange, perform: loadData)
    }
}

struct WorksSearch_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
