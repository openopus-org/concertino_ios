//
//  Composers.swift
//  Concertino
//
//  Created by Adriano Brandao on 01/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

class ComposersData: ObservableObject {
    @Published var dataIsLoaded: Bool = false
    @Published var composers = [Composer]()
    
    init() {
        loadData()
    }
    
    func loadData() {
        APIget(AppConstants.openOpusBackend+"/composer/list/pop.json") { results in
            let composersData: Composers = parseJSON(results)
            DispatchQueue.main.async {
                self.composers = composersData.composers ?? []
            }
        }
    }
}

struct ComposersList: View {
    let navigationLevel: Int
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var search: WorkSearch
    @EnvironmentObject var navigation: NavigationState
    @ObservedObject var composers = ComposersData()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Most Requested Composers".uppercased())
                .foregroundColor(Color(hex: 0x717171))
                .font(.custom("Nunito", size: 12))
                .padding(EdgeInsets(top: 12, leading: 20, bottom: 0, trailing: 0))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 14) {
                    ForEach(composers.composers) { composer in
                        NavigationLink(
                            destination: ComposerDetail(composer: composer, navigationLevel: self.navigationLevel + 1).environmentObject(self.settingStore).environmentObject(self.AppState).environmentObject(self.search),
                                    tag: String(describing: Self.self) + composer.id,
                              selection: self.navigation.bindingForIdentifier(at: self.navigationLevel)) {
                                ComposerBox(composer: composer)
                        }
                    }
                }
                .frame(minHeight: 174)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
        }
    }
}

struct ComposersList_Previews: PreviewProvider {
    static var previews: some View {
        ComposersList(navigationLevel: 0)
    }
}
