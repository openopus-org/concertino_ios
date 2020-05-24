//
//  PlaylistButtons.swift
//  Concertino
//
//  Created by Adriano Brandao on 17/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct PlaylistButtons: View {
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var radioState: RadioState
    @EnvironmentObject var mediaBridge: MediaBridge
    @EnvironmentObject var previewBridge: PreviewBridge
    @State var isLoading = false
    @State private var showPlaylistSheet = false
    var recordings: [Recording]
    var playlistId: String
    
    var body: some View {
        HStack(spacing: 6) {
            Button(
                action: {
                    if self.radioState.isActive && self.radioState.playlistId == self.playlistId {
                        self.radioState.isActive = false
                        self.radioState.playlistId = ""
                        self.radioState.nextWorks.removeAll()
                        self.radioState.nextRecordings.removeAll()
                        
                        if self.playState.preview {
                            self.previewBridge.stop()
                            self.previewBridge.setQueueAndPlay(tracks: self.playState.recording.first!.previews!, starttrack: 0, autoplay: false, zeroqueue: false)
                        } else {
                            self.mediaBridge.stop()
                            self.mediaBridge.setQueueAndPlay(tracks: self.playState.recording.first!.apple_tracks!, starttrack: self.playState.recording.first!.apple_tracks!.first!, autoplay: false)
                        }
                    } else {
                        var recs = self.recordings
                        recs.shuffle()
                        
                        self.isLoading = true
                        self.radioState.isActive = true
                        self.radioState.playlistId = self.playlistId
                        self.radioState.nextWorks.removeAll()
                        self.radioState.nextRecordings = recs
                        
                        let rec = self.radioState.nextRecordings.removeFirst()
                        
                        getStoreFront() { countryCode in
                            if let country = countryCode {
                                getRecordingDetail(recording: rec, country: country) { recordingData in
                                    DispatchQueue.main.async {
                                        self.playState.autoplay = true
                                        self.playState.recording = recordingData
                                        self.isLoading = false
                                    }
                                }
                            }
                        }
                    }
                },
                label: {
                    HStack {
                        HStack {
                            Spacer()
                            
                            if self.isLoading {
                                ActivityIndicator(isAnimating: self.isLoading)
                                .configure { $0.color = .white; $0.style = .medium }
                            } else {
                                AnimatedRadioIcon(color: Color(hex: 0xFFFFFF), isAnimated: self.radioState.isActive && self.radioState.playlistId == self.playlistId)
                                    .frame(width: 40, height: 20)
                                    .padding(.trailing, self.radioState.isActive && self.radioState.playlistId == self.playlistId ? 3 : -10)
                                    .padding(.leading, self.radioState.isActive && self.radioState.playlistId == self.playlistId ? 0 : -10)
                                    
                                Text((self.radioState.isActive && self.radioState.playlistId == self.playlistId ? "stop radio" : "start radio").uppercased())
                                    .foregroundColor(.white)
                                    .font(.custom("Nunito", size: self.radioState.isActive && self.radioState.playlistId == self.playlistId ? 11 : 13))
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(13)
                    .foregroundColor(.white)
                    .background(Color(hex: self.radioState.isActive && self.radioState.playlistId == self.playlistId ? 0x696969 : 0xfe365e))
                    .cornerRadius(16)
            })
            .buttonStyle(BorderlessButtonStyle())
            
            if self.playlistId != "fav" && self.playlistId != "recent" {
                Button(
                    action: { self.showPlaylistSheet = true },
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
        .sheet(isPresented: $showPlaylistSheet) {
            EditPlaylist(playlistId: self.playlistId, playlistName: self.settingStore.playlists.filter({$0.id == self.playlistId}).first!.name, recordings: self.recordings).environmentObject(self.settingStore)
        }
    }
}

struct PlaylistButtons_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
