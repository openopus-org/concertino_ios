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
    @EnvironmentObject var previewBridge: PreviewBridge
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
            imageGet(url: cover) { img in
                DispatchQueue.main.async {
                    songInfo[MPMediaItemPropertyArtist] = self.playState.recording.first!.work!.composer!.name as AnyObject
                    songInfo[MPMediaItemPropertyAlbumTitle] = self.playState.recording.first!.work!.title as AnyObject
                    songInfo[MPMediaItemPropertyArtwork] = img as AnyObject
                    
                    if center.nowPlayingInfo?.count ?? 0 > 0 {
                        songInfo[MPMediaItemPropertyPlaybackDuration] = center.nowPlayingInfo![MPMediaItemPropertyPlaybackDuration] as AnyObject?
                        songInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = center.nowPlayingInfo![MPNowPlayingInfoPropertyElapsedPlaybackTime] as AnyObject?
                        songInfo[MPNowPlayingInfoPropertyPlaybackRate] = center.nowPlayingInfo![MPNowPlayingInfoPropertyPlaybackRate] as AnyObject?
                    }
                    
                    center.nowPlayingInfo = songInfo
                }
            }
        }
        
        self.settingStore.lastPlayState = self.playState.recording
        
        // logging in apple music and concertino
        
        userLogin(self.playState.autoplay) { country, canPlay, apmusEligible, loginResults in
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
                    
                    if let heavyuser = login.user.heavyuser {
                        if heavyuser == 1 {
                            RequestAppStoreReview()
                        }
                    }
                }
            }
            
            // radio? fetch the next recording on the queue
            
            if self.radioState.nextWorks.count > 0 {
                DispatchQueue.main.async {
                    print("🔄 Radio ON, fetching a random recording!")
                    
                    if let indexPlayed = self.radioState.nextWorks.firstIndex(where: { $0.id == self.playState.recording.first!.work!.id }) {
                        self.radioState.nextWorks = Array(self.radioState.nextWorks.suffix(from: indexPlayed+1))
                    }
                    
                    if self.radioState.nextWorks.count > 0 {
                        randomRecording(workQueue: self.radioState.nextWorks, hideIncomplete:  self.settingStore.hideIncomplete, country: self.settingStore.country) { rec in
                            if rec.count > 0 {
                                DispatchQueue.main.async {
                                    self.radioState.nextRecordings = rec
                                    
                                    if self.currentTrack[0].preview {
                                        self.previewBridge.addToQueue(tracks: rec.first!.previews!)
                                    } else {
                                        self.mediaBridge.addToQueue(tracks: rec.first!.apple_tracks!)
                                    }
                                    
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
                    } else {
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
                            if self.currentTrack[0].preview {
                                self.previewBridge.addToQueue(tracks: recordingData.first!.previews!)
                            } else {
                                self.mediaBridge.addToQueue(tracks: recordingData.first!.apple_tracks!)
                            }
                            
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
            
            if canPlay {
                
                DispatchQueue.main.async {
                    
                    // registering first recording played
                    
                    if self.settingStore.lastPlayedRecording == [] {
                        print("first recording played and can play")
                        MarkPlayed(settingStore: self.settingStore, playState: self.playState) { results in
                            DispatchQueue.main.async {
                                self.settingStore.lastPlayedRecording = self.playState.recording
                            }
                        }
                    }
                    
                    // let's play some music!
                    
                    if let tracks = self.playState.recording.first!.apple_tracks {
                        
                        if !self.playState.keepQueue {
                            self.playState.preview = false
                            
                            if let firstrecording = self.playState.recording.first {
                                self.currentTrack = [CurrentTrack (
                                    track_index: 0,
                                    zero_index: 0,
                                    playing: false,
                                    loading: true,
                                    starting_point: 0,
                                    track_position: 0,
                                    track_length: (firstrecording.tracks!.first?.length)!,
                                    full_position: 0,
                                    full_length: firstrecording.length!,
                                    preview: false
                                )]
                                
                                self.mediaBridge.setQueueAndPlay(tracks: tracks, starttrack: nil, autoplay: self.playState.autoplay)
                            }
                        }
                        else {
                            self.playState.keepQueue = false
                        }
                        
                        /*if !self.playState.autoplay {
                            self.currentTrack[0].loading = false
                            //self.playState.autoplay = true
                        }*/
                    }
                }
            } else {
                // playing only samples
                
                if self.settingStore.firstUsage {
                    /*
                    if apmusEligible && self.playState.autoplay {
                        self.playState.autoplay = false
                        
                        DispatchQueue.main.async {
                            let amc = AppleMusicSubscribeController()
                            amc.showAppleMusicSignup()
                        }
                    }
                    */
                    
                    DispatchQueue.main.async {
                        self.AppState.apmusEligible = apmusEligible
                        self.AppState.showingWarning = true
                    }
                }
                
                if let previews = self.playState.recording.first!.previews {
                    
                    // registering first recording played
                    
                    if self.settingStore.lastPlayedRecording == [] {
                        print("first recording played")
                        MarkPlayed(settingStore: self.settingStore, playState: self.playState) { results in
                            DispatchQueue.main.async {
                                self.settingStore.lastPlayedRecording = self.playState.recording
                            }
                        }
                    }
                
                    if !self.playState.keepQueue {
                        print("🔴 playing a preview")
                        self.playState.preview = true
                        self.currentTrack = [CurrentTrack (
                            track_index: 0,
                            zero_index: 0,
                            playing: false,
                            loading: true,
                            starting_point: 0,
                            track_position: 0,
                            track_length: (self.playState.recording.first!.tracks!.first?.length)!,
                            full_position: 0,
                            full_length: self.playState.recording.first!.length!,
                            preview: true
                        )]
                        
                        self.previewBridge.setQueueAndPlay(tracks: previews, starttrack: 0, autoplay: self.playState.autoplay, zeroqueue: false)
                    } else {
                        self.playState.keepQueue = false
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
                        HStack {
                            Spacer()
                            
                            Image("handle")
                                .resizable()
                                .frame(width: 7, height: 32)
                                .foregroundColor(Color(hex: 0x696969))
                                .rotationEffect(.degrees(self.AppState.fullPlayer ? 90 : 270))
                            
                            Spacer()
                        }
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
                                
                                if self.currentTrack.count > 0 {
                                    if self.currentTrack.first!.preview {
                                        HStack {
                                            Spacer()
                                            
                                            HStack {
                                                BrowseOnlyMode(size: "max")
                                            }
                                            .padding(.top, 6)
                                            .padding(.bottom, 6)
                                            .padding(.leading, 12)
                                            .padding(.trailing, 18)
                                            .background(Color.black)
                                            .cornerRadius(24)
                                            .opacity(0.4)
                                            
                                            Spacer()
                                        }
                                        .padding(.top, 10)
                                    }
                                }
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
        .padding(EdgeInsets(top: UIDevice.current.isLarge ? 28 : 0, leading: 0, bottom: UIDevice.current.isLarge ? 46 : 40, trailing: 0))
        .clipped()
        .onAppear(perform: {
            if (self.currentTrack.count == 0 && self.settingStore.lastPlayState.count > 0) {
                self.playState.autoplay = false
                self.playState.recording = self.settingStore.lastPlayState
            }
        })
        .onReceive(playState.objectWillChange, perform: {
            if let firstrecording = self.playState.recording.first {
                if firstrecording.tracks != nil {
                    print("playmusic()")
                    self.playMusic()
                }
            }
        })
        .onReceive(timerHolder.objectWillChange, perform: {
            if (self.currentTrack.count > 0) {
                
                if self.currentTrack[0].preview {
                    self.currentTrack[0].track_position = self.previewBridge.getCurrentPlaybackTime()
                } else {
                    self.currentTrack[0].track_position = self.mediaBridge.getCurrentPlaybackTime()
                }
                
                if self.currentTrack[0].track_position < 2 {
                    if self.currentTrack[0].preview {
                        self.currentTrack[0].playing = self.previewBridge.getCurrentPlaybackState()
                    } else {
                        self.currentTrack[0].playing = self.mediaBridge.getCurrentPlaybackState()
                    }
                    
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
                        else if !self.currentTrack[0].preview {
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
                        /*
                        print("🔴 Playing Item is nil!")
                        self.currentTrack.removeAll()
                        self.playState.playing = false
                        self.radioState.isActive = false
                        */
                        self.currentTrack[0].loading = false
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
                                        full_length: self.playState.recording.first!.length!,
                                        preview: false
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
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.previewPlayerItemChanged)) { status in
            print("New track: \(self.previewBridge.getCurrentTrackIndex())")
            
            if self.currentTrack.count > 0 {
                let trackIndex = self.previewBridge.getCurrentTrackIndex()
                
                if trackIndex >= self.currentTrack.first!.zero_index + self.playState.recording.first!.apple_tracks!.count {
                    // next recording
                    
                    if self.radioState.nextRecordings.count > 0 {
                        self.playState.keepQueue = true
                        self.playState.recording = [self.radioState.nextRecordings.removeFirst()]
                        print("🆗 next recording")
                        //print(self.playState.recording)
                        self.currentTrack = [CurrentTrack (
                            track_index: trackIndex,
                            zero_index: trackIndex,
                            playing: true,
                            loading: false,
                            starting_point: 0,
                            track_position: 0,
                            track_length: (self.playState.recording.first!.tracks!.first?.length)!,
                            full_position: 0,
                            full_length: self.playState.recording.first!.length!,
                            preview: true
                        )]
                        self.radioState.canSkip = false
                    }
                }
                else {
                    print("radio state: \(self.radioState.isActive)")
                    
                    if trackIndex == 0 {
                        self.currentTrack[0].zero_index = 0
                    }
                    
                    self.currentTrack[0].track_index = trackIndex
                    self.currentTrack[0].track_position = 0
                    self.currentTrack[0].starting_point = (self.playState.recording.first!.tracks![trackIndex - self.currentTrack[0].zero_index].starting_point)
                    self.currentTrack[0].full_position = (self.playState.recording.first!.tracks![trackIndex - self.currentTrack[0].zero_index].starting_point)
                    self.currentTrack[0].track_length = (self.playState.recording.first!.tracks![trackIndex - self.currentTrack[0].zero_index].length)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.previewPlayerStatusChanged)) { status in
            if self.currentTrack.count > 0 {
                if let isPlaying = status.userInfo?["status"] {
                    
                    // removing loading
                    
                    if isPlaying as! String == "playing" {
                        print("🆗 started")
                        self.currentTrack[0].loading = false
                        self.timerHolder.start()
                    }
                    else if isPlaying as! String == "paused" {
                        self.currentTrack[0].loading = false
                        print("⛔️ stopped")
                        self.timerHolder.stop()
                    }
                    
                    self.currentTrack[0].playing = (isPlaying as! String == "playing")
                    self.playState.playing = (isPlaying as! String == "playing")
                    
                    //print(self.currentTrack)
                    //print(self.playState)
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
