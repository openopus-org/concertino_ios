//
//  PlaylistButtons.swift
//  Concertino
//
//  Created by Adriano Brandao on 17/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct PlaylistButtons: View {
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var radioState: RadioState
    var recordings: [Recording]
    var playlistId: String
    
    var body: some View {
        HStack(spacing: 6) {
            Button(
                action: {
                    var recs = self.recordings
                    recs.shuffle()
                    
                    self.radioState.isActive = true
                    self.radioState.playlistId = self.playlistId
                    self.radioState.nextWorks.removeAll()
                    self.radioState.nextRecordings = recs
                    
                    let rec = self.radioState.nextRecordings.removeFirst()
                    
                    getRecordingDetail(recording: rec, country: self.settingStore.country) { recordingData in
                        DispatchQueue.main.async {
                            self.playState.autoplay = true
                            self.playState.recording = recordingData
                        }
                    }
                },
                label: {
                    HStack {
                        HStack {
                            Spacer()
                            
                            Image("radio")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 18)
                                .foregroundColor(.white)
                                .padding(.trailing, 3)
                            
                            Text("start radio".uppercased())
                                .foregroundColor(.white)
                                .font(.custom("Nunito", size: 13))
                            
                            Spacer()
                        }
                    }
                    .padding(13)
                    .foregroundColor(.white)
                    .background(Color(hex: 0xfe365e))
                    .cornerRadius(16)
            })
            .buttonStyle(BorderlessButtonStyle())
            
            if self.playlistId != "fav" && self.playlistId != "recent" {
                Button(
                    action: {  },
                    label: {
                        HStack {
                            HStack {
                                Spacer()
                                
                                Image("edit")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 12)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 2)
                                
                                Text("edit playlist".uppercased())
                                    .foregroundColor(.white)
                                    .font(.custom("Nunito", size: 12))
                                
                                Spacer()
                            }
                        }
                        .padding(15)
                        .foregroundColor(.white)
                        .background(Color(hex: 0x2B2B2F))
                        .cornerRadius(16)
                })
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .padding(.bottom, 10)
        .padding(.top, 10)
    }
}

struct PlaylistButtons_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
