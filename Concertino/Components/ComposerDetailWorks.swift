//
//  ComposerDetailWorks.swift
//  Concertino
//
//  Created by Adriano Brandao on 16/06/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct ComposerDetail: View {
    var composer: Composer
    var isSearch: Bool
    @EnvironmentObject var search: WorkSearch
    @EnvironmentObject var settingStore: SettingStore
    @State private var loading = true
    @State private var works = [Work]()
    @State private var genresAvail = [String]()
    @State private var hasEssential = false
    
    init(composer: Composer, isSearch: Bool) {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        self.composer = composer
        self.isSearch = isSearch
    }
    
    func loadData() {
        print ("works count: \(self.works.count)")
        print ("loading genres: \(self.search.loadingGenres)")
        print ("search composer id: \(self.search.composerId)")
        print ("search genre name: \(self.search.genreName)")
        
        if !self.search.loadingGenres && self.search.composerId == self.composer.id && self.search.genreName != "" {
            loading = true
            var url: String
            
            if self.search.genreName == "Favorites" {
                url = AppConstants.concBackend+"/user/\(self.settingStore.userId)/composer/\(self.composer.id)/work/fav.json"
            } else {
                url = AppConstants.openOpusBackend+"/work/list/composer/\(self.composer.id)/\(self.search.genreName).json"
            }
            
            APIget(url) { results in
                if let worksData: Works = safeJSON(results) {
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
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            self.loading = false
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ComposerHeader(composer: composer)
                .padding(EdgeInsets(top: 12, leading: 20, bottom: -4, trailing: 20))
            
            ZStack(alignment: .top) {
                List {
                    Section(header:
                        GenreBar(composerId: composer.id)
                            .padding(.bottom, -20)
                            .frame(height: 50)
                    ){
                        EmptyView()
                    }
                    
                    Group {
                        Section(header:
                            WorksRadioButton(genreId: "\(self.composer.id)-\(search.genreName)")
                                .padding(.bottom, -20)
                        ){
                            EmptyView()
                        }
                        
                        if search.genreName == "Popular" || search.genreName == "Recommended" || search.genreName == "Favorites" {
                            ForEach(self.genresAvail, id: \.self) { genre in
                                if #available(iOS 14.0, *) {
                                    Section(header:
                                        Text(genre)
                                            .font(.custom("Barlow-SemiBold", size: 13))
                                            .foregroundColor(Color(hex: 0xFE365E))
                                            .padding(.top, 0)
                                            .textCase(.none)
                                    ){
                                        ForEach(self.works.filter({$0.genre == genre}), id: \.id) { work in
                                            WorkRow(work: work, composer: self.composer)
                                        }
                                        .listRowBackground(Color.black)
                                    }
                                } else {
                                    Section(header:
                                        Text(genre)
                                            .font(.custom("Barlow-SemiBold", size: 13))
                                            .foregroundColor(Color(hex: 0xFE365E))
                                            .padding(.top, 0)
                                    ){
                                        ForEach(self.works.filter({$0.genre == genre}), id: \.id) { work in
                                            WorkRow(work: work, composer: self.composer)
                                        }
                                        .listRowBackground(Color.black)
                                    }
                                }
                            }
                        } else if self.hasEssential {
                            ForEach(["1", "0"], id: \.self) { rec in
                                if #available(iOS 14.0, *) {
                                    Section(header:
                                        Text(rec == "1" ? "Essential" : "Other works")
                                            .font(.custom("Barlow-SemiBold", size: 13))
                                            .foregroundColor(Color(hex: 0xFE365E))
                                            .padding(.top, 0)
                                            .textCase(.none)
                                    ){
                                        ForEach(self.works.filter({$0.recommended == rec}), id: \.id) { work in
                                            WorkRow(work: work, composer: self.composer)
                                        }
                                        .listRowBackground(Color.black)
                                    }
                                } else {
                                    Section(header:
                                        Text(rec == "1" ? "Essential" : "Other works")
                                            .font(.custom("Barlow-SemiBold", size: 13))
                                            .foregroundColor(Color(hex: 0xFE365E))
                                            .padding(.top, 0)
                                    ){
                                        ForEach(self.works.filter({$0.recommended == rec}), id: \.id) { work in
                                            WorkRow(work: work, composer: self.composer)
                                        }
                                        .listRowBackground(Color.black)
                                    }
                                }
                            }
                        } else {
                            ForEach(self.works, id: \.id) { work in
                                WorkRow(work: work, composer: self.composer)
                            }
                            .listRowBackground(Color.black)
                        }
                    }
                    .opacity(self.loading ? 0.0 : 1.0)
                }
                .listStyle(GroupedListStyle())
                
                FullLoader()
                    .opacity(self.loading || self.search.composerId != self.composer.id || self.search.genreName == "" ? 1.0 : 0.0)
                    .padding(.top, self.loading ? 80 : 0)
            }
        }
        .onAppear(perform: {
            if self.isSearch { self.settingStore.recentSearches = MarkSearched(allSearches: self.settingStore.recentSearches, recentSearch: RecentSearch (composer: self.composer)) }
            
            self.endEditing(true)
            if self.loading {
                self.loadData()
            }
        })
        .onReceive(search.objectWillChange, perform: loadData)
        .onReceive(settingStore.composersFavoriteWorksDidChange, perform: loadData)
    }
}

struct ComposerDetail_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
