//
//  Player.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/01/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import StoreKit
import MediaPlayer

struct Player: View {
    @State private var currentTrack = [CurrentTrack]()
    @EnvironmentObject var mediaBridge: MediaBridge
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var timerHolder: TimerHolder
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var radioState: RadioState
    
    func playMusic() {
        if self.currentTrack.count > 0 && !self.playState.keepQueue {
            self.mediaBridge.stop()
            self.currentTrack[0].loading = true
        }
        
        if self.playState.autoplay {
            // logging in the session

            if self.settingStore.userId > 0 {
                MarkPlayed(settingStore: self.settingStore, playState: self.playState) { results in
                    DispatchQueue.main.async {
                        self.settingStore.lastPlayedRecording = self.playState.recording
                    }
                }
            }
        }
        
        // apple now playing
        
        let center = MPNowPlayingInfoCenter.default()
        var songInfo = [String: AnyObject]()
        
        if let cover = self.playState.recording.first!.cover {
            print(cover)
            imageGet(url: cover) { img in
                DispatchQueue.main.async {
                    songInfo[MPMediaItemPropertyArtist] = self.playState.recording.first!.work!.composer!.name as AnyObject
                    songInfo[MPMediaItemPropertyAlbumTitle] = self.playState.recording.first!.work!.title as AnyObject
                    songInfo[MPMediaItemPropertyArtwork] = img as AnyObject
                    center.nowPlayingInfo = songInfo
                }
            }
        }
        
        self.settingStore.lastPlayState = self.playState.recording
        
        // logging in apple music and concertino
        
        userLogin(self.playState.autoplay) { country, canPlay, loginResults in
            if let login = loginResults {
                
                DispatchQueue.main.async {
                    self.settingStore.userId = login.user.id
                    self.settingStore.lastLogged = Int(Date().millisecondsSince1970 / (60 * 1000) | 0)
                    self.settingStore.country = country
                    
                    if let auth = login.user.auth {
                        self.settingStore.userAuth = auth
                    }
                    
                    if let favoritecomposers = login.favorite {
                        self.settingStore.favoriteComposers = favoritecomposers
                    }
                    
                    if let favoriteworks = login.works {
                        self.settingStore.favoriteWorks = favoriteworks
                    }
                    
                    if let composersfavoriteworks = login.composerworks {
                        self.settingStore.composersFavoriteWorks = composersfavoriteworks
                    }
                    
                    if let favoriterecordings = login.favoriterecordings {
                        self.settingStore.favoriteRecordings = favoriterecordings
                    }
                    
                    if let forbiddencomposers = login.forbidden {
                        self.settingStore.forbiddenComposers = forbiddencomposers
                    }
                    
                    if let playlists = login.playlists {
                        self.settingStore.playlists = playlists
                    }
                }
            }
            
            if canPlay {
                
                DispatchQueue.main.async {
                    
                    // registering first recording played
                    
                    if self.playState.autoplay {
                        MarkPlayed(settingStore: self.settingStore, playState: self.playState) { results in
                            DispatchQueue.main.async {
                                self.settingStore.lastPlayedRecording = self.playState.recording
                            }
                        }
                    }
                    
                    // let's play some music!
                    
                    if let tracks = self.playState.recording.first!.apple_tracks {
                        
                        if !self.playState.keepQueue {
                            self.currentTrack = [CurrentTrack (
                                track_index: 0,
                                zero_index: 0,
                                playing: false,
                                loading: true,
                                starting_point: 0,
                                track_position: 0,
                                track_length: (self.playState.recording.first!.tracks!.first?.length)!,
                                full_position: 0,
                                full_length: self.playState.recording.first!.length!
                            )]
                            
                            self.mediaBridge.setQueueAndPlay(tracks: tracks, starttrack: nil, autoplay: self.playState.autoplay)
                        }
                        else {
                            self.playState.keepQueue = false
                        }
                        
                        if !self.playState.autoplay {
                            self.currentTrack[0].loading = false
                            //self.playState.autoplay = true
                        }
                        
                        // radio? fetch the next recording on the queue
                        
                        if self.radioState.nextWorks.count > 0 {
                            print("🔄 Radio ON, fetching a random recording!")
                            
                            let indexPlayed = self.radioState.nextWorks.firstIndex(where: { $0.id == self.playState.recording.first!.work!.id })
                            self.radioState.nextWorks = Array(self.radioState.nextWorks.suffix(from: indexPlayed!+1))
                            randomRecording(workQueue: self.radioState.nextWorks, hideIncomplete:  self.settingStore.hideIncomplete, country: self.settingStore.country) { rec in
                                if rec.count > 0 {
                                    DispatchQueue.main.async {
                                        self.radioState.nextRecordings = rec
                                        self.mediaBridge.addToQueue(tracks: rec.first!.apple_tracks!)
                                        self.radioState.nextRecordings[0] = rec.first!
                                        self.radioState.canSkip = true
                                    }
                                }
                                else {
                                    DispatchQueue.main.async {
                                        self.radioState.isActive = false
                                    }
                                }
                            }
                        } else if self.radioState.nextRecordings.count > 0 {
                            print("⏭ Radio ON, fetching the next recording details!")
                            
                            getRecordingDetail(recording: self.radioState.nextRecordings.first!, country: self.settingStore.country) { recordingData in
                                if recordingData.count > 0 {
                                    DispatchQueue.main.async {
                                        self.mediaBridge.addToQueue(tracks: recordingData.first!.apple_tracks!)
                                        self.radioState.nextRecordings[0] = recordingData.first!
                                        self.radioState.canSkip = true
                                    }
                                } else {
                                    self.radioState.isActive = false
                                }
                            }
                        } else if self.radioState.isActive {
                            DispatchQueue.main.async {
                                self.radioState.isActive = false
                            }
                        }
                    }
                }
            }
            
            self.settingStore.firstUsage = false
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(gradient: Gradient(colors: [Color(hex: 0x4F4F4F), Color(hex: 0x2B2B2F)]), startPoint: .top, endPoint: .bottom)
                .frame(minHeight: 130, maxHeight: self.AppState.fullPlayer ? .infinity : 130)
                .cornerRadius(25)
            
            VStack {
                Button(
                    action: { self.AppState.fullPlayer.toggle() },
                    label: {
                        Image("handle")
                            .resizable()
                            .frame(width: 7, height: 32)
                            .foregroundColor(Color(hex: 0x696969))
                            .rotationEffect(.degrees(self.AppState.fullPlayer ? 90 : 270))
                    })
                    .frame(height: 7)
                    .padding(.top, (self.AppState.fullPlayer ? 14 : 10))
                
                if (playState.recording.count > 0) {
                    if self.AppState.fullPlayer {
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading) {
                                RecordingWorkPerformers(recording: playState.recording.first!, isSheet: false)
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
        .padding(EdgeInsets(top: 28, leading: 0, bottom: 46, trailing: 0))
        .clipped()
        .onAppear(perform: {
            if (self.currentTrack.count == 0 && self.settingStore.lastPlayState.count > 0) {
                self.playState.autoplay = false
                self.playState.recording = self.settingStore.lastPlayState
            }
        })
        .onReceive(playState.objectWillChange, perform: {
            if self.playState.recording.first!.tracks != nil {
                self.playMusic()
            }
        })
        .onReceive(timerHolder.objectWillChange, perform: {
            if (self.currentTrack.count > 0) {
                self.currentTrack[0].track_position = self.mediaBridge.getCurrentPlaybackTime()
                
                if self.currentTrack[0].track_position < 2 {
                    self.currentTrack[0].playing = self.mediaBridge.getCurrentPlaybackState()
                    self.playState.playing = self.currentTrack[0].playing
                }
                
                self.currentTrack[0].full_position = self.currentTrack[0].starting_point + self.currentTrack[0].track_position
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange)) { status in
                if self.currentTrack.count > 0 {
                    if let isPlaying = status.userInfo?["playing"] {
                        
                        // removing loading
                        
                        if isPlaying as! Bool {
                            self.currentTrack[0].loading = false
                            self.timerHolder.start()
                        }
                        else {
                            self.timerHolder.stop()
                        }
                        
                        self.currentTrack[0].playing = isPlaying as! Bool
                        self.playState.playing = isPlaying as! Bool
                    }
                }
            }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange)) { status in
            if self.currentTrack.count > 0 {
                
                if let success = status.userInfo?["success"] {
                    if success as! Bool == false {
                        print("🔴 Playing Item is nil!")
                        self.currentTrack.removeAll()
                        self.playState.playing = false
                        self.radioState.isActive = false
                    }
                    else {
                        if let trackIndex = status.userInfo?["index"] {
                            //print(self.playState.recording)
                            
                            if trackIndex as! Int >= self.currentTrack.first!.zero_index + self.playState.recording.first!.apple_tracks!.count {
                                // next recording
                                
                                if self.radioState.nextRecordings.count > 0 {
                                    self.playState.keepQueue = true
                                    self.playState.recording = [self.radioState.nextRecordings.removeFirst()]
                                    print("🆗 next recording")
                                    //print(self.playState.recording)
                                    self.currentTrack = [CurrentTrack (
                                        track_index: trackIndex as! Int,
                                        zero_index: trackIndex as! Int,
                                        playing: false,
                                        loading: false,
                                        starting_point: 0,
                                        track_position: 0,
                                        track_length: (self.playState.recording.first!.tracks!.first?.length)!,
                                        full_position: 0,
                                        full_length: self.playState.recording.first!.length!
                                    )]
                                    //print(self.currentTrack)
                                    self.radioState.canSkip = false
                                }
                            }
                            else {
                                print("radio state: \(self.radioState.isActive)")
                                if !self.radioState.isActive {
                                    self.currentTrack[0].zero_index = 0
                                }
                                
                                self.currentTrack[0].track_index = trackIndex as! Int
                                self.currentTrack[0].track_position = 0
                                self.currentTrack[0].starting_point = (self.playState.recording.first!.tracks![trackIndex as! Int - self.currentTrack[0].zero_index].starting_point)
                                self.currentTrack[0].full_position = (self.playState.recording.first!.tracks![trackIndex as! Int - self.currentTrack[0].zero_index].starting_point)
                                self.currentTrack[0].track_length = (self.playState.recording.first!.tracks![trackIndex as! Int - self.currentTrack[0].zero_index].length)
                            }
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
