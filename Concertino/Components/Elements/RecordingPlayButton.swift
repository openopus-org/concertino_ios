//
//  RecordingPlayButtons.swift
//  Concertino
//
//  Created by Adriano Brandao on 17/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct RecordingPlayButton: View {
    var recording: FullRecording
    @State private var isPlaying = true
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var radioState: RadioState
    @EnvironmentObject var settingStore: SettingStore
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack(spacing: 6) {
            if self.playState.recording.count > 0 && self.playState.recording.first!.apple_albumid == self.recording.recording.apple_albumid && self.playState.recording.first!.work!.id == self.recording.work.id && self.playState.recording.first!.set == self.recording.recording.set {
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
                                        .frame(width: 10)
                                }
                                else {
                                    Image("handle")
                                        .resizable()
                                        .frame(width: 12, height: 24)
                                        .foregroundColor(Color(hex: 0x696969))
                                        .rotationEffect(.degrees(90))
                                        //.padding(.leading, 3)
                                        .padding(.top, 3)
                                }
                                Spacer()
                            }
                        }
                        .frame(width: 33, height: 33)
                        .foregroundColor(.white)
                        .background(Color(hex: 0x4F4F4F))
                        .clipped()
                        .clipShape(Circle())
                })
            } else {
                Button(
                    action: {
                        self.playState.autoplay = true
                        self.radioState.isActive = false
                        self.radioState.playlistId = ""
                        self.radioState.nextWorks.removeAll()
                        self.radioState.nextRecordings.removeAll()
                        
                        var gorecording = self.recording.recording
                        gorecording.work = self.recording.work
                        
                        self.playState.recording = [gorecording]
                    },
                    label: {
                        HStack {
                            HStack {
                                Spacer()
                                Image("play")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 24)
                                    .padding(.leading, 3)
                                Spacer()
                            }
                        }
                        .frame(width: 33, height: 33)
                        .foregroundColor(.white)
                        .background(Color(hex: 0xfe365e))
                        .clipped()
                        .clipShape(Circle())
                })
            }
        }
        .onAppear(perform: { self.isPlaying = self.playState.playing })
        .onReceive(self.playState.playingstateWillChange, perform: { self.isPlaying = self.playState.playing })
    }
}

struct RecordingPlayButton_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
