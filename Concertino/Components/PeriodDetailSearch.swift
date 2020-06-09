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
    @Environment(\.navigationLevel) var level
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var search: WorkSearch
    @EnvironmentObject var navigation: NavigationState
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
            let composersData: Composers = parseJSON(results)
            
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
                    List(self.composers) { composer in
                        NavigationLink(
                            destination: ComposerDetail(composer: composer).environment(\.navigationLevel, self.level + 1).environmentObject(self.settingStore).environmentObject(self.AppState).environmentObject(self.search),
                                    tag: String(describing: Self.self) + composer.id,
                              selection: self.navigation.bindingForIdentifier(at: self.level)) {
                            ComposerRow(composer: composer)
                        }
                    }
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
