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
    
    var body: some View {
        ScrollView {
            Button(action: {
                startRadio(userId: self.settingStore.userId, parameters: ["recommendedwork": "1"]) { results in
                    let worksData: Works = parseJSON(results)
                    
                    if let wrks = worksData.works {
                        DispatchQueue.main.async {
                            self.AppState.radioQueue = wrks
                             
                            randomRecording(work: self.AppState.radioQueue.removeFirst(), hideIncomplete: self.settingStore.hideIncomplete, country: self.settingStore.country) { rec in
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
                Text("Radio")
            })
        }
    }
}

struct Radio_Previews: PreviewProvider {
    static var previews: some View {
        Radio()
    }
}
