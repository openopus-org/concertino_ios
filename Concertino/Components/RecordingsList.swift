//
//  RecordingsList.swift
//  Concertino
//
//  Created by Adriano Brandao on 14/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct RecordingsList: View {
    var work: Work
    @State private var loading = true
    @State private var page = "0"
    @State private var nextpage = "0"
    @State private var recordings = [Recording]()
    @ObservedObject var workSearch = WorkSearchString()
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var radioState: RadioState
    
    init(work: Work) {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        self.work = work
    }
    
    func loadData() {
        loading = true
        
        APIget(AppConstants.concBackend+"/recording/" + (self.settingStore.country != "" ? self.settingStore.country + "/" : "") + "list/work/\(self.work.id)/\(self.workSearch.string)/\(self.page).json") { results in
            if let recsData: Recordings = safeJSON(results) {
                DispatchQueue.main.async {
                    if let recds = recsData.recordings {
                        for rec in recds {
                            if !self.recordings.contains(rec) {
                                self.recordings.append(rec)
                            }
                        }
                    }
                    else {
                        self.recordings += [Recording]()
                    }
                    
                    if let nextpg = recsData.next {
                        self.nextpage = nextpg
                    }
                    else {
                        self.nextpage = "0"
                    }
                    
                    self.loading = false
                }
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section(header:
                    WorkSearchField(workSearch: self.$workSearch.string)
                        .padding(.bottom, -20)
                    //.padding(.leading, 14)
                    //.padding(.trailing, 14)
                ){
                    EmptyView()
                }
                .listRowBackground(Color.black)
                
                ForEach(self.recordings, id: \.id) { recording in
                    Group {
                        if !recording.isCompilation || !self.settingStore.hideIncomplete {
                            NavigationLink(destination: RecordingDetail(workId: self.work.id, recordingId: recording.apple_albumid, recordingSet: recording.set, isSheet: false, isSearch: false).environmentObject(self.settingStore).environmentObject(self.AppState).environmentObject(self.playState).environmentObject(self.radioState), label: {
                                RecordingRow(recording: recording)
                            })
                        }
                    }
                }
                .listRowBackground(Color.black)
                
                HStack {
                    Spacer()
                    if (loading) {
                        ActivityIndicator(isAnimating: loading)
                            .configure { $0.color = .white; $0.style = .large }
                    } else if self.recordings.count > 0 {
                        RecordingsDisclaimer(msg: "Those recordings were fetched automatically from the Apple Music catalog. The list might be inaccurate or incomplete. Please reach us for requests, questions or suggestions.")
                    } else {
                        ErrorMessage(msg: "Concertino couldn't find any recording of this work in the Apple Music catalog. It might be an error, though. Please reach us if you know a recording. This will help us correct our algorithm.")
                    }
                    Spacer()
                }
                .listRowBackground(Color.black)
                .padding(40)
                .onAppear() {
                    if (self.nextpage != "0") {
                        self.page = self.nextpage
                        self.loadData()
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .gesture(DragGesture().onChanged{_ in self.endEditing(true) })
        }
        .frame(maxWidth: .infinity)
        .onAppear(perform: {
            self.endEditing(true)
            
            if self.recordings.count == 0 {
                self.loadData()
            }
        })
        .onReceive(workSearch.workSearchWillChange, perform: {
            self.page = "0"
            self.nextpage = "0"
            self.recordings = [Recording]()
            self.loadData()
        })
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
