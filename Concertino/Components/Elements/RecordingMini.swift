//
//  RecordingMini.swift
//  Concertino
//
//  Created by Adriano Brandao on 17/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import URLImage

struct RecordingMini: View {
    var recording: FullRecording
    @EnvironmentObject var playState: PlayState
    @Binding var currentTrack: [CurrentTrack]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                URLImage(recording.recording.cover) { img in
                    img.image
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        .cornerRadius(10)
                }
                .frame(width: 50, height: 50)
                .padding(.trailing, 8)
                
                VStack(alignment: .leading) {
                    Text(recording.work.composer!.name.uppercased())
                        .font(.custom("Nunito-ExtraBold", size: 13))
                        .foregroundColor(Color(hex: 0xfe365e))
                    
                    Text(recording.work.title)
                        .font(.custom("Barlow", size: 14))
                        .padding(.bottom, 4)
                        .lineLimit(20)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
            
            if self.currentTrack.count > 0 {
                HStack {
                    Button(
                        action: {  },
                    label: {
                        Image("play")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 22)
                        .foregroundColor(Color(hex: 0xfe365e))
                        .padding(.leading, 18)
                        .padding(.trailing, 22)
                    })
                    
                    Group {
                        Text(self.currentTrack.first!.readablePosition)
                        
                        ProgressBar(progress: 0.2)
                            .padding(.leading, 6)
                            .padding(.trailing, 6)
                            .frame(height: 4)
                        
                        Text(self.recording.recording.readableLength)
                    }
                    .font(.custom("Nunito", size: 11))
                }
                .padding(.top, 4)
            }
        }
        
    }
}

struct RecordingMini_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
