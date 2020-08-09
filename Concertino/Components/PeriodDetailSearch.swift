//
//  PeriodDetail.swift
//  Concertino
//
//  Created by Adriano Brandao on 03/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct PeriodDetailSearch: View {
    let period: String
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var search: WorkSearch
    @State private var composers = [Composer]()
    @State private var loading = true
    
    init(period: String) {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        
        self.period = period
    }
    
    func loadData() {
        loading = true
        
        APIget(AppConstants.openOpusBackend+"/composer/list/epoch/\(self.period).json") { results in
            if let composersData: Composers = safeJSON(results) {
                DispatchQueue.main.async {
                    if let compo = composersData.composers {
                        self.composers = compo
                    }
                    else {
                        self.composers = [Composer]()
                    }
                    
                    self.loading = false
                }
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if self.loading {
                HStack {
                    Spacer()
                    ActivityIndicator(isAnimating: loading)
                    .configure { $0.color = .white; $0.style = .large }
                    Spacer()
                }
                .padding(40)
            }
            else {
                if self.composers.count > 0 {
                    List {
                        ForEach(self.composers, id: \.id) { composer in
                            NavigationLink(destination: ComposerDetail(composer: composer, isSearch: false).environmentObject(self.settingStore).environmentObject(self.AppState).environmentObject(self.search)) {
                                ComposerRow(composer: composer)
                            }
                        }
                        
                        RecordingsDisclaimer(msg: "This list is only a curated selection of composers of the period. You can find recordings of works by several other composers on the search tab below.")
                            .padding(15)
                    }
                    .listStyle(DefaultListStyle())
                }
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .onAppear(perform: {
            self.endEditing(true)
            
            if self.composers.count == 0 {
                self.loadData()
            }
        })
    }
}

struct PeriodDetailSearch_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
