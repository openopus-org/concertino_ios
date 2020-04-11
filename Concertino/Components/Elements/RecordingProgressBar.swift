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
            
            ProgressBar(progress: track.index == (self.currentTrack.first!.track_index - self.currentTrack.first!.zero_index) ? self.currentTrack.first!.track_progress : 0)
                .padding(.leading, 6)
                .padding(.trailing, 6)
                .frame(height: 4)

            Text(track.readableLength)
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
