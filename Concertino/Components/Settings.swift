//
//  Settings.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/01/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject var settingStore: SettingStore
    @State private var supporters = [String]()
    
    func loadData() {
        APIget(AppConstants.openOpusBackend+"/patron/list.json") { results in
            if var supportersData: Supporters = safeJSON(results) {
                DispatchQueue.main.async {
                    supportersData.patrons.shuffle()
                    self.supporters = supportersData.patrons
                }
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section(header:
                    VStack(alignment: .leading) {
                        Text("Library filters".uppercased())
                            .font(.custom("Nunito-ExtraBold", size: 13))
                            .foregroundColor(Color(hex: 0xfe365e))
                        /*if #available(iOS 14.0, *) {
                            Text("Automatic filters that try to eliminate bad or undesirable recordings from the library. They are not perfect, but definitely can improve your playing experience.")
                                .textCase(.none)
                                .font(.custom("Barlow-Regular", size: 13))
                                .foregroundColor(.white)
                                .lineLimit(20)
                        } else {*/
                            // Fallback on earlier versions
                            
                            Text("Automatic filters that try to eliminate bad or undesirable recordings from the library. They are not perfect, but definitely can improve your playing experience.")
                                .font(.custom("Barlow-Regular", size: 13))
                                .foregroundColor(.white)
                                .lineLimit(20)
                        //}
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 16)
                    ){
                        Toggle(isOn: self.$settingStore.hideIncomplete) {
                            Text("Hide incomplete recordings")
                            .font(.custom("Barlow-Regular", size: 16))
                        }
                        .listRowBackground(Color.black)
                    
                        Toggle(isOn: self.$settingStore.hideHistorical) {
                            Text("Hide old, historical recordings")
                            .font(.custom("Barlow-Regular", size: 16))
                        }
                        .listRowBackground(Color.black)
                }
                
                Section(header:
                    Text("About".uppercased())
                        .font(.custom("Nunito-ExtraBold", size: 13))
                        .foregroundColor(Color(hex: 0xFE365E))
                    ){
                        SettingsMenuItem(title: "Version", description: AppConstants.version)
                            .listRowBackground(Color.black)
                        Button(
                            action: { UIApplication.shared.open(URL(string: "https://patreon.com/openopus")!) },
                            label: {
                                SettingsMenuItem(title: "Support our projects", description: "Help us keeping Concertino free! Donate and back our development and hosting costs.")
                        })
                            .listRowBackground(Color.black)
                    
                        Button(
                            action: { UIApplication.shared.open(URL(string: "https://github.com/openopus-org/concertino_ios")!) },
                            label: {
                                SettingsMenuItem(title: "Contribute with code", description: "Concertino is an open source project. You may fork it or help us with code!")
                        })
                            .listRowBackground(Color.black)
                    
                        Button(
                            action: { UIApplication.shared.open(URL(string: "https://twitter.com/concertinoapp")!) },
                            label: {
                                SettingsMenuItem(title: "Find us on Twitter", description: "And tell us how has been your experience with Concertino so far!")
                        })
                            .listRowBackground(Color.black)
                }
                
                Section(header:
                    Text("Thanks for our supporters".uppercased())
                        .font(.custom("Nunito-ExtraBold", size: 13))
                        .foregroundColor(Color(hex: 0xFE365E))
                    ){
                        ForEach(supporters, id: \.self) { supporter in
                            SettingsMenuItem(title: supporter)
                        }
                        .listRowBackground(Color.black)
                }
            }
            .listStyle(GroupedListStyle())
        }
        .onAppear(perform: {
            if self.supporters.count == 0 {
                print("🆗 supporters loaded from appearance")
                self.loadData()
            }
        })
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
