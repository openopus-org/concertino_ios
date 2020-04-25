//
//  RecordingPlaybackControl.swift
//  Concertino
//
//  Created by Adriano Brandao on 24/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct RecordingPlaybackControl: View {
    @Binding var currentTrack: [CurrentTrack]
    @EnvironmentObject var mediaBridge: MediaBridge
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var radioState: RadioState
    @EnvironmentObject var playState: PlayState
    
    var body: some View {
        Group {
            if self.currentTrack.count > 0 {
                if self.currentTrack.first!.loading {
                    HStack {
                        Spacer()
                        ActivityIndicator(isAnimating: true)
                            .configure { $0.color = Color(hex: 0xfe365e).uiColor(); $0.style = .large }
                        Spacer()
                    }
                }
                else {
                    HStack {
                        Spacer()
                        
                        AirPlayButton()
                            .frame(width: 50)
                            .frame(height: 50)
                            .padding(.leading, -8)
                            .padding(.trailing, 10)
                        
                        /*
                        Spacer()
                            .frame(width: 36)
                            .padding(.trailing, 22)
                        */
                        
                        Button(
                            action: {
                                if self.currentTrack.first!.track_index == 0 {
                                    self.mediaBridge.skipToBeginning()
                                } else {
                                    self.mediaBridge.previousTrack()
                                }
                            },
                            label: {
                                Image("skiptrack")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 24)
                                .foregroundColor(Color(hex: 0xfe365e))
                                .rotationEffect(.degrees(180))
                            })
                        
                        Button(
                            action: { self.mediaBridge.togglePlay() },
                            label: {
                                Image(self.currentTrack.first!.playing ? "pause" : "play")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 58)
                                .foregroundColor(Color(hex: 0xfe365e))
                                .padding(.leading, 32)
                                .padding(.trailing, 32)
                            })
                        
                        Button(
                            action: {
                                self.mediaBridge.nextTrack()
                            },
                            label: {
                                Image("skiptrack")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 24)
                                .foregroundColor(Color(hex: 0xfe365e))
                            })
                        
                        Button(
                            action: {
                                if self.radioState.isActive && self.radioState.canSkip  {
                                    if self.radioState.nextRecordings.count > 0 {
                                        self.mediaBridge.stop()
                                        self.playState.autoplay = true
                                        self.currentTrack[0].track_position = 0
                                        self.playState.recording = [self.radioState.nextRecordings.removeFirst()]
                                    } else if self.radioState.isActive {
                                        self.radioState.isActive = false
                                    }
                                }
                            },
                            label: {
                                Image("skipradio")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 18)
                                    .foregroundColor(Color(hex: self.radioState.isActive && self.radioState.canSkip ? 0xfe365e : 0x424242))
                                .padding(.leading, 22)
                            })

                        
                        Spacer()
                    }
                }
            }
            else {
                if self.settingStore.userId > 0 || self.settingStore.firstUsage {
                    //RecordingNotAvailable(size: "max")
                    HStack {
                        Spacer()
                        ActivityIndicator(isAnimating: true)
                            .configure { $0.color = Color(hex: 0xfe365e).uiColor(); $0.style = .large }
                        Spacer()
                    }
                }
                else {
                    BrowseOnlyMode(size: "max")
                }
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 32)
    }
}

struct RecordingPlaybackControl_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
