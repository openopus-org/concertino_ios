//
//  RecordingProgressBars.swift
//  Concertino
//
//  Created by Adriano Brandao on 24/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct RecordingProgressBars: View {
    var recording: Recording
    @Binding var currentTrack: [CurrentTrack]
    @EnvironmentObject var mediaBridge: MediaBridge
    @EnvironmentObject var playState: PlayState
    
    var body: some View {
        Group {
            if self.recording.tracks != nil {
                if self.currentTrack.count > 0 {
                    ForEach(self.recording.tracks!, id: \.id) { track in
                        VStack(alignment: .leading) {
                            
                            Button(action: {
                                self.mediaBridge.stop()
                                self.currentTrack[0].loading = true
                                self.mediaBridge.setQueueAndPlay(tracks: self.playState.recording.first!.apple_tracks!, starttrack: track.apple_trackid, autoplay: true)
                            }, label: {
                                Text(track.title)
                                    .font(.custom("Barlow", size: 14))
                                    .foregroundColor(Color.white)
                            })
                            
                            HStack {
                                Text(self.currentTrack.first!.track_index == track.index ? self.currentTrack.first!.readable_track_position : "0:00")
                                
                                ProgressBar(progress: self.currentTrack.first!.track_index == track.index ? self.currentTrack.first!.track_progress : 0)
                                    .padding(.leading, 6)
                                    .padding(.trailing, 6)
                                    .frame(height: 4)
                
                                Text(track.readableLength)
                            }
                            .font(.custom("Nunito", size: 11))
                            .padding(.bottom, 14)
                        }
                    }
                } else {
                    RecordingTrackList(recording: self.recording)
                    .padding(.top, 10)
                }
            } else {
                HStack {
                    Spacer()
                    ActivityIndicator(isAnimating: true)
                        .configure { $0.color = .white; $0.style = .large }
                    Spacer()
                }
                .padding(.top, 30)
            }
        }
    }
}

struct RecordingProgressBars_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
