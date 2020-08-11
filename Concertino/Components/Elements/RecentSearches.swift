//
//  RecentSearches.swift
//  Concertino
//
//  Created by Adriano Brandao on 26/07/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct RecentSearches: View {
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var search: WorkSearch
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var radioState: RadioState
    
    var body: some View {
        Group {
            ForEach(self.settingStore.recentSearches, id: \.id) { search in
                HStack {
                    if search.composer != nil {
                        NavigationLink(destination: ComposerDetail(composer: search.composer!, isSearch: false).environmentObject(self.settingStore).environmentObject(self.AppState).environmentObject(self.search)) {
                             MiniComposerRow(composer: search.composer!)
                                
                         }
                    } else if search.work != nil {
                        if search.work!.composer != nil {
                            NavigationLink(destination: WorkDetail(work: search.work!, composer: search.work!.composer!, isSearch: false).environmentObject(self.settingStore)) {
                                MiniWorkSearchRow(work: search.work!, composer: search.work!.composer!)
                                    
                            }
                        }
                    } else if search.recording != nil {
                        NavigationLink(destination: RecordingDetail(workId: search.recording!.work!.id, recordingId: search.recording!.apple_albumid, recordingSet: search.recording!.set, isSheet: false, isSearch: false).environmentObject(self.settingStore).environmentObject(self.AppState).environmentObject(self.playState).environmentObject(self.radioState), label: {
                            MicroRecordingRow(recording: search.recording!)
                                
                        })
                    }
                }
                
            }
            .listRowBackground(Color.black)
        }
    }
}

struct RecentSearches_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
