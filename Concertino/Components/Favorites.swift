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
            NavigationView {
                VStack {
                    PlaylistsMenu(playlistSwitcher: $playlistSwitcher)
                    PlaylistsRecordings(playlistSwitcher: $playlistSwitcher)
                }
            }
            .padding(.top, -50)
        }
        .clipped()
    }
}

struct Favorites_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
