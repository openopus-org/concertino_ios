//
//  RecordingRow.swift
//  Concertino
//
//  Created by Adriano Brandao on 14/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import URLImage

struct MiniRecordingRow: View {
    var recording: Recording
    var accentColor: Color
    
    var body: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .bottomTrailing) {
                URLImage(recording.cover ?? URL(fileURLWithPath: AppConstants.concNoCoverImg)) { img in
                    img.image
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        .cornerRadius(20)
                }
                .frame(width: 70, height: 70)
                .padding(.trailing, 10)
            }
            VStack(alignment: .leading) {
                if recording.work != nil {
                    Text(recording.work!.composer!.name.uppercased())
                        .font(.custom("Nunito-ExtraBold", size: 12))
                        .foregroundColor(accentColor)
                    
                    Text(recording.work!.title)
                        .font(.custom("Barlow", size: 14))
                        .padding(.bottom, 6)
                        .lineLimit(20)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                if recording.observation != "" && recording.observation != nil {
                    Text(recording.observation ?? "")
                    .font(.custom("Barlow", size: 9))
                    .padding(.bottom, 6)
                }
                
                ForEach(recording.performers, id: \.name) { performer in
                    Group {
                        if (self.recording.performers.count <= AppConstants.maxPerformers || AppConstants.mainPerformersList.contains(performer.role ?? "")) {
                                Text(performer.name)
                                    .font(.custom("Barlow-SemiBold", size: (self.recording.work != nil ? 11 : 12)))
                                +
                                Text(performer.readableRole)
                                    .font(.custom("Barlow", size: (self.recording.work != nil ? 11 : 12)))
                        }
                    }
                }
                .foregroundColor(.white)
                .lineLimit(20)
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 20, leading: 4, bottom: 20, trailing: 0))
    }
}

struct MiniRecordingRow_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
