//
//  RadioStationButton.swift
//  Concertino
//
//  Created by Adriano Brandao on 28/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import URLImage

struct RadioStationButton: View {
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var radioState: RadioState
    @EnvironmentObject var mediaBridge: MediaBridge
    @State private var isLoading = false
    var id: String
    var name: String
    var cover: URL
    
    var body: some View {
        Button(
            action: {
                self.isLoading = true
                APIget(AppConstants.concBackend+"/recording/\(self.settingStore.country.isEmpty ? "" : self.settingStore.country+"/" )list/playlist/\(self.id).json") { results in
                    let recsData: PlaylistRecordings = parseJSON(results)
                    
                    DispatchQueue.main.async {
                        if let recds = recsData.recordings {
                            var recs = recds
                            recs.shuffle()
                            
                            self.mediaBridge.stop()
                            self.radioState.isActive = true
                            self.radioState.playlistId = self.id
                            self.radioState.nextWorks.removeAll()
                            self.radioState.nextRecordings = recs
                            
                            let rec = self.radioState.nextRecordings.removeFirst()
                            
                            getRecordingDetail(recording: rec, country: self.settingStore.country) { recordingData in
                                DispatchQueue.main.async {
                                    self.playState.autoplay = true
                                    self.playState.recording = recordingData
                                    self.isLoading = false
                                }
                            }
                        }
                    }
                }
            },
            label: {
                VStack {
                    Spacer()
                    
                    if isLoading {
                        HStack {
                            Spacer()
                            CircleAnimation()
                                .frame(height: 100)
                            Spacer()
                        }
                        
                        Spacer()
                    } else {
                        Text(name)
                            .foregroundColor(Color.white)
                            .font(.custom("Nunito", size: 14))
                            .padding(12)
                    }
                }
                .frame(minWidth: 200, idealWidth: 200, maxWidth: 200, minHeight: 138, idealHeight: 138, maxHeight: 138, alignment: .topLeading)
                .background(
                    ZStack(alignment: .topLeading) {
                        URLImage(self.cover, placeholder: { _ in
                            Rectangle()
                                .fill(Color(hex: 0x2B2B2F))
                                .frame(minWidth: 200, idealWidth: 200, maxWidth: 200, minHeight: 138, idealHeight: 138, maxHeight: 138, alignment: .topLeading)
                                .cornerRadius(20)
                        }) { img in
                            img.image
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(minWidth: 200, idealWidth: 200, maxWidth: 200, minHeight: 138, idealHeight: 138, maxHeight: 138, alignment: .topLeading)
                        }
                        
                        LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .bottom, endPoint: .top)
                            .opacity(0.8)
                            .frame(minWidth: 200, idealWidth: 200, maxWidth: 200, minHeight: 138, idealHeight: 138, maxHeight: 138, alignment: .topLeading)
                    })
                .padding(0)
                .cornerRadius(20)
            })
            .frame(minWidth: 200, idealWidth: 200, maxWidth: 200, minHeight: 138, idealHeight: 138, maxHeight: 138, alignment: .topLeading)
    }
}

struct RadioStationButton_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
