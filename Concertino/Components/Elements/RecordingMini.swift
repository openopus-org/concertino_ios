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
    
    var body: some View {
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
    }
}

struct RecordingMini_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
