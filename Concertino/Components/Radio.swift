//
//  Radio.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/01/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct Radio: View {
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var radioState: RadioState
    
    var body: some View {
        ScrollView {
            Button(action: {
                startRadio(userId: self.settingStore.userId, parameters: ["recommendedwork": "1"]) { results in
                    let worksData: Works = parseJSON(results)
                    
                    if let wrks = worksData.works {
                        DispatchQueue.main.async {
                            self.radioState.isActive = true
                            self.radioState.playlistId = ""
                            self.radioState.genreId = ""
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
            }, label: {
                VStack {
                    AnimatedRadioIcon(color: Color(hex: 0xfe365e), isAnimated: true)
                        .frame(width: 120, height: 60)
                    AnimatedRadioIcon(color: Color(hex: 0xfe365e), isAnimated: false)
                        .frame(width: 240, height: 120)
                    Text("Radio")
                }
            })
        }
    }
}

struct Radio_Previews: PreviewProvider {
    static var previews: some View {
        Radio()
    }
}
