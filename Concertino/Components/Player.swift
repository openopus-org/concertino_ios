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
    @State var fullPlayer = false
    @EnvironmentObject var playState: PlayState
    
    func playMusic() {
        SKCloudServiceController.requestAuthorization { status in
            
            if (SKCloudServiceController.authorizationStatus() == .authorized)
            {
                // user authorized app access to music
                
                let controller = SKCloudServiceController()
                
                controller.requestCapabilities { capabilities, error in
                    
                    if capabilities.contains(.musicCatalogPlayback) {
                        
                        // user has an active apple music account
                        
                        if let tracks = self.playState.recording.first!.recording.apple_tracks {
                            let player = MPMusicPlayerController.applicationQueuePlayer
                            let queue  = MPMusicPlayerStoreQueueDescriptor(storeIDs: tracks)

                            player.setQueue(with: queue)
                            player.play()
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
                                RecordingDisclaimer(isVerified: playState.recording.first!.recording.isVerified)
                            }
                            .padding(30)
                            .padding(.top, 0)
                        }
                        .padding(.top, 0)
                        
                        Spacer()
                    }
                    else {
                        RecordingMini(recording: playState.recording.first!)
                            .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
                    }
                }
            }
        }
        .padding(EdgeInsets(top: 32, leading: 0, bottom: 46, trailing: 0))
        .clipped()
        .onReceive(playState.objectWillChange, perform: playMusic)
    }
}

struct Player_Previews: PreviewProvider {
    static var previews: some View {
        Player()
    }
}
