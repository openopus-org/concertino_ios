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
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Header()
                Spacer()
                if (self.AppState.currentTab == "library" || self.AppState.currentTab == "composersearch") {
                    SearchField().padding(EdgeInsets(top: 9, leading: 20, bottom: 6, trailing: 20))
                }
                ZStack(alignment: .top) {
                    Library().opacity(self.AppState.currentTab == "library" ? 1 : 0)
                    ComposersSearch().opacity(self.AppState.currentTab == "composersearch" ? 1 : 0)
                    Favorites().opacity(self.AppState.currentTab == "favorites" ? 1 : 0)
                    Radio().opacity(self.AppState.currentTab == "radio" ? 1 : 0)
                    Settings().opacity(self.AppState.currentTab == "settings" ? 1 : 0)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 116, trailing: 0))
                    
                Spacer()
                TabMenu()
            }
            Player()
        }
    }
}

struct Structure_Previews: PreviewProvider {
    static var previews: some View {
        Structure()
    }
}
