//
//  PlaylistsRecordings.swift
//  Concertino
//
//  Created by Adriano Brandao on 04/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct PlaylistsRecordings: View {
    @Binding var playlistSwitcher: PlaylistSwitcher
    @State private var loading = true
    @State private var recordings = [Recording]()
    @EnvironmentObject var settingStore: SettingStore
    
    func loadData() {
        self.recordings.removeAll()
        loading = true
        var url = ""
        
        switch playlistSwitcher.playlist {
            case "fav":
                url = AppConstants.concBackend+"/user/\(self.settingStore.userId)/recording/fav.json"
            case "recent":
                url = AppConstants.concBackend+"/user/\(self.settingStore.userId)/recording/recent.json"
            default:
                url = AppConstants.concBackend+"/recording/\(self.settingStore.country.isEmpty ? "" : self.settingStore.country+"/" )list/playlist/\(self.playlistSwitcher.playlist).json"
        }
        
        APIget(url) { results in
            let recsData: PlaylistRecordings = parseJSON(results)
            
            DispatchQueue.main.async {
                
                if let recds = recsData.recordings {
                    self.recordings = recds
                }
                else {
                    self.recordings = [Recording]()
                }
                
                self.loading = false
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if self.recordings.count > 0 {
                List {
                    PlaylistButtons(recordings: self.recordings, playlistId: playlistSwitcher.playlist)
                    ForEach(self.recordings, id: \.id) { recording in
                        NavigationLink(destination: RecordingDetail(workId: recording.work!.id, recordingId: recording.apple_albumid, recordingSet: recording.set, isSheet: false), label: {
                            RecordingRow(recording: recording)
                        })
                    }
                }
                .listStyle(DefaultListStyle())
            }
            else {
                
                VStack {
                    if (loading) {
                        ActivityIndicator(isAnimating: loading)
                            .configure { $0.color = .white; $0.style = .large }
                    } else {
                        ErrorMessage(msg: "No recordings found.")
                    }
                }
                .padding(.top, 40)
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .onReceive(playlistSwitcher.objectWillChange, perform: loadData)
        .onReceive(settingStore.playlistsDidChange, perform: loadData)
        .onReceive(settingStore.playedRecordingDidChange, perform: {
            if self.playlistSwitcher.playlist == "recent" {
                self.loadData()
            }
        })
        .onReceive(settingStore.recordingsDidChange, perform: {
            if self.playlistSwitcher.playlist == "fav" {
                self.loadData()
            }
        })
        .onAppear(perform: {
            self.endEditing(true)
            
            if self.recordings.count == 0 {
                self.loadData()
            }
        })
    }
}

struct PlaylistsRecordings_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
