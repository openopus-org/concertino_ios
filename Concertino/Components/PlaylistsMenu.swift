//
//  PlaylistsMenu.swift
//  Concertino
//
//  Created by Adriano Brandao on 04/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct PlaylistsMenu: View {
    @State var playlistActive = "fav"
    @State var playlistList = [Playlist]()
    @Binding var playlistSwitcher: PlaylistSwitcher
    @EnvironmentObject var settingStore: SettingStore
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 14) {
                    Button(action: {
                        self.playlistActive = "fav"
                        self.playlistSwitcher.playlist = "fav"
                    }, label: {
                        FavoritesButton(playlist: "fav", active: self.playlistActive == "fav")
                    })
                    
                    Button(action: {
                        self.playlistActive = "recent"
                        self.playlistSwitcher.playlist = "recent"
                    }, label: {
                        FavoritesButton(playlist: "recent", active: self.playlistActive == "recent")
                    })
                    
                    ForEach(self.playlistList, id: \.id) { playlist in
                        Button(action: {
                            self.playlistActive = playlist.id
                            self.playlistSwitcher.playlist = playlist.id
                        }, label: {
                            PlaylistButton(playlist: playlist, active: self.playlistActive == playlist.id)
                        })
                    }
                }
                .frame(minHeight: 98)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
            }
        }
        .onReceive(settingStore.playlistsDidChange, perform: {
            print("🆗 playlist changed")
            self.playlistList = self.settingStore.playlists
        })
        .onAppear(perform: {
            if self.playlistList.count == 0 {
                print("🆗 simply appeared")
                self.playlistList = self.settingStore.playlists
            }
        })
    }
}

struct PlaylistsMenu_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
