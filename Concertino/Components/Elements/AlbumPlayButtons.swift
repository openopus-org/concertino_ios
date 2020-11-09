//
//  AlbumPlayButton.swift
//  Concertino
//
//  Created by Adriano Brandao on 09/11/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct AlbumPlayButtons: View {
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var radioState: RadioState
    @EnvironmentObject var mediaBridge: MediaBridge
    @EnvironmentObject var previewBridge: PreviewBridge
    @State var isLoading = false
    @State private var showPlaylistSheet = false
    var album: Album
    var recordings: [Recording]
    
    var body: some View {
        HStack {
            Button(
                action: {
                    if self.radioState.isActive && self.radioState.playlistId == "album-\(self.album.apple_albumid)" {
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
                        self.isLoading = true
                        self.radioState.isActive = true
                        self.radioState.playlistId = "album-\(self.album.apple_albumid)"
                        self.radioState.nextWorks.removeAll()
                        self.radioState.nextRecordings = self.recordings
                        
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
                            } else if self.radioState.isActive && self.radioState.playlistId == "album-\(self.album.apple_albumid)" {
                                AnimatedRadioIcon(color: Color(hex: 0xFFFFFF), isAnimated: true)
                                    .frame(width: 40, height: 20)
                                    .padding(.trailing, 3)
                                    .padding(.leading, 0)
                                    
                                Text(("stop radio").uppercased())
                                    .foregroundColor(.white)
                                    .font(.custom("Nunito-Regular", size: self.radioState.isActive && self.radioState.playlistId == "album-\(self.album.apple_albumid)" ? 11 : 12))
                            } else {
                                Image("play")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 20)
                                Text("play album".uppercased())
                                    .font(.custom("Nunito-Regular", size: 14))
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(13)
                    .foregroundColor(.white)
                    .background(Color(hex: self.radioState.isActive && self.radioState.playlistId == "album-\(self.album.apple_albumid)" ? 0x696969 : 0xfe365e))
                    .cornerRadius(16)
            })
            
            Button(
                action: { UIApplication.shared.open(URL(string: AppConstants.appleLink.replacingOccurrences(of: "%%COUNTRY%%", with: self.settingStore.country.isEmpty ? "us" : self.settingStore.country) + album.apple_albumid)!) },
                label: {
                    HStack {
                        Spacer()
                        Image("applemusic")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                        Spacer()
                    }
                    .padding(14)
                    .background(Color(hex: 0x2B2B2F))
                    .cornerRadius(16)
            })
        }
    }
}

struct AlbumPlayButtons_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
