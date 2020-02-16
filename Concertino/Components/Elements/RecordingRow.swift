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
            URLImage(recording.cover) { img in
                img.image
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .cornerRadius(20)
            }
            .frame(width: 85, height: 85)
            .padding(.trailing, 12)
            VStack(alignment: .leading) {
                ForEach(recording.performers, id: \.name) { performer in
                    Group {
                        if (self.recording.performers.count <= AppConstants.maxPerformers || AppConstants.mainPerformersList.contains(performer.role ?? "")) {
                            Text(performer.name)
                                .font(.custom("Barlow-SemiBold", size: 13))
                            +
                                Text(AppConstants.groupList.contains(performer.role ?? "") || performer.role == "" ? "" : ", \(performer.role ?? "")")
                                .font(.custom("Barlow", size: 13))
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
