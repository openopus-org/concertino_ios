//
//  ComposerWorkSearch.swift
//  Concertino
//
//  Created by Adriano Brandao on 01/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct ComposersWorksSearch: View {
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var omnisearch: OmnisearchString
    @EnvironmentObject var search: WorkSearch
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var radioState: RadioState
    @State private var results = [Recording]()
    @State private var offset = 0
    @State private var loading = true
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    func loadData() {
        loading = true
        
        if self.omnisearch.searchstring.count > 3 {
            getStoreFront() { countryCode in
                APIget(AppConstants.concBackend+"/omnisearch/\(countryCode ?? "us")/\(self.omnisearch.searchstring)/\(self.offset).json") { results in
                    let omniData: Omnisearch = parseJSON(results)
                    
                    DispatchQueue.main.async {
                        if let recordings = omniData.recordings {
                            self.results.removeAll()
                            self.results = recordings
                            self.loading = false
                        } else {
                            self.results = [Recording]()
                        }
                    }
                }
            }
        }
        else {
            DispatchQueue.main.async {
                self.results = [Recording]()
                self.loading = false
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            List(self.results, id: \.id) { recording in
                        NavigationLink(destination: RecordingDetail(workId: recording.work!.id, recordingId: recording.apple_albumid, recordingSet: recording.set, isSheet: false).environmentObject(self.settingStore).environmentObject(self.AppState).environmentObject(self.playState).environmentObject(self.radioState), label: {
                            RecordingRow(recording: recording)
                        })
                    }
                    .gesture(DragGesture().onChanged{_ in self.endEditing(true) })
                    
        
        }
        .onReceive(omnisearch.objectWillChange, perform: loadData)
        .onAppear(perform: {
            self.endEditing(true)
        })
        .frame(maxWidth: .infinity)
    }
}

struct ComposersWorksSearch_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
