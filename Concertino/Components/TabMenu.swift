//
//  TabMenu.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/01/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct TabMenu: View {
    var body: some View {
        HStack {
            Spacer()
            TabButton(icon: "library", label: "Library", tab: "library")
            Spacer()
            TabButton(icon: "favorites", label: "Favorites", tab: "favorites")
            Spacer()
            TabButton(icon: "radio", label: "Radio", tab: "radio")
            Spacer()
            TabButton(icon: "settings", label: "Settings", tab: "settings")
            Spacer()
        }
        .padding(.bottom, UIDevice.current.hasNotch ? 0 : 12)
    }
}

struct TabMenu_Previews: PreviewProvider {
    static var previews: some View {
        TabMenu()
    }
}
