//
//  Favorites.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/01/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct Favorites: View {
    @State private var playlistSwitcher = PlaylistSwitcher()
    
    var body: some View {
        VStack {
            /*
            if #available(iOS 14.0, *) {
                NavigationView {
                    VStack {
                        PlaylistsMenu(playlistSwitcher: $playlistSwitcher)
                        PlaylistsRecordings(playlistSwitcher: $playlistSwitcher)
                        Spacer()
                    }
                }
                .padding(.top, UIDevice.current.hasNotch ? -100 : -145)
                .padding(.bottom, -8)
            } else {*/
                NavigationView {
                    VStack {
                        PlaylistsMenu(playlistSwitcher: $playlistSwitcher)
                        PlaylistsRecordings(playlistSwitcher: $playlistSwitcher)
                        Spacer()
                    }
                }
                .padding(.top, UIDevice.current.hasNotch ? -50 : -95)
                .padding(.bottom, -8)
            //}
        }
        .clipped()
    }
}

struct Favorites_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
