//
//  AddToPlaylist.swift
//  Concertino
//
//  Created by Adriano Brandao on 25/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct AddToPlaylist: View {
    @State var newPlaylistName = ""
    @State var playlistActive = ""
    @State var isLoading = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settingStore: SettingStore
    var recording: Recording
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                        .foregroundColor(Color(hex: 0xfe365e))
                        .font(.custom("Barlow", size: 14))
                })
                
                Spacer()
                
                Button(action: {
                    if !self.playlistActive.isEmpty || !self.newPlaylistName.isEmpty {
                        self.isLoading = true
                        APIpost("\(AppConstants.concBackend)/dyn/recording/addplaylist/", parameters: ["id": self.settingStore.userId, "auth": authGen(userId: self.settingStore.userId, userAuth: self.settingStore.userAuth) ?? "", "wid": self.recording.work!.id, "aid": self.recording.apple_albumid, "set": self.recording.set, "cover": self.recording.cover ?? AppConstants.concNoCoverImg, "performers": self.recording.jsonPerformers, "pid": (!self.playlistActive.isEmpty ? self.playlistActive : "new"), "name": (!self.newPlaylistName.isEmpty ? self.newPlaylistName : "useless"), "work": (self.recording.work!.composer!.id == "0" ? self.recording.work!.title : ""), "composer": (self.recording.work!.composer!.id == "0" ? self.recording.work!.composer!.complete_name : "")]) { results in
                        
                            print(String(decoding: results, as: UTF8.self))
                            let playlistRecording: PlaylistRecording = parseJSON(results)
                        
                            DispatchQueue.main.async {
                                self.settingStore.playlists = playlistRecording.list
                                self.isLoading = false
                                self.presentationMode.wrappedValue.dismiss()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                if let topMostViewController = UIApplication.shared.topMostViewController() {
                                    topMostViewController.showToast(message: "Added!")
                                }
                            }
                        }
                    }
                }, label: {
                    if self.isLoading {
                        ActivityIndicator(isAnimating: true)
                            .configure { $0.color = Color(hex: 0xfe365e).uiColor(); $0.style = .medium }
                    } else {
                        Text("Done")
                        .foregroundColor(Color(hex: 0xfe365e))
                        .font(.custom("Barlow-SemiBold", size: 14))
                    }
                })
            }
            
            Text("New Playlist".uppercased())
                .font(.custom("Nunito-ExtraBold", size: 13))
                .foregroundColor(Color(hex: 0xfe365e))
                .padding(.top, 26)
            Text("Create a new playlist and add this recording to it")
                .font(.custom("Barlow", size: 16))
                .padding(.bottom, 4)
            TextField("Playlist name", text: $newPlaylistName, onEditingChanged: { isEditing in
                    self.playlistActive = ""
            })
                .textFieldStyle(EditFieldStyle())
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.black)
                )
            
            Text("or".uppercased())
                .foregroundColor(Color(hex: 0x717171))
                .font(.custom("Nunito", size: 12))
                .padding(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: 0x717171), lineWidth: 1)
                )
                .padding(.top, 16)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Existing Playlist".uppercased())
                .font(.custom("Nunito-ExtraBold", size: 13))
                .foregroundColor(Color(hex: 0xfe365e))
            Text("Add this recording to an existing playlist")
                .font(.custom("Barlow", size: 16))
                .padding(.bottom, 4)
            
            ScrollView(showsIndicators: false) {
                ForEach(self.settingStore.playlists, id: \.id) { playlist in
                    Button(action: {
                        self.playlistActive = (self.playlistActive == playlist.id ? "" : playlist.id)
                        self.newPlaylistName = ""
                    }, label: {
                        PlaylistChooser(playlist: playlist, active: self.playlistActive == playlist.id)
                    })
                }
            }
            .gesture(DragGesture().onChanged{_ in self.endEditing(true) })
            
            Spacer()
        }
        .padding(30)
    }
}

struct AddToPlaylist_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
