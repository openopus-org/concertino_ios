//
//  Radio.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/01/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct RadioBuilder: View {
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var radioState: RadioState
    @EnvironmentObject var mediaBridge: MediaBridge
    @EnvironmentObject var previewBridge: PreviewBridge
    @State private var isLoading = false
    @State private var selectedWorks = "All"
    @State private var selectedPeriods = "All"
    @State private var selectedGenres = "All"
    
    func initRadio() {
        var parameters = [String: String]()
        
        switch self.selectedWorks {
            case "wfav":
                parameters["work"] = "fav"
            case "wrec":
                parameters["recommendedwork"] = "1"
            case "rec":
                parameters["recommendedcomposer"] = "1"
            default:
                parameters["composer"] = self.selectedWorks
        }
        
        parameters["genre"] = self.selectedGenres
        parameters["epoch"] = self.selectedPeriods
        
        self.isLoading = true
        startRadio(userId: self.settingStore.userId, parameters: parameters) { results in
            if let worksData: Works = safeJSON(results) {
                print(String(decoding: results, as: UTF8.self))
                
                if let wrks = worksData.works {
                    DispatchQueue.main.async {
                        self.radioState.playlistId = ""
                        self.radioState.genreId = ""
                        self.radioState.nextRecordings.removeAll()
                        self.radioState.nextWorks = wrks
                        
                        getStoreFront() { countryCode in
                            if let country = countryCode {
                                randomRecording(workQueue: self.radioState.nextWorks, hideIncomplete: self.settingStore.hideIncomplete, country: country) { rec in
                                    if rec.count > 0 {
                                        DispatchQueue.main.async {
                                            self.isLoading = false
                                            self.radioState.isActive = true
                                            self.playState.autoplay = true
                                            self.playState.recording = rec
                                        }
                                    }
                                    else {
                                        DispatchQueue.main.async {
                                            self.isLoading = false
                                            alertError("No recordings were found.")
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        alertError("No works matching your criteria were found.")
                    }
                }

            }    
        }
    }
    
    var body: some View {
            VStack(alignment: .leading) {
                
                Group {
                    Text("Composers and works".uppercased())
                        
                        .foregroundColor(Color(hex: 0x717171))
                        .font(.custom("Nunito-Regular", size: 12))
                        .padding(.top, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 14) {
                            Button(action: { self.selectedWorks = "All" }, label: {
                                RadioSwitcher(name: "All", isPicture: false, isActive: self.selectedWorks == "All")
                                    .frame(maxWidth: .infinity)
                            })
                            Button(action: { self.selectedWorks = "fav" }, label: {
                                RadioSwitcher(name: "Favorites", isPicture: false, isActive: self.selectedWorks == "fav")
                                    .frame(maxWidth: .infinity)
                            })
                            Button(action: { self.selectedWorks = "rec" }, label: {
                                RadioSwitcher(name: "Recommended", isPicture: false, isActive: self.selectedWorks == "rec")
                                    .frame(maxWidth: .infinity)
                            })
                            Button(action: { self.selectedWorks = "wfav" }, label: {
                                RadioSwitcher(name: "Favorite works", isPicture: false, isActive: self.selectedWorks == "wfav")
                                    .frame(maxWidth: .infinity)
                            })
                            Button(action: { self.selectedWorks = "wrec" }, label: {
                                RadioSwitcher(name: "Essential works", isPicture: false, isActive: self.selectedWorks == "wrec")
                                    .frame(maxWidth: .infinity)
                            })
                        }
                        .frame(minHeight: 72)
                    }
                    
                    Text("and".uppercased())
                        
                        .foregroundColor(Color(hex: 0x717171))
                        .font(.custom("Nunito-Regular", size: 8))
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: 0x717171), lineWidth: 1)
                        )
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                Group {
                    Text("Periods".uppercased())
                        .foregroundColor(Color(hex: 0x717171))
                        .font(.custom("Nunito-Regular", size: 12))
                        
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 14) {
                            Button(action: { self.selectedPeriods = "All" }, label: {
                                RadioSwitcher(name: "All", isPicture: false, isActive: self.selectedPeriods == "All")
                                    .frame(maxWidth: .infinity)
                            })
                            ForEach(AppConstants.periodList, id: \.self) { period in
                                Button(action: { self.selectedPeriods = period }, label: {
                                    RadioSwitcher(name: period, isPicture: true, isActive: self.selectedPeriods == period)
                                        .frame(maxWidth: .infinity)
                                })
                            }
                        }
                        .frame(minHeight: 72)
                    }
                    
                    Text("and".uppercased())
                        
                        .foregroundColor(Color(hex: 0x717171))
                        .font(.custom("Nunito-Regular", size: 8))
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: 0x717171), lineWidth: 1)
                            )
                            .padding(.top, 10)
                            .frame(maxWidth: .infinity, alignment: .center)
                }
                
                Group {
                    Text("Genres".uppercased())
                        
                        .foregroundColor(Color(hex: 0x717171))
                        .font(.custom("Nunito-Regular", size: 12))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 14) {
                            Button(action: { self.selectedGenres = "All" }, label: {
                                RadioSwitcher(name: "All", isPicture: false, isActive: self.selectedGenres == "All")
                                    .frame(maxWidth: .infinity)
                            })
                            ForEach(AppConstants.genreList, id: \.self) { genre in
                                Button(action: { self.selectedGenres = genre }, label: {
                                    RadioSwitcher(name: genre, isPicture: false, isActive: self.selectedGenres == genre)
                                        .frame(maxWidth: .infinity)
                                })
                            }
                        }
                        .frame(minHeight: 72)
                    }
                }
                
                Button(action: {
                        if self.radioState.isActive {
                            self.radioState.isActive = false
                            self.radioState.nextWorks.removeAll()
                            self.radioState.nextRecordings.removeAll()
                            
                            if self.playState.preview {
                                self.previewBridge.stop()
                                if let firstrecording = self.playState.recording.first {
                                    self.previewBridge.setQueueAndPlay(tracks: firstrecording.previews!, starttrack: 0, autoplay: false, zeroqueue: false)
                                }
                            } else {
                                self.mediaBridge.stop()
                                if let firstrecording = self.playState.recording.first {
                                    self.mediaBridge.setQueueAndPlay(tracks: firstrecording.apple_tracks!, starttrack: firstrecording.apple_tracks!.first!, autoplay: false)
                                }
                            }
                        } else {
                            if self.settingStore.userId > 0 {
                                self.initRadio()
                            } else {
                                self.isLoading = true
                                userLogin(self.playState.autoplay) { country, canPlay, apmusEligible, loginResults in
                                    if let login = loginResults {
                                        
                                        DispatchQueue.main.async {
                                            self.settingStore.userId = login.user.id
                                            self.settingStore.lastLogged = Int(Date().millisecondsSince1970 / (60 * 1000) | 0)
                                            self.settingStore.country = country
                                            
                                            if let auth = login.user.auth {
                                                self.settingStore.userAuth = auth
                                            }
                                            
                                            if let favoritecomposers = login.favorite {
                                                self.settingStore.favoriteComposers = favoritecomposers
                                            }
                                            
                                            if let favoriteworks = login.works {
                                                self.settingStore.favoriteWorks = favoriteworks
                                            }
                                            
                                            if let composersfavoriteworks = login.composerworks {
                                                self.settingStore.composersFavoriteWorks = composersfavoriteworks
                                            }
                                            
                                            if let favoriterecordings = login.favoriterecordings {
                                                self.settingStore.favoriteRecordings = favoriterecordings
                                            }
                                            
                                            if let forbiddencomposers = login.forbidden {
                                                self.settingStore.forbiddenComposers = forbiddencomposers
                                            }
                                            
                                            if let playlists = login.playlists {
                                                self.settingStore.playlists = playlists
                                            }
                                            
                                            if let heavyuser = login.user.heavyuser {
                                                if heavyuser == 1 {
                                                    RequestAppStoreReview()
                                                }
                                            }
                                            
                                            self.initRadio()
                                        }
                                    } else {
                                        self.isLoading = false
                                    }
                                }
                            }
                        }
                    },
                    label: {
                        HStack {
                            HStack {
                                Spacer()
                                
                                if self.isLoading {
                                    ActivityIndicator(isAnimating: self.isLoading)
                                    .configure { $0.color = .white; $0.style = .medium }
                                } else {
                                    AnimatedRadioIcon(color: Color(hex: 0xFFFFFF), isAnimated: self.radioState.isActive)
                                        .frame(width: 40, height: 20)
                                        .padding(.trailing, self.radioState.isActive ? 3 : -10)
                                        .padding(.leading, self.radioState.isActive ? 0 : -10)
                                        
                                    Text((self.radioState.isActive ? "stop radio" : "start radio").uppercased())
                                        
                                        .foregroundColor(.white)
                                        .font(.custom("Nunito-Regular", size: self.radioState.isActive ? 11 : 13))
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(13)
                        .foregroundColor(.white)
                        .background(Color(hex: self.radioState.isActive ? 0x696969 : 0xfe365e))
                        .cornerRadius(16)
                })
                .padding(.top, 20)
                .padding(.trailing, 20)
        }
    }
}

struct RadioBuilder_Previews: PreviewProvider {
    static var previews: some View {
        Radio()
    }
}
