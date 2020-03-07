//
//  Structure.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/01/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct Structure: View {
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var playState: PlayState
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Header()
                Spacer()
                
                ZStack(alignment: .top) {
                    Library().opacity(self.AppState.currentTab == "library" ? 1 : 0)
                    Favorites().opacity(self.AppState.currentTab == "favorites" ? 1 : 0)
                    Radio().opacity(self.AppState.currentTab == "radio" ? 1 : 0)
                    Settings().opacity(self.AppState.currentTab == "settings" ? 1 : 0)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: self.playState.recording.count > 0 ? 116 : 0, trailing: 0))
                    
                Spacer()
                TabMenu()
            }
            Player()
                .opacity(self.playState.recording.count > 0 ? 1 : 0)
        }
    }
}

struct Structure_Previews: PreviewProvider {
    static var previews: some View {
        Structure()
    }
}
