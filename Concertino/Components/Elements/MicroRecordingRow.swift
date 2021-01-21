//
//  RecordingRow.swift
//  Concertino
//
//  Created by Adriano Brandao on 14/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import URLImage

struct MicroRecordingRow: View {
    var recording: Recording
    
    var body: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .bottomTrailing) {
                URLImage(recording.cover ?? URL(fileURLWithPath: AppConstants.concNoCoverImg), placeholder: { _ in
                    Rectangle()
                        .fill(Color.extraDarkGray)
                        .frame(width: 36, height: 36)
                        .cornerRadius(10)
                }) { img in
                    img.image
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        .cornerRadius(10)
                }
                .frame(width: 36, height: 36)
                .padding(.trailing, 10)
            }
            VStack(alignment: .leading) {
                if recording.work != nil {
                    if recording.work!.composer!.id != "0" {
                        Text(recording.work!.composer!.name.uppercased().trimmingCharacters(in: .whitespacesAndNewlines))
                            .font(.custom("Nunito-ExtraBold", size: 12))
                            .foregroundColor(Color.lightRed)
                    } else if recording.work!.composer!.name != "None" {
                        ForEach(recording.work!.composer!.name.components(separatedBy: CharacterSet(charactersIn: "&,")), id: \.self) { composer in
                            Text(composer.uppercased().trimmingCharacters(in: .whitespacesAndNewlines))
                            .font(.custom("Nunito-ExtraBold", size: 12))
                            .foregroundColor(Color.lightRed)
                        }
                    }
                    
                    Text(recording.work!.title)
                        .font(.custom("Barlow-Regular", size: 12))
                        .foregroundColor(.white)
                        .padding(.bottom, 6)
                        .lineLimit(20)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                if recording.observation != "" && recording.observation != nil {
                    Text(recording.observation ?? "")
                    .font(.custom("Barlow-Regular", size: 9))
                    .padding(.bottom, 6)
                }
                
                ForEach(recording.performers, id: \.name) { performer in
                    Group {
                        if (self.recording.performers.count <= AppConstants.maxPerformers || AppConstants.mainPerformersList.contains(performer.role ?? "")) {
                                Text(performer.name)
                                    .font(.custom("Barlow-SemiBold", size: (self.recording.work != nil ? 11 : 12)))
                                +
                                Text(performer.readableRole)
                                    .font(.custom("Barlow-Regular", size: (self.recording.work != nil ? 11 : 12)))
                        }
                    }
                }
                .foregroundColor(.white)
                .lineLimit(20)
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 14, leading: 0, bottom: 14, trailing: 14))
    }
}

struct MicroRecordingRow_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
