//
//  RecordingDetailed.swift
//  Concertino
//
//  Created by Adriano Brandao on 16/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import URLImage

struct RecordingDetailed: View {
    var recording: FullRecording
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        URLImage(recording.recording.cover) { img in
                            img.image
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipped()
                                .cornerRadius(20)
                        }
                        .frame(width: 110, height: 110)
                        .padding(.trailing, 8)
                        
                        VStack(alignment: .leading) {
                            Text(recording.work.composer!.name.uppercased())
                                .font(.custom("Nunito-ExtraBold", size: 15))
                                .foregroundColor(Color(hex: 0xfe365e))
                            
                            Text(recording.work.title)
                                .font(.custom("Barlow-SemiBold", size: 16))
                                .padding(.bottom, 4)
                                .lineLimit(20)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Group {
                                if recording.recording.observation != "" && recording.recording.observation != nil {
                                    Text(recording.recording.observation ?? "")
                                }
                                else if recording.work.subtitle != "" && recording.work.subtitle != nil {
                                    Text(recording.work.subtitle!)
                                }
                            }
                            .font(.custom("Barlow", size: 14))
                            .lineLimit(20)
                            .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer()
                    }
                    .padding(.bottom, 24)
                    
                    ForEach(self.recording.recording.performers, id: \.name) { performer in
                        Text(performer.name)
                            .font(.custom("Barlow-SemiBold", size: 13))
                        +
                        Text(performer.readableRole)
                            .font(.custom("Barlow", size: 13))
                    }
                    .foregroundColor(.white)
                    
                    Text(recording.recording.label ?? "")
                        .font(.custom("Nunito", size: 11))
                        .padding(.top, 6)
                    
                    HStack {
                        
                        Button(
                            action: { UIApplication.shared.open(URL(string: AppConstants.appleLink + self.recording.recording.apple_albumid)!) },
                            label: {
                                Image("applemusic")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .background(Color(hex: 0x2B2B2F))
                                    .frame(width: 100)
                                    .padding(10)
                                    .cornerRadius(20)
                        })
                    }
                    .padding(.top, 20)
                
                    ForEach(self.recording.recording.tracks!, id: \.id) { track in
                        HStack {
                            Text(track.title)
                                .font(.custom("Barlow", size: 14))
                            
                            Spacer()
                            
                            Text(track.readableLength)
                                .font(.custom("Nunito", size: 10))
                        }
                        .padding(.bottom, 16)
                    }
                    
            }
        }
    }
}

struct RecordingDetailed_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
