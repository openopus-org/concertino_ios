//
//  TabMenu.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/01/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct TabMenu: View {
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var navigation: NavigationState

    func didTapTabButton(named name: String) {
        if AppState.fullPlayer == false, name == "library", name == AppState.currentTab {
            navigation.popAll()
        } else {
            AppState.fullPlayer = false
            AppState.currentTab = name
        }
    }

    var body: some View {
        HStack {
            Spacer()
            TabButton(icon: "library", label: "Library", tab: "library", action: self.didTapTabButton(named:))
            Spacer()
            TabButton(icon: "favorites", label: "Favorites", tab: "favorites", action: self.didTapTabButton(named:))
            Spacer()
            TabButton(icon: "radio", label: "Radio", tab: "radio", action: self.didTapTabButton(named:))
            Spacer()
            TabButton(icon: "settings", label: "Settings", tab: "settings", action: self.didTapTabButton(named:))
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
