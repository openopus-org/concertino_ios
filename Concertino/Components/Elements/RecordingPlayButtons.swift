//
//  RecordingPlayButtons.swift
//  Concertino
//
//  Created by Adriano Brandao on 17/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct RecordingPlayButtons: View {
    var recording: Recording
    var isSheet: Bool
    @State private var isPlaying = true
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var radioState: RadioState
    @EnvironmentObject var settingStore: SettingStore
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack(spacing: 6) {
            if self.playState.recording.count > 0 && self.playState.recording.first!.apple_albumid == self.recording.apple_albumid && self.playState.recording.first!.work!.id == self.recording.work!.id && self.playState.recording.first!.set == self.recording.set {
                Button(
                    action: {
                        self.AppState.fullPlayer = true
                        if self.isSheet {
                            self.AppState.externalUrl = [String]()
                        }
                    },
                    label: {
                        HStack {
                            HStack {
                                Spacer()
                                if self.isPlaying {
                                    DotsAnimation()
                                        .padding(.trailing, 3)
                                    Text("playing".uppercased())
                                        .font(.custom("Nunito", size: 11))
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
                                        .font(.custom("Nunito", size: 10))
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
                        self.playState.recording = [self.recording]
                        if self.isSheet {
                            self.AppState.externalUrl = [String]()
                        }
                    },
                    label: {
                        HStack {
                            HStack {
                                Spacer()
                                Image("play")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 20)
                                Text("play".uppercased())
                                    .font(.custom("Nunito", size: 14))
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
                action: { UIApplication.shared.open(URL(string: AppConstants.appleLink.replacingOccurrences(of: "%%COUNTRY%%", with: self.settingStore.country.isEmpty ? "us" : self.settingStore.country) + self.recording.apple_albumid)!) },
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

struct RecordingPlayButtons_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
