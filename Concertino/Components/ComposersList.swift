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
            if let composersData: Composers = safeJSON(results) {
                DispatchQueue.main.async {
                    self.composers = composersData.composers ?? []
                }
            }
        }
    }
}

struct ComposersList: View {
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var search: WorkSearch
    @ObservedObject var composers = ComposersData()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Most Requested Composers".uppercased())
                
                .foregroundColor(Color.gray)
                .font(.custom("Nunito-Regular", size: 12))
                .padding(EdgeInsets(top: 12, leading: 20, bottom: 0, trailing: 0))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 14) {
                    ForEach(composers.composers, id: \.id) { composer in
                        NavigationLink(destination: ComposerDetail(composer: composer, isSearch: false).environmentObject(self.settingStore).environmentObject(self.AppState).environmentObject(self.search)) {
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
        ComposersList()
    }
}
