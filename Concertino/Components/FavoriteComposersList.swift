//
//  FavoriteComposersList.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct FavoriteComposersList: View {
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var search: WorkSearch
    @State private var composers = [Composer]()
    
    func loadData() {
        if self.settingStore.favoriteComposers.count > 0 {
            APIget(AppConstants.openOpusBackend+"/composer/list/ids/\((self.settingStore.favoriteComposers.map{String($0)}).joined(separator: ",")).json") { results in
                if let composersData: Composers = safeJSON(results) {
                    DispatchQueue.main.async {
                        self.composers = composersData.composers ?? []
                    }
                }
            }
        } else {
            self.composers = []
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if composers.count > 0 {
                Text("Your Favorite Composers".uppercased())
                    
                    .foregroundColor(Color.gray)
                    .font(.custom("Nunito-Regular", size: 12))
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 14) {
                        ForEach(self.composers, id: \.id) { composer in
                            NavigationLink(destination: ComposerDetail(composer: composer, isSearch: false).environmentObject(self.settingStore).environmentObject(self.AppState).environmentObject(self.search)) {
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
