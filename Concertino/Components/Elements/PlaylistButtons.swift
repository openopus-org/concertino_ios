//
//  PlaylistButtons.swift
//  Concertino
//
//  Created by Adriano Brandao on 17/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct PlaylistButtons: View {
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var settingStore: SettingStore
    var recordings: [Recording]
    
    var body: some View {
        HStack(spacing: 6) {
            Button(
                action: {
                    var recs = self.recordings
                    recs.shuffle()
                    
                    self.AppState.radioNextRecordings = recs
                    let rec = self.AppState.radioNextRecordings.removeFirst()
                    
                    getRecordingDetail(recording: rec, country: self.settingStore.country) { recordingData in
                        DispatchQueue.main.async {
                            self.playState.autoplay = true
                            self.playState.recording = recordingData
                        }
                    }
                },
                label: {
                    HStack {
                        HStack {
                            Spacer()
                            
                            Image("radio")
                                .resizable()
                                .frame(width: 7, height: 14)
                                .foregroundColor(Color(hex: 0x696969))
                                .rotationEffect(.degrees(90))
                                .padding(.trailing, 8)
                            
                            Text("start radio".uppercased())
                                .foregroundColor(Color(hex: 0xfe365e))
                                .font(.custom("Nunito", size: 14))
                            
                            Spacer()
                        }
                    }
                    .padding(15)
                    .foregroundColor(.white)
                    .background(Color(hex: 0x2B2B2F))
                    .cornerRadius(16)
            })
            
            Button(
                action: {  },
                label: {
                    HStack {
                        HStack {
                            Spacer()
                            
                            Image("edit")
                                .resizable()
                                .frame(width: 7, height: 14)
                                .foregroundColor(Color(hex: 0xfe365e))
                                .rotationEffect(.degrees(90))
                                .padding(.trailing, 8)
                            
                            Text("edit playlist".uppercased())
                                .foregroundColor(Color(hex: 0xfe365e))
                                .font(.custom("Nunito", size: 14))
                            
                            Spacer()
                        }
                    }
                    .padding(15)
                    .foregroundColor(.white)
                    .background(Color(hex: 0x2B2B2F))
                    .cornerRadius(16)
            })
        }
    }
}

struct PlaylistButtons_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
