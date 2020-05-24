//
//  Warning.swift
//  Concertino
//
//  Created by Adriano Brandao on 23/05/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import StoreKit

struct Warning: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var playState: PlayState
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                Text("warning".uppercased())
                    .foregroundColor(Color(hex: 0x717171))
                    .font(.custom("Nunito", size: 10))
                    .multilineTextAlignment(.leading)
                
                Text("Concertino needs an active Apple Music subscription to play music")
                    .foregroundColor(Color.white)
                    .font(.custom("Barlow-SemiBold", size: 15))
                    .padding(.top, 20)
                    .multilineTextAlignment(.center)
                
                if !appState.apmusEligible {
                    Text("Unfortunately, this device is not eligible for Apple Music.")
                        .foregroundColor(Color.white)
                        .font(.custom("Barlow", size: 14))
                        .padding(.top, 10)
                        .multilineTextAlignment(.center)
                }
                
                Text("You can browse Concertino's catalogue, create playlists, favorite works, composers and recordings, but playback is restricted to 30 seconds samples.")
                    .foregroundColor(Color.white)
                    .font(.custom("Barlow", size: 11))
                    .padding(.top, 10)
                    .padding(.bottom, 18)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 10) {
                    
                    if appState.apmusEligible {
                        Button(
                            action: {
                                SKCloudServiceController.requestAuthorization { status in
                                    if (SKCloudServiceController.authorizationStatus() == .authorized)
                                    {
                                        let controller = SKCloudServiceController()
                                        controller.requestCapabilities { capabilities, error in
                                            if capabilities.contains(.musicCatalogPlayback) {
                                                self.playState.recording = self.playState.recording
                                            }
                                            else {
                                                if capabilities.contains(.musicCatalogSubscriptionEligible) {
                                                    DispatchQueue.main.async {
                                                        let amc = AppleMusicSubscribeController()
                                                        amc.showAppleMusicSignup()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    else {
                                        DispatchQueue.main.async {
                                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                                        }
                                    }
                                }
                            },
                            label: {
                                HStack {
                                    HStack {
                                        Spacer()
                                        Text("enable playback".uppercased())
                                            .font(.custom("Nunito-ExtraBold", size: 10))
                                        Spacer()
                                    }
                                }
                                .padding(12)
                                .foregroundColor(.white)
                                .background(Color(hex: 0xfe365e))
                                .cornerRadius(16)
                        })
                    }
                    
                    Button(
                        action: {
                            self.appState.showingWarning = false
                        },
                        label: {
                            HStack {
                                HStack {
                                    Spacer()
                                    Text("close".uppercased())
                                        .font(.custom("Nunito", size: 10))
                                    Spacer()
                                }
                            }
                            .padding(12)
                            .foregroundColor(.white)
                            .background(Color(hex: 0x555555))
                            .cornerRadius(16)
                    })
                }
                .padding(.top, 20)
            }
            .padding(15)
            .background(Color(hex: 0x2b2b2f))
            .cornerRadius(20)
            .frame(maxWidth: 320)
            
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.black.opacity(0.8))
        .edgesIgnoringSafeArea(.all)
    }
}

struct Warning_Previews: PreviewProvider {
    static var previews: some View {
        Warning()
    }
}
