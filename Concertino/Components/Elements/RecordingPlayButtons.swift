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
    
    var body: some View {
        HStack(spacing: 6) {
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
