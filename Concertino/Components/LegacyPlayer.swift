//
//  Player.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/01/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import StoreKit

struct LegacyPlayer: View {
    @State private var currentTrack = [CurrentTrack]()
    @EnvironmentObject var mediaBridge: MediaBridge
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var timerHolder: TimerHolder
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var radioState: RadioState
    
    func playMusic() {
        if self.currentTrack.count > 0 {
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
        
        self.settingStore.lastPlayState = self.playState.recording
        
        SKCloudServiceController.requestAuthorization { status in
            if (SKCloudServiceController.authorizationStatus() == .authorized)
            {
                // user authorized app access to music
                
                let controller = SKCloudServiceController()
                controller.requestCapabilities { capabilities, error in
                    if capabilities.contains(.musicCatalogPlayback) {
                        
                        // user has an active apple music account, get the user token & apple default recommendations
                        
                        // first, check if the app needs to log in again
                        
                        if timeframe(timestamp: self.settingStore.lastLogged, minutes: 120)  {
                            APIget(AppConstants.concBackend+"/applemusic/token.json") { results in
                                
                                let token: Token = parseJSON(results)
                                controller.requestUserToken(forDeveloperToken: token.token) { userToken, error in
                                   
                                // get the country/storefront
                                    
                                    controller.requestStorefrontCountryCode { countryCode, error in
                                        
                                        // log in to concertino
                                            
                                        APIpost("\(AppConstants.concBackend)/dyn/user/sslogin/", parameters: ["token": userToken ?? "", "auth": authGen(userId: self.settingStore.userId, userAuth: self.settingStore.userAuth) ?? "", "id": self.settingStore.userId, "country": countryCode ?? ""]) { results in
                                                
                                            print(String(decoding: results, as: UTF8.self))
                                            
                                            // saving login info to the settings store
                                            
                                            DispatchQueue.main.async {
                                                let login: Login = parseJSON(results)
                                                self.settingStore.userId = login.user.id
                                                self.settingStore.lastLogged = Int(Date().millisecondsSince1970 / (60 * 1000) | 0)
                                                
                                                if let cc = countryCode {
                                                    self.settingStore.country = cc
                                                }
                                                
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
                                                
                                                // registering first recording played
                                                
                                                if self.playState.autoplay {
                                                    MarkPlayed(settingStore: self.settingStore, playState: self.playState) { results in
                                                        DispatchQueue.main.async {
                                                            self.settingStore.lastPlayedRecording = self.playState.recording
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        // let's play some music!
                        
                        DispatchQueue.main.async {
                            if let tracks = self.playState.recording.first!.apple_tracks {
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
                                
                                if !self.playState.autoplay {
                                    self.currentTrack[0].loading = false
                                    self.playState.autoplay = true
                                }
                                
                                // radio? fetch the next recording on the queue
                                
                                if self.radioState.nextWorks.count > 0 {
                                    print("🔄 Radio ON, fetching a random recording!")
                                    self.radioState.nextWorks = Array(self.radioState.nextWorks.dropFirst())
                                    randomRecording(workQueue: self.radioState.nextWorks, hideIncomplete:  self.settingStore.hideIncomplete, country: self.settingStore.country) { rec in
                                        if rec.count > 0 {
                                            DispatchQueue.main.async {
                                                self.radioState.nextRecordings = rec
                                            }
                                        }
                                        else {
                                            DispatchQueue.main.async {
                                                alertError("No recordings matching your criteria were found.")
                                            }
                                        }
                                    }
                                } else if self.radioState.nextRecordings.count > 0 {
                                    print("⏭ Radio ON, fetching the next recording details!")
                                    
                                    getRecordingDetail(recording: self.radioState.nextRecordings.first!, country: self.settingStore.country) { recordingData in
                                        DispatchQueue.main.async {
                                            //self.mediaBridge.addToQueue(tracks: recordingData.first!.apple_tracks!)
                                            self.radioState.nextRecordings[0] = recordingData.first!
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if capabilities.contains(.musicCatalogSubscriptionEligible) && self.playState.autoplay {
                        DispatchQueue.main.async {
                            let amc = AppleMusicSubscribeController()
                            amc.showAppleMusicSignup()
                        }
                    }
                }
            }
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
            } /*else {
                getRecordingDetail(recording: self.playState.recording.first!, country: self.settingStore.country) { recordingData in
                    DispatchQueue.main.async {
                        print("Getting recording details, just in case")
                        
                        self.playState.autoplay = true
                        self.playState.recording = [recordingData.first!]
                    }
                }
            }*/
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
                        }
                        
                        // detecting end of queue
                        
                        if self.currentTrack[0].playing && isPlaying as! Bool == false && ((self.mediaBridge.getCurrentPlaybackTime() == 0 && self.mediaBridge.getCurrentTrackIndex() == 0 && false) || (abs(self.mediaBridge.getCurrentPlaybackTime()-self.currentTrack[0].track_length) < 3 && self.mediaBridge.getCurrentTrackIndex() == self.playState.recording[0].tracks!.count - 1)) {
                            print("⏹ Queue ended! time \(self.mediaBridge.getCurrentPlaybackTime()) - track \(self.mediaBridge.getCurrentTrackIndex())")
                            //self.mediaBridge.stop()
                             
                            // radio
                            if self.radioState.nextRecordings.count > 0 {
                                print("⏭ Radio ON, play the next recording!")
                                //print(self.AppState.radioNextRecordings.first)
                            
                                self.playState.autoplay = true
                                self.playState.recording = [self.radioState.nextRecordings.removeFirst()]
                            } else if self.radioState.isActive {
                                self.radioState.isActive = false
                            }
                        }
                            /*
                            else {
                            print("End of queue")
                            print(self.currentTrack[0].playing)
                            print(isPlaying as! Bool == false)
                            print(self.mediaBridge.getCurrentPlaybackTime())
                            print(self.mediaBridge.getCurrentTrackIndex())
                            print(self.currentTrack[0].track_length)
                            print(self.playState.recording[0].tracks!.count - 1)
                        }
                        */
                        
                        self.currentTrack[0].playing = isPlaying as! Bool
                        self.playState.playing = isPlaying as! Bool
                        
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
                
                if let success = status.userInfo?["success"] {
                    if success as! Bool == false {
                        print("🔴 Playing Item is nil!")
                        self.currentTrack.removeAll()
                        self.playState.playing = false
                        
                        // radio
                        if self.radioState.nextRecordings.count > 0 {
                            print("⏭ Radio ON, play the next recording!")
                        
                            self.playState.autoplay = true
                            self.playState.recording = [self.radioState.nextRecordings.removeFirst()]
                        } else if self.radioState.isActive {
                            self.radioState.isActive = false
                        }
                        
                        /*let alertController = UIAlertController(title: "Couldn't play", message:
                            "Sorry, this recording is not available in your country.", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(alertController, animated: true, completion: nil)*/
                    }
                    else {
                        if let trackIndex = status.userInfo?["index"] {
                            //print(self.playState.recording)
                            
                            self.currentTrack[0].track_index = trackIndex as! Int
                            self.currentTrack[0].track_position = 0
                            self.currentTrack[0].starting_point = (self.playState.recording.first!.tracks![trackIndex as! Int].starting_point)
                            self.currentTrack[0].full_position = (self.playState.recording.first!.tracks![trackIndex as! Int].starting_point)
                            self.currentTrack[0].track_length = (self.playState.recording.first!.tracks![trackIndex as! Int].length)
                        }
                        
                        /*if self.currentTrack[0].loading {
                            if let trackTitle = status.userInfo?["title"] {
                                if !((trackTitle as! String).hasPrefix("Loading")) {
                                    self.currentTrack[0].loading = false
                                }
                            }
                        }*/
                    }
                }
            }
        }
    }
}

struct LegacyPlayer_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
