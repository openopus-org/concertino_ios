//
//  RecordingTrackList.swift
//  Concertino
//
//  Created by Adriano Brandao on 17/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct RecordingTrackList: View {
    var recording: FullRecording
    
    var body: some View {
        ForEach(self.recording.recording.tracks!, id: \.id) { track in
            Group {
                HStack {
                    Text(track.title)
                        .font(.custom("Barlow", size: 14))
                    
                    Spacer()
                    
                    Text(track.readableLength)
                        .font(.custom("Nunito", size: 11))
                        .padding(.leading, 12)
                }
                
                Divider()
            }
        }
    }
}

struct RecordingTrackList_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
