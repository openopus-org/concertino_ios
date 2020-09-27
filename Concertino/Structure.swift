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
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var radioState: RadioState
    @State private var showExternalDetail = false
    
    var body: some View {
        if #available(iOS 14.0, *) {
            ZStack(alignment: .bottom) {
                VStack {
                    if UIDevice.current.isLarge {
                        Header()
                        Spacer()
                    } else {
                        Spacer()
                            .frame(height: 2)
                    }
                    
                    ZStack(alignment: .top) {
                        Library().opacity(self.AppState.currentTab == "library" ? 1 : 0)
                        Search().opacity(self.AppState.currentTab == "search" ? 1 : 0)
                        Favorites().opacity(self.AppState.currentTab == "favorites" ? 1 : 0)
                        Radio().opacity(self.AppState.currentTab == "radio" ? 1 : 0)
                        Settings().opacity(self.AppState.currentTab == "settings" ? 1 : 0)
                    }
                    .padding(EdgeInsets(top: UIDevice.current.isLarge ? 0 : 0, leading: 0, bottom: self.playState.recording.count > 0 ? 130 : 0, trailing: 0))
                    
                    Spacer()
                    TabMenu()
                        .sheet(isPresented: $showExternalDetail) {
                            Group {
                                if self.AppState.externalUrl.count == 3 {
                                    ExternalRecordingSheet(workId: self.AppState.externalUrl[0], recordingId: self.AppState.externalUrl[1], recordingSet: Int(self.AppState.externalUrl[2]) ?? 1)
                                        .environmentObject(self.settingStore)
                                        .environmentObject(self.playState)
                                        .environmentObject(self.radioState)
                                        .environmentObject(self.AppState)
                                }
                            }
                        }
                        .onReceive(AppState.externalUrlWillChange, perform: {
                            //print(self.AppState.externalUrl)
                            self.showExternalDetail = (self.AppState.externalUrl.count == 3)
                        })
                }
                
                Player()
                    .opacity(self.playState.recording.count > 0 ? 1 : 0)
                    .padding(.bottom, UIDevice.current.hasNotch ? 0 : 12)
                    .padding(.top, UIDevice.current.isLarge ? 0 : 0)
                
                Loader().opacity(self.AppState.isLoading ? 1 : 0)
                
                Warning().opacity(self.AppState.showingWarning ? 1 : 0)
            }
            .ignoresSafeArea(.keyboard, edges: .all)
            
        } else {
            ZStack(alignment: .bottom) {
                VStack {
                    if UIDevice.current.isLarge {
                        Header()
                        Spacer()
                    } else {
                        Spacer()
                            .frame(height: 2)
                    }
                    
                    ZStack(alignment: .top) {
                        Library().opacity(self.AppState.currentTab == "library" ? 1 : 0)
                        Search().opacity(self.AppState.currentTab == "search" ? 1 : 0)
                        Favorites().opacity(self.AppState.currentTab == "favorites" ? 1 : 0)
                        Radio().opacity(self.AppState.currentTab == "radio" ? 1 : 0)
                        Settings().opacity(self.AppState.currentTab == "settings" ? 1 : 0)
                    }
                    .padding(EdgeInsets(top: UIDevice.current.isLarge ? 0 : 0, leading: 0, bottom: self.playState.recording.count > 0 ? 130 : 0, trailing: 0))
                    
                    Spacer()
                    TabMenu()
                }
                
                Player()
                    .opacity(self.playState.recording.count > 0 ? 1 : 0)
                    .padding(.bottom, UIDevice.current.hasNotch ? 0 : 12)
                    .padding(.top, UIDevice.current.isLarge ? 0 : 0)
                
                Loader().opacity(self.AppState.isLoading ? 1 : 0)
                
                Warning().opacity(self.AppState.showingWarning ? 1 : 0)
            }
            .sheet(isPresented: $showExternalDetail) {
                Group {
                    if self.AppState.externalUrl.count == 3 {
                        ExternalRecordingSheet(workId: self.AppState.externalUrl[0], recordingId: self.AppState.externalUrl[1], recordingSet: Int(self.AppState.externalUrl[2]) ?? 1)
                            .environmentObject(self.settingStore)
                            .environmentObject(self.playState)
                            .environmentObject(self.radioState)
                            .environmentObject(self.AppState)
                    }
                }
            }
            .onReceive(AppState.externalUrlWillChange, perform: {
                //print(self.AppState.externalUrl)
                self.showExternalDetail = (self.AppState.externalUrl.count == 3)
            })
        }
    }
}

struct Structure_Previews: PreviewProvider {
    static var previews: some View {
        Structure()
    }
}
