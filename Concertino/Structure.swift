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
        VStack {
            Header()
            Spacer()
            if self.AppState.currentTab == "library" { Library() }
            if self.AppState.currentTab == "favorites" { Favorites() }
            if self.AppState.currentTab == "radio" { Radio() }
            if self.AppState.currentTab == "settings" { Settings() }
            Spacer()
            Player()
            Spacer()
            TabMenu()
        }
        
    }
}

struct Structure_Previews: PreviewProvider {
    static var previews: some View {
        Structure()
    }
}
