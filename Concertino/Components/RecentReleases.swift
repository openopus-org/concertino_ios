//
//  RecentReleases.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct RecentReleases: View {
    @State private var loading = true
    @State private var recordings = [Recording]()
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var appState: AppState
    
    func loadData() {
        self.recordings.removeAll()
        loading = true
        
        APIget(AppConstants.concBackend+"/recording/list/recent.json") { results in
            let recsData: PlaylistRecordings = parseJSON(results)
            
            DispatchQueue.main.async {
                
                if let recds = recsData.recordings {
                    var recods = recds
                    recods.shuffle()
                    self.recordings = Array(recods.prefix(10))
                }
                else {
                    self.recordings = [Recording]()
                }
                
                self.loading = false
                
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) {_ in 
                    self.appState.isLoading = false
                }
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recent releases".uppercased())
                .foregroundColor(Color(hex: 0x717171))
                .font(.custom("Nunito", size: 12))
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 14) {
                    ForEach(self.recordings, id: \.id) { recording in
                        NavigationLink(destination: RecordingDetail(workId: recording.work!.id, recordingId: recording.apple_albumid, recordingSet: recording.set, isSheet: false), label: {
                            RecordingBox(recording: recording)
                        })
                    }
                }
                .frame(minHeight: 270)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
        }
        .onAppear(perform: {
            if self.recordings.count == 0 {
                print("🆗 recent releases loaded from appearance")
                self.loadData()
            }
        })
    }
}

struct RecentReleases_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
