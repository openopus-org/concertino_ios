//
//  RecordingProgressBar.swift
//  Concertino
//
//  Created by Adriano Brandao on 10/04/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct RecordingProgressBar: View {
    var track: Track
    @Binding var currentTrack: [CurrentTrack]
    
    var body: some View {
        HStack {
            Text(track.index == (self.currentTrack.first!.track_index - self.currentTrack.first!.zero_index) ? self.currentTrack.first!.readable_track_position : "0:00")
            
            ZStack {
                ProgressBar(progress: track.index == (self.currentTrack.first!.track_index - self.currentTrack.first!.zero_index) ? self.currentTrack.first!.track_progress : 0)
                    .padding(.leading, 6)
                    .padding(.trailing, 6)
                    .frame(height: 4)
                
                if self.currentTrack.first!.preview {
                    HStack {
                        Text("preview".uppercased())
                            .font(.custom("Nunito-ExtraBold", size: 8))
                    }
                    .padding(.init(top: 2, leading: 6, bottom: 2, trailing: 6))
                    .background(Color.black)
                    .cornerRadius(12)
                    .opacity(0.6)
                }
            }

            Text(track.readableLength)
                .frame(minWidth: 30)
        }
        .font(.custom("Nunito", size: 11))
        .padding(.bottom, 14)
    }
}

struct RecordingProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
