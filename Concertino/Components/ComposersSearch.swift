//
//  ComposerSearch.swift
//  Concertino
//
//  Created by Adriano Brandao on 27/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct ComposersSearch: View {
    let navigationLevel: Int
    @EnvironmentObject var composersSearch: ComposerSearchString
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var search: WorkSearch
    @State private var composers = [Composer]()
    @State private var loading = true
    
    init(navigationLevel: Int) {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear

        self.navigationLevel = navigationLevel
    }
    
    func loadData() {
        loading = true
        
        if self.composersSearch.searchstring.count > 3 {
            APIget(AppConstants.openOpusBackend+"/composer/list/search/\(self.composersSearch.searchstring).json") { results in
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
        else {
            DispatchQueue.main.async {
                self.composers = [Composer]()
                self.loading = false
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if self.composersSearch.searchstring != "" {
                
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
                        Text("Composers".uppercased())
                        .foregroundColor(Color(hex: 0x717171))
                        .font(.custom("Nunito", size: 12))
                        .padding(EdgeInsets(top: 7, leading: 20, bottom: 0, trailing: 0))
                        List(self.composers, id: \.id) { composer in
                            NavigationLink(destination: ComposerDetail(composer: composer, navigationLevel: self.navigationLevel + 1).environmentObject(self.settingStore).environmentObject(self.AppState).environmentObject(self.search)) {
                                ComposerRow(composer: composer)
                            }
                        }
                        .gesture(DragGesture().onChanged{_ in self.endEditing(true) })
                    }
                    else {
                        ErrorMessage(msg: (self.composersSearch.searchstring.count > 3 ? "No matches for: \(self.composersSearch.searchstring)" : "Search term too short"))
                    }
                }
            }
            Spacer()
        }
        .onReceive(composersSearch.objectWillChange, perform: loadData)
        .frame(maxWidth: .infinity)
    }
}

struct ComposersSearch_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
