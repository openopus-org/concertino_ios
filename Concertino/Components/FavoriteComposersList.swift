//
//  FavoriteComposersList.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct FavoriteComposersList: View {
    let navigationLevel: Int
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var navigation: NavigationState
    @EnvironmentObject var search: WorkSearch
    @State private var composers = [Composer]()
    
    func loadData() {
        if self.settingStore.favoriteComposers.count > 0 {
            APIget(AppConstants.openOpusBackend+"/composer/list/ids/\((self.settingStore.favoriteComposers.map{String($0)}).joined(separator: ",")).json") { results in
                let composersData: Composers = parseJSON(results)
                DispatchQueue.main.async {
                    self.composers = composersData.composers ?? []
                }
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if composers.count > 0 {
                Text("Your Favorite Composers".uppercased())
                    .foregroundColor(Color(hex: 0x717171))
                    .font(.custom("Nunito", size: 12))
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 14) {
                        ForEach(self.composers, id: \.id) { composer in
                            NavigationLink(
                                destination: ComposerDetail(composer: composer, navigationLevel: self.navigationLevel + 1).environmentObject(self.settingStore).environmentObject(self.AppState).environmentObject(self.search),
                                        tag: String(describing: Self.self) + composer.id,
                                  selection: self.navigation.bindingForIdentifier(at: self.navigationLevel)) {
                                TinyComposerBox(composer: composer)
                            }
                        }
                    }
                    .frame(minHeight: 72)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
            }
        }
        .onAppear(perform: {
            if self.composers.count == 0 {
                print("🆗 favorite composers loaded from view appearance")
                self.loadData()
            }
        })
        .onReceive(settingStore.composersDidChange, perform: {
            print("🆗 favorite composers changed")
            self.loadData()
        })
    }
}

struct FavoriteComposersList_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
