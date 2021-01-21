//
//  RecordingRow.swift
//  Concertino
//
//  Created by Adriano Brandao on 14/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import URLImage

struct RecordingRow: View {
    var recording: Recording
    
    var body: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .bottomTrailing) {
                URLImage(recording.cover ?? URL(fileURLWithPath: AppConstants.concNoCoverImg), placeholder: { _ in
                    Rectangle()
                        .fill(Color(hex: 0x2B2B2F))
                        .frame(width: 85, height: 85)
                        .cornerRadius(20)
                }) { img in
                    img.image
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        .cornerRadius(20)
                }
                .frame(width: 85, height: 85)
                .padding(.trailing, 12)
                
                if recording.isVerified {
                    VStack {
                        Image("checked")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                        .foregroundColor(Color.lightRed)
                    }
                    .frame(width: 22, height: 22)
                    .background(Color.black)
                    .clipped()
                    .clipShape(Circle())
                    .offset(x: -18)
                }
            }
            VStack(alignment: .leading) {
                if recording.work != nil {
                    if recording.work!.composer!.id != "0" {
                        Text(recording.work!.composer!.name.uppercased().trimmingCharacters(in: .whitespacesAndNewlines))
                            .font(.custom("Nunito-ExtraBold", size: 13))
                            .foregroundColor(Color.lightRed)
                    } else if recording.work!.composer!.name != "None" {
                        ForEach(recording.work!.composer!.name.components(separatedBy: CharacterSet(charactersIn: "&,")), id: \.self) { composer in
                            Text(composer.uppercased().trimmingCharacters(in: .whitespacesAndNewlines))
                            .font(.custom("Nunito-ExtraBold", size: 13))
                            .foregroundColor(Color.lightRed)
                        }
                    }
                    
                    Text(recording.work!.title)
                        .font(.custom("Barlow-Regular", size: 15))
                        .padding(.bottom, 6)
                        .lineLimit(20)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                if recording.observation != "" && recording.observation != nil {
                    Text(recording.observation ?? "")
                    .font(.custom("Barlow-Regular", size: 10))
                    .padding(.bottom, 6)
                }
                
                ForEach(recording.performers, id: \.name) { performer in
                    Group {
                        if (self.recording.performers.count <= AppConstants.maxPerformers || AppConstants.mainPerformersList.contains(performer.role ?? "")) {
                                Text(performer.name)
                                    .font(.custom("Barlow-SemiBold", size: (self.recording.work != nil ? 12 : 13)))
                                +
                                Text(performer.readableRole)
                                    .font(.custom("Barlow-Regular", size: (self.recording.work != nil ? 12 : 13)))
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

struct RecordingRow_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
