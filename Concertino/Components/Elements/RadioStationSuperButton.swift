//
//  RadioStationButton.swift
//  Concertino
//
//  Created by Adriano Brandao on 28/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import URLImage

struct RadioStationSuperButton: View {
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
                
                getStoreFront() { countryCode in
                    if let country = countryCode {
                        APIget(AppConstants.concBackend+"/recording/\(country)/list/playlist/\(self.id).json") { results in
                            if let recsData: PlaylistRecordings = safeJSON(results) {
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
                                        
                                        getRecordingDetail(recording: rec, country: country) { recordingData in
                                            DispatchQueue.main.async {
                                                self.playState.autoplay = true
                                                self.playState.recording = recordingData
                                                self.isLoading = false
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.isLoading = false
                        }
                    }
                }
            },
            label: {
                HStack(alignment: .top) {  
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
                            Text(self.name)
                                
                                .foregroundColor(Color.white)
                                .font(.custom("Nunito-Regular", size: UIDevice.current.isLarge ? 16 : 13))
                                .padding(12)
                        }
                    }
                    
                    Spacer()
                }
                .background(
                    ZStack(alignment: .topLeading) {
                        URLImage(self.cover, placeholder: { _ in
                            Rectangle()
                                .fill(Color.extraDarkGray)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 138, maxHeight: 138, alignment: .topLeading)
                                .cornerRadius(20)
                        }) { img in
                            img.image
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 138, maxHeight: 138, alignment: .topLeading)
                        }
                        
                        LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .bottom, endPoint: .top)
                            .opacity(0.8)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 138, maxHeight: 138, alignment: .topLeading)
                    })
                .padding(0)
                .cornerRadius(20)
            })
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 138, maxHeight: 138, alignment: .topLeading)
    }
}

struct RadioStationSuperButton_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}

