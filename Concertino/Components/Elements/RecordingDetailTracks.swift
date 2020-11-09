//
//  RecordingDetailTracks.swift
//  Concertino
//
//  Created by Adriano Brandao on 25/10/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct RecordingDetailTracks: View {
    var recording: FullRecording
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                VStack {
                    if recording.work.composer!.id != "0" {
                        Text(recording.work.composer!.name.uppercased().trimmingCharacters(in: .whitespacesAndNewlines))
                            .font(.custom("Nunito-ExtraBold", size: 13))
                            .foregroundColor(Color(hex: 0xfe365e))
                    } else {
                        ForEach(recording.work.composer!.name.components(separatedBy: CharacterSet(charactersIn: "&,")), id: \.self) { composer in
                            Text(composer.uppercased().trimmingCharacters(in: .whitespacesAndNewlines))
                            .font(.custom("Nunito-ExtraBold", size: 13))
                            .foregroundColor(Color(hex: 0xfe365e))
                        }
                    }
                }
                .padding(.top, 12)
                
                Text(recording.work.title)
                    .font(.custom("Barlow-Regular", size: 15))
                    .padding(.bottom, 6)
                    .lineLimit(20)
                    .fixedSize(horizontal: false, vertical: true)
                
                ForEach(recording.recording.performers, id: \.name) { performer in
                    Text(performer.name)
                        .font(.custom("Barlow-SemiBold", size: 14))
                    +
                    Text(performer.readableRole)
                        .font(.custom("Barlow-Regular", size: 13))
                }
                .foregroundColor(.white)
            }
            
            Spacer()
            
            RecordingPlayButton (recording: recording)
                .frame(width: 44)
        }
        
        
        if let tracks = recording.recording.tracks {
            VStack {
                Divider()
                
                ForEach(tracks, id: \.id) { track in
                    Group {
                        HStack {
                            Text(track.title)
                                .font(.custom("Barlow-Regular", size: 12))
                            
                            Spacer()
                            
                            Text(track.readableLength)
                                .font(.custom("Nunito-Regular", size: 11))
                                .padding(.leading, 12)
                        }
                        
                        Divider()
                    }
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
        }
    }
}

struct RecordingDetailTracks_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
