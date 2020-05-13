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
    var recording: Recording
    @Binding var currentTrack: [CurrentTrack]
    @EnvironmentObject var mediaBridge: MediaBridge
    @EnvironmentObject var previewBridge: PreviewBridge
    @EnvironmentObject var settingStore: SettingStore
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                URLImage(recording.cover ?? URL(fileURLWithPath: AppConstants.concNoCoverImg), placeholder: { _ in
                    Rectangle()
                        .fill(Color(hex: 0x2B2B2F))
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                }) { img in
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
                    Text(recording.work!.composer!.name.uppercased())
                        .font(.custom("Nunito-ExtraBold", size: 12))
                        .foregroundColor(Color(hex: 0xfe365e))
                    
                    Text(recording.work!.title)
                        .font(.custom("Barlow", size: 13))
                        .padding(.bottom, 4)
                        .lineLimit(20)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
            
            if self.currentTrack.count > 0 {
                if self.currentTrack.first!.loading {
                    HStack {
                        Spacer()
                        ActivityIndicator(isAnimating: true)
                            .configure { $0.color = Color(hex: 0xfe365e).uiColor(); $0.style = .medium }
                        Spacer()
                    }
                    .padding(.top, 4)
                }
                else {
                    HStack {
                        Button(
                            action: {
                                if self.currentTrack.first!.preview {
                                    self.previewBridge.togglePlay()
                                } else {
                                    self.mediaBridge.togglePlay()
                                }
                        },
                        label: {
                            Image(self.currentTrack.first!.playing ? "pause" : "play")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 22)
                            .foregroundColor(Color(hex: 0xfe365e))
                            .padding(.leading, 18)
                            .padding(.trailing, 22)
                        })
                        
                        Group {
                            Text(self.currentTrack.first!.readable_full_position)
                            
                            ProgressBar(progress: self.currentTrack.first!.full_progress)
                                .padding(.leading, 6)
                                .padding(.trailing, 6)
                                .frame(height: 4)
                            
                            Text(self.recording.readableLength)
                        }
                        .font(.custom("Nunito", size: 11))
                    }
                    .padding(.top, 4)
                }
            }
            else {
                if self.settingStore.userId > 0 || self.settingStore.firstUsage {
                    //RecordingNotAvailable(size: "min")
                    HStack {
                        Spacer()
                        ActivityIndicator(isAnimating: true)
                            .configure { $0.color = Color(hex: 0xfe365e).uiColor(); $0.style = .medium }
                        Spacer()
                    }
                    .padding(.top, 4)
                }
                else {
                    BrowseOnlyMode(size: "min")
                }
            }
        }
    }
}

struct RecordingMini_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
