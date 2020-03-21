//
//  WorksRadioButton.swift
//  Concertino
//
//  Created by Adriano Brandao on 20/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct WorksRadioButton: View {
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var radioState: RadioState
    var genreId: String
    
    var body: some View {
        Button(
            action: {
                if self.radioState.isActive && self.radioState.genreId == self.genreId {
                    self.radioState.isActive = false
                    self.radioState.playlistId = ""
                    self.radioState.genreId = ""
                    self.radioState.nextWorks.removeAll()
                    self.radioState.nextRecordings.removeAll()
                } else {
                    var parameters = ["composer": self.genreId.split(separator: "-")[0]]
                    
                    if self.genreId.split(separator: "-")[1] == "Popular" {
                        parameters["popularwork"] = "1"
                    } else if self.genreId.split(separator: "-")[1] == "Recommended" {
                        parameters["recommendedwork"] = "1"
                    } else {
                        parameters["genre"] = self.genreId.split(separator: "-")[1]
                    }
                    
                    startRadio(userId: self.settingStore.userId, parameters: parameters) { results in
                        let worksData: Works = parseJSON(results)
                        
                        if let wrks = worksData.works {
                            DispatchQueue.main.async {
                                self.radioState.isActive = true
                                self.radioState.playlistId = ""
                                self.radioState.genreId = self.genreId
                                self.radioState.nextRecordings.removeAll()
                                self.radioState.nextWorks = wrks
                                 
                                randomRecording(work: self.radioState.nextWorks.removeFirst(), hideIncomplete: self.settingStore.hideIncomplete, country: self.settingStore.country) { rec in
                                    if rec.count > 0 {
                                        DispatchQueue.main.async {
                                            self.playState.autoplay = true
                                            self.playState.recording = rec
                                        }
                                    }
                                    else {
                                        print("⛔️ No recording")
                                    }
                                }
                            }
                        }
                    }
                }
            },
            label: {
                HStack {
                    HStack {
                        Spacer()
                        
                        AnimatedRadioIcon(color: Color(hex: 0xFFFFFF), isAnimated: self.radioState.isActive && self.radioState.genreId == self.genreId)
                            .frame(width: 40, height: 20)
                            .padding(.trailing, self.radioState.isActive && self.radioState.genreId == self.genreId ? 3 : -10)
                            .padding(.leading, self.radioState.isActive && self.radioState.genreId == self.genreId ? 0 : -10)
                            
                        Text((self.radioState.isActive && self.radioState.genreId == self.genreId ? "stop radio" : "start radio").uppercased())
                            .foregroundColor(.white)
                            .font(.custom("Nunito", size: self.radioState.isActive && self.radioState.genreId == self.genreId ? 11 : 13))
                        
                        Spacer()
                    }
                }
                .padding(13)
                .foregroundColor(.white)
                .background(Color(hex: self.radioState.isActive && self.radioState.genreId == self.genreId ? 0x696969 : 0xfe365e))
                .cornerRadius(16)
        })
        .buttonStyle(BorderlessButtonStyle())
        .padding(.bottom, 10)
        .padding(.top, 10)
    }
}

struct WorksRadioButton_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
