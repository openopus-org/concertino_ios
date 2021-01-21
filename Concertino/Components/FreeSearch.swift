//
//  ComposerWorkSearch.swift
//  Concertino
//
//  Created by Adriano Brandao on 01/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct FreeSearch: View {
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var omnisearch: OmnisearchString
    @EnvironmentObject var search: WorkSearch
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var radioState: RadioState
    @State private var composers = [Composer]()
    @State private var works = [Work]()
    @State private var recordings = [Recording]()
    @State private var trendingRecordings = [Recording]()
    @State private var offset = 0
    @State private var loading = true
    @State private var canPaginate = true
    @State private var paginating = false
    @State private var isEditing = false
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    func loadTrendingData() {
        self.recordings.removeAll()
        
        APIget(AppConstants.concBackend+"/recording/list/trending.json") { results in
            if let recsData: PlaylistRecordings = safeJSON(results) {
                DispatchQueue.main.async {
                    if let recds = recsData.recordings {
                        self.trendingRecordings = recds
                    }
                    else {
                        self.trendingRecordings = [Recording]()
                    }
                }
            }
        }
    }
    
    func loadMoreData() {
        paginating = true
        
        getStoreFront() { countryCode in
            APIget(AppConstants.concBackend+"/search/\(countryCode ?? "us")/\(self.omnisearch.searchstring)/\(self.offset).json") { results in
                if let omniData: Omnisearch = safeJSON(results) {
                    DispatchQueue.main.async {
                        if let recordings = omniData.recordings {
                            
                            for rec in recordings {
                                if !self.recordings.contains(rec) {
                                    self.recordings.append(rec)
                                }
                            }
                            
                            if let next = omniData.next {
                                self.offset = next
                            } else {
                                self.canPaginate = false
                            }
                            
                            self.paginating = false
                        } else {
                            self.paginating = false
                            self.canPaginate = false
                        }
                    }
                }
            }
        }
    }
    
    func loadData() {
        loading = true
        offset = 0
        canPaginate = true
        
        if self.omnisearch.searchstring.count > 3 {
            getStoreFront() { countryCode in
                APIget(AppConstants.concBackend+"/search/\(countryCode ?? "us")/\(self.omnisearch.searchstring)/\(self.offset).json") { results in
                    if let omniData: Omnisearch = safeJSON(results) {
                        DispatchQueue.main.async {
                            if let recordings = omniData.recordings {
                                if let next = omniData.next {
                                    self.offset = next
                                } else {
                                    self.canPaginate = false
                                }
                                
                                self.recordings.removeAll()
                                self.recordings = recordings
                                self.loading = false
                            } else {
                                self.recordings = [Recording]()
                            }
                                        
                            if let composers = omniData.composers {
                                self.composers.removeAll()
                                self.composers = composers
                                self.loading = false
                            } else {
                                self.composers = [Composer]()
                            }
                            
                            if let works = omniData.works {
                                self.works.removeAll()
                                self.works = works
                                self.loading = false
                            } else {
                                self.works = [Work]()
                            }
                                    
                            
                            if let composers = omniData.composers {
                                self.composers.removeAll()
                                self.composers = composers
                                self.loading = false
                            } else {
                                self.composers = [Composer]()
                            }
                            
                            if let works = omniData.works {
                                self.works.removeAll()
                                self.works = works
                                self.loading = false
                            } else {
                                self.works = [Work]()
                            }
                        }
                    }
                }
            }
        }
        else {
            DispatchQueue.main.async {
                self.recordings = [Recording]()
                self.works = [Work]()
                self.composers = [Composer]()
                self.loading = false
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if self.omnisearch.searchstring != "" {
                if self.loading {
                    HStack {
                        Spacer()
                        ActivityIndicator(isAnimating: true)
                        .configure { $0.color = .white; $0.style = .large }
                        Spacer()
                    }
                    .padding(40)
                }
                else {
                    if self.composers.count == 0 && self.works.count == 0 && self.recordings.count == 0 {
                        ErrorMessage(msg: (self.omnisearch.searchstring.count > 3 ? "No matches for: \(self.omnisearch.searchstring)" : "Search term too short"))
                    } else {
                        List {
                            Group {
                                if self.composers.count > 0 {
                                    Section(header:
                                        Text("Composers".uppercased())
                                            
                                            .foregroundColor(Color.gray)
                                            .font(.custom("Nunito-Regular", size: 12))
                                    ){
                                        ForEach(self.composers, id: \.id) { composer in
                                            Group {
                                                NavigationLink(destination: ComposerDetail(composer: composer, isSearch: true).environmentObject(self.settingStore).environmentObject(self.AppState).environmentObject(self.search)) {
                                                    ComposerRow(composer: composer)
                                                }
                                            }
                                        }
                                        .listRowBackground(Color.black)
                                    }
                                }
                            }
                            
                            Group {
                                if self.works.count > 0 {
                                    Section(header:
                                        Text("Works".uppercased())
                                            
                                            .foregroundColor(Color.gray)
                                            .font(.custom("Nunito-Regular", size: 12))
                                    ){
                                        ForEach(self.works, id: \.id) { work in
                                            NavigationLink(destination: WorkDetail(work: work, composer: work.composer!, isSearch: true).environmentObject(self.settingStore)) {
                                                WorkSearchRow(work: work, composer: work.composer!)
                                                    .padding(.top, 6)
                                                    .padding(.bottom, 6)
                                            }
                                        }
                                        .listRowBackground(Color.black)
                                    }
                                }
                            }
                            
                            Group {
                                if self.recordings.count > 0 {
                                    Section(header:
                                        Text("Recordings".uppercased())
                                            
                                            .foregroundColor(Color.gray)
                                            .font(.custom("Nunito-Regular", size: 12))
                                    ){
                                        ForEach(self.recordings, id: \.id) { recording in
                                            Group {
                                                if !recording.isCompilation || !self.settingStore.hideIncomplete {
                                                    NavigationLink(destination: RecordingDetail(workId: recording.work!.id, recordingId: recording.apple_albumid, recordingSet: recording.set, isSheet: false, isSearch: true).environmentObject(self.settingStore).environmentObject(self.AppState).environmentObject(self.playState).environmentObject(self.radioState), label: {
                                                        RecordingRow(recording: recording)
                                                    })
                                                }
                                            }
                                        }
                                        .listRowBackground(Color.black)
                                        
                                        if canPaginate {
                                            HStack {
                                                Spacer()
                                                if self.paginating {
                                                    ActivityIndicator(isAnimating: true)
                                                        .configure { $0.color = .white; $0.style = .large }
                                                }
                                                Spacer()
                                            }
                                            .listRowBackground(Color.black)
                                            .padding(40)
                                            .onAppear() {
                                                self.loadMoreData()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .listStyle(GroupedListStyle())
                        .gesture(DragGesture().onChanged{_ in self.endEditing(true) })
                    }
                }
            } else if !self.isEditing {
                List {
                    if self.settingStore.recentSearches.count > 0 {
                        Section(header:
                            Text("Recent searches".uppercased())
                                .font(.custom("Nunito-ExtraBold", size: 13))
                                .foregroundColor(Color(hex: 0xfe365e))
                                .padding(.top, 10)
                        ){
                            RecentSearches()
                        }
                    }
                    
                    Section(header:
                        Text("Trending recordings".uppercased())
                            .font(.custom("Nunito-ExtraBold", size: 13))
                            .foregroundColor(Color(hex: 0xfe365e))
                    ){
                        ForEach(self.trendingRecordings, id: \.id) { recording in
                            HStack(alignment: .top) {
                                VStack {
                                    Text("\(recording.position ?? 0)")
                                        .font(.custom("Barlow-Regular", size: 15))
                                        .foregroundColor(Color(hex: 0xffffff))
                                }
                                .frame(width: 36, height: 36)
                                .background(Color(hex: 0xfe365e))
                                .clipped()
                                .clipShape(Circle())
                                .padding(.top, 14)
                                .padding(.trailing, 10)
                                
                                NavigationLink(destination: RecordingDetail(workId: recording.work!.id, recordingId: recording.apple_albumid, recordingSet: recording.set, isSheet: false, isSearch: true).environmentObject(self.settingStore).environmentObject(self.AppState).environmentObject(self.playState).environmentObject(self.radioState), label: {
                                    MicroRecordingRow(recording: recording)
                                })
                                
                                Spacer()
                            }
                            
                        }
                        .listRowBackground(Color.black)
                    }
                }
                .listStyle(GroupedListStyle())
                .gesture(DragGesture().onChanged{_ in self.endEditing(true) })
            }
        }
        .onReceive(omnisearch.objectWillChange, perform: loadData)
        .onReceive(omnisearch.editingFocusChanged, perform: {
            self.isEditing = self.omnisearch.isEditing
        })
        .onAppear(perform: {
            self.endEditing(true)
            
            if self.trendingRecordings.count == 0 {
                self.loadTrendingData()
            }
        })
        .frame(maxWidth: .infinity)
    }
}

struct FreeSearch_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}

