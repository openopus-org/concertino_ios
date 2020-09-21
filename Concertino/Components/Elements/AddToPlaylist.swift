//
//  AddToPlaylist.swift
//  Concertino
//
//  Created by Adriano Brandao on 25/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct AddToPlaylistButtons: View {
    @Binding var newPlaylistName: String
    @Binding var playlistActive: String
    @State var isLoading = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settingStore: SettingStore
    var recording: Recording

    var body: some View {
        HStack {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Cancel")
                    .foregroundColor(Color(hex: 0xfe365e))
                    .font(.custom("Barlow-Regular", size: 14))
            })
            
            Spacer()
            
            Button(action: {
                if !self.playlistActive.isEmpty || !self.newPlaylistName.isEmpty {
                    self.isLoading = true
                    APIpost("\(AppConstants.concBackend)/dyn/recording/addplaylist/", parameters: ["id": self.settingStore.userId, "auth": authGen(userId: self.settingStore.userId, userAuth: self.settingStore.userAuth) ?? "", "wid": self.recording.work!.id, "aid": self.recording.apple_albumid, "set": self.recording.set, "cover": self.recording.cover ?? AppConstants.concNoCoverImg, "performers": self.recording.jsonPerformers, "pid": (!self.playlistActive.isEmpty ? self.playlistActive : "new"), "name": (!self.newPlaylistName.isEmpty ? self.newPlaylistName : "useless"), "work": (self.recording.work!.id.contains("at*") ? self.recording.work!.title : ""), "composer": (self.recording.work!.composer!.id == "0" ? self.recording.work!.composer!.complete_name : (self.recording.work!.id.contains("at*") ? self.recording.work!.composer!.name : ""))]) { results in
                    
                        print(String(decoding: results, as: UTF8.self))
                        if let playlistRecording: PlaylistRecording = safeJSON(results) {
                            DispatchQueue.main.async {
                                self.settingStore.playlists = playlistRecording.list
                                self.isLoading = false
                                self.presentationMode.wrappedValue.dismiss()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                if let topMostViewController = UIApplication.shared.topMostViewController() {
                                    topMostViewController.showToast(message: "Added!", image: "checked", text: nil)
                                }
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
    }
}

struct AddToPlaylist: View {
    @State var newPlaylistName = ""
    @State var playlistActive = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settingStore: SettingStore
    var recording: Recording
    
    var body: some View {
        VStack(alignment: .leading) {
            //if !UIDevice.current.is14 {
                AddToPlaylistButtons(newPlaylistName: self.$newPlaylistName, playlistActive: self.$playlistActive, recording: self.recording)
                .padding(.bottom, 26)
            //}
            
            Text("New Playlist".uppercased())
                .font(.custom("Nunito-ExtraBold", size: 13))
                .foregroundColor(Color(hex: 0xfe365e))
            Text("Create a new playlist and add this recording to it")
                .font(.custom("Barlow-Regular", size: 16))
                .foregroundColor(Color.white)
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
                .font(.custom("Nunito-Regular", size: 12))
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
                .font(.custom("Barlow-Regular", size: 16))
                .foregroundColor(Color.white)
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
