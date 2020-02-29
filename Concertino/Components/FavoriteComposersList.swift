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
    @State private var composers = [Composer]()
    @State private var loading = true
    
    func loadData() {
        APIget(AppConstants.concBackend+"/user/\(self.settingStore.userId)/composer/fav.json", userToken: nil) { results in
            let composersData: Composers = parseJSON(results)
            DispatchQueue.main.async {
                self.composers = composersData.composers ?? []
            }
        }
    }
    
    var body: some View {
        //if composers.dataIsLoaded {
        VStack(alignment: .leading) { 
            Text("Your Favorite Composers".uppercased())
                .foregroundColor(Color(hex: 0x717171))
                .font(.custom("Nunito", size: 12))
                .padding(EdgeInsets(top: 12, leading: 20, bottom: 0, trailing: 0))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 14) {
                    ForEach(self.composers, id: \.id) { composer in
                        NavigationLink(destination: ComposerDetail(composer: composer)) {
                            TinyComposerBox(composer: composer)
                        }
                    }
                }
                .frame(minHeight: 72)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
        }
        .onAppear(perform: loadData)
        //}
    }
}

struct FavoriteComposersList_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
