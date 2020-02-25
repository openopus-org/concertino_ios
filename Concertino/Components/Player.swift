//
//  Player.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/01/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import StoreKit

struct Player: View {
    @State private var fullPlayer = false
    @State private var currentTrack = [CurrentTrack]()
    @EnvironmentObject var mediaBridge: MediaBridge
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var timerHolder: TimerHolder
    
    func playMusic() {
        if self.currentTrack.count > 0 {
            self.mediaBridge.stop()
            self.currentTrack[0].loading = true
        }
        
        SKCloudServiceController.requestAuthorization { status in
            if (SKCloudServiceController.authorizationStatus() == .authorized)
            {
                // user authorized app access to music
                
                let controller = SKCloudServiceController()
                controller.requestCapabilities { capabilities, error in
                    if capabilities.contains(.musicCatalogPlayback) {
                        
                        // user has an active apple music account
                        
                        DispatchQueue.main.async {
                            if let tracks = self.playState.recording.first!.recording.apple_tracks {
                                self.currentTrack = [CurrentTrack (
                                    track_index: 0,
                                    playing: false,
                                    loading: true,
                                    starting_point: 0,
                                    track_position: 0,
                                    track_length: (self.playState.recording.first!.recording.tracks!.first?.length)!,
                                    full_position: 0,
                                    full_length: self.playState.recording.first!.recording.length!
                                )]
                                self.mediaBridge.setQueueAndPlay(tracks: tracks, starttrack: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(gradient: Gradient(colors: [Color(hex: 0x4F4F4F), Color(hex: 0x2B2B2F)]), startPoint: .top, endPoint: .bottom)
                .frame(minHeight: 130, maxHeight: self.fullPlayer ? .infinity : 130)
                .cornerRadius(25)
            
            VStack {
                Button(
                    action: { self.fullPlayer.toggle() },
                    label: {
                        Image("handle")
                            .resizable()
                            .frame(width: 7, height: 32)
                            .foregroundColor(Color(hex: 0x696969))
                            .rotationEffect(.degrees(self.fullPlayer ? 90 : 270))
                    })
                    .frame(height: 7)
                    .padding(.top, (fullPlayer ? 14 : 10))
                
                if (playState.recording.count > 0) {
                    if fullPlayer {
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading) {
                                RecordingWorkPerformers(recording: playState.recording.first!)
                                    .padding(.bottom, 30)
                                RecordingProgressBars(recording: playState.recording.first!, currentTrack: $currentTrack)
                                
                            }
                            .padding(30)
                            .padding(.top, -16)
                        }
                        .padding(.top, 0)

                        Spacer()
                        
                        RecordingPlaybackControl(currentTrack: $currentTrack)
                    }
                    else {
                        RecordingMini(recording: playState.recording.first!, currentTrack: $currentTrack)
                            .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
                    }
                }
            }
        }
        .padding(EdgeInsets(top: 32, leading: 0, bottom: 46, trailing: 0))
        .clipped()
        .onReceive(playState.objectWillChange, perform: playMusic)
        .onReceive(timerHolder.objectWillChange, perform: {
            if (self.currentTrack.count > 0) {
                self.currentTrack[0].track_position = self.mediaBridge.getCurrentPlaybackTime()
                self.currentTrack[0].full_position = self.currentTrack[0].starting_point + self.currentTrack[0].track_position
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange)) { status in
                if self.currentTrack.count > 0 {
                    if let isPlaying = status.userInfo?["playing"] {
                        self.currentTrack[0].playing = isPlaying as! Bool
                        
                        if (isPlaying as! Bool) {
                            self.timerHolder.start()
                        }
                        else {
                            self.timerHolder.stop()
                        }
                    }
                }
            }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange)) { status in
            if self.currentTrack.count > 0 {
                if let trackIndex = status.userInfo?["index"] {
                    self.currentTrack[0].track_index = trackIndex as! Int
                    self.currentTrack[0].track_position = 0
                    self.currentTrack[0].starting_point = (self.playState.recording.first!.recording.tracks![trackIndex as! Int].starting_point)
                    self.currentTrack[0].full_position = (self.playState.recording.first!.recording.tracks![trackIndex as! Int].starting_point)
                    self.currentTrack[0].track_length = (self.playState.recording.first!.recording.tracks![trackIndex as! Int].length)
                }
                
                if self.currentTrack[0].loading {
                    if let trackTitle = status.userInfo?["title"] {
                        if !((trackTitle as! String).hasPrefix("Loading")) {
                            self.currentTrack[0].loading = false
                        }
                    }
                }
            }
        }
    }
}

struct Player_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
