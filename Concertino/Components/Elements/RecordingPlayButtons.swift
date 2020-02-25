//
//  RecordingPlayButtons.swift
//  Concertino
//
//  Created by Adriano Brandao on 17/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct RecordingPlayButtons: View {
    var recording: FullRecording
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var AppState: AppState
    
    var body: some View {
        HStack(spacing: 6) {
            if self.playState.recording.count > 0 && self.playState.recording.first!.recording.apple_albumid == self.recording.recording.apple_albumid && self.playState.recording.first!.work.id == self.recording.work.id && self.playState.recording.first!.recording.set == self.recording.recording.set {
                Button(
                    action: { self.AppState.fullPlayer = true },
                    label: {
                        HStack {
                            HStack {
                                Spacer()
                                DotsAnimation()
                                    .padding(.trailing, 3)
                                Text("playing".uppercased())
                                    .font(.custom("Nunito", size: 12))
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
                    action: { self.playState.recording = [self.recording] },
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
                action: { UIApplication.shared.open(URL(string: AppConstants.appleLink + self.recording.recording.apple_albumid)!) },
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
    }
}

struct RecordingPlayButtons_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
