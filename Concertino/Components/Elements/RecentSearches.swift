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
        VStack(alignment: .leading) {
            Text ("Recent Searches".uppercased())
                .foregroundColor(Color(hex: 0x717171))
                .font(.custom("Nunito", size: 12))
                .padding(.top, 12)
        
            ForEach(self.settingStore.recentSearches, id: \.id) { search in
                HStack {
                    if search.composer != nil {
                        NavigationLink(destination: ComposerDetail(composer: search.composer!, isSearch: false).environmentObject(self.settingStore).environmentObject(self.AppState).environmentObject(self.search)) {
                             MiniComposerRow(composer: search.composer!)
                                .frame(minWidth: 125, maxWidth: .infinity)
                                .background(Color(hex: 0x202023))
                                .cornerRadius(20)
                         }
                    } else if search.work != nil {
                        if search.work!.composer != nil {
                            NavigationLink(destination: WorkDetail(work: search.work!, composer: search.work!.composer!, isSearch: false).environmentObject(self.settingStore)) {
                                MiniWorkSearchRow(work: search.work!, composer: search.work!.composer!)
                                    .frame(minWidth: 125, maxWidth: .infinity)
                                    .background(Color(hex: 0x202023))
                                    .cornerRadius(20)
                            }
                        }
                    } else if search.recording != nil {
                        NavigationLink(destination: RecordingDetail(workId: search.recording!.work!.id, recordingId: search.recording!.apple_albumid, recordingSet: search.recording!.set, isSheet: false, isSearch: true).environmentObject(self.settingStore).environmentObject(self.AppState).environmentObject(self.playState).environmentObject(self.radioState), label: {
                            MicroRecordingRow(recording: search.recording!)
                                .frame(minWidth: 125, maxWidth: .infinity)
                                .background(Color(hex: 0x202023))
                                .cornerRadius(20)
                        })
                    }
                }
                
            }
        }
    }
}

struct RecentSearches_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
