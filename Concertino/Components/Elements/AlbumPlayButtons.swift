//
//  AlbumPlayButtons.swift
//  Concertino
//
//  Created by Adriano Brandao on 25/10/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct AlbumPlayButtons: View {
    var album: Album
    
    @State private var isPlaying = true
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var radioState: RadioState
    @EnvironmentObject var settingStore: SettingStore
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack(spacing: 6) {
            if self.playState.recording.count > 0 && false {
                Button(
                    action: {
                        self.AppState.fullPlayer = true
                    },
                    label: {
                        HStack {
                            HStack {
                                Spacer()
                                if self.isPlaying {
                                    DotsAnimation()
                                        .padding(.trailing, 3)
                                    Text("playing".uppercased())
                                        .font(.custom("Nunito-Regular", size: 11))
                                }
                                else {
                                    Image("handle")
                                        .resizable()
                                        .frame(width: 6, height: 12)
                                        .foregroundColor(Color(hex: 0x696969))
                                        .rotationEffect(.degrees(90))
                                        .padding(.trailing, 6)
                                    Text("in the player".uppercased())
                                        .foregroundColor(Color(hex: 0x696969))
                                        .font(.custom("Nunito-Regular", size: 10))
                                }
                                Spacer()
                            }
                        }
                        .padding(15)
                        .foregroundColor(.white)
                        .background(Color(hex: 0x4F4F4F))
                        .cornerRadius(16)
                })
            } else {
                Button(
                    action: {
                        self.playState.autoplay = true
                        self.radioState.isActive = false
                        self.radioState.playlistId = ""
                        self.radioState.nextWorks.removeAll()
                        self.radioState.nextRecordings.removeAll()
                    },
                    label: {
                        HStack {
                            HStack {
                                Spacer()
                                Image("play")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 20)
                                Text("play album".uppercased())
                                    .font(.custom("Nunito-Regular", size: 14))
                                Spacer()
                            }
                        }
                        .padding(14)
                        .foregroundColor(.white)
                        .background(Color(hex: 0xfe365e))
                        .cornerRadius(16)
                })
            }
            
            
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
        .onAppear(perform: { self.isPlaying = self.playState.playing })
        .onReceive(self.playState.playingstateWillChange, perform: { self.isPlaying = self.playState.playing })
    }
}

struct AlbumPlayButtons_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
