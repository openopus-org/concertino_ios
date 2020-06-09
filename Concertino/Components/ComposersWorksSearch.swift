//
//  ComposerWorkSearch.swift
//  Concertino
//
//  Created by Adriano Brandao on 01/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct ComposersWorksSearch: View {
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var omnisearch: OmnisearchString
    @EnvironmentObject var search: WorkSearch
    @EnvironmentObject var navigation: NavigationState
    @State private var results = [OmniResults]()
    @State private var offset = 0
    @State private var loading = true

    let navigationLevel = 0

    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    func loadData() {
        loading = true
        
        if self.omnisearch.searchstring.count > 3 {
            APIget(AppConstants.openOpusBackend+"/omnisearch/\(self.omnisearch.searchstring)/\(self.offset).json") { results in
                let omniData: Omnisearch = parseJSON(results)
                
                DispatchQueue.main.async {
                    
                    self.results.removeAll()
                    if let results = omniData.results {
                        self.results = results
                    }
                    else {
                        self.results = [OmniResults]()
                    }
                    
                    self.loading = false
                }
            }
        }
        else {
            DispatchQueue.main.async {
                self.results = [OmniResults]()
                self.loading = false
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if self.omnisearch.searchstring != "" {
                
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
                    if self.results.count > 0 {
                        List(self.results, id: \.id) { result in
                            Group {
                                if result.work != nil {
                                    NavigationLink(
                                        destination: WorkDetail(work: result.work!, composer: result.composer).environmentObject(self.settingStore),
                                                tag: String(describing: Self.self) + String(describing: WorkDetail.self) + result.id,
                                          selection: self.navigation.bindingForIdentifier(at: self.navigationLevel)) {
                                        WorkSearchRow(work: result.work!, composer: result.composer).padding(.vertical, 6)
                                    }
                                } else {
                                    NavigationLink(
                                        destination: ComposerDetail(composer: result.composer, navigationLevel: self.navigationLevel + 1).environmentObject(self.settingStore).environmentObject(self.AppState).environmentObject(self.search),
                                                tag: String(describing: Self.self) + String(describing: WorkDetail.self) + result.id,
                                          selection: self.navigation.bindingForIdentifier(at: self.navigationLevel)) {
                                        ComposerRow(composer: result.composer).padding(.vertical, 6)
                                    }
                                }
                            }
                        }
                        .gesture(DragGesture().onChanged{_ in self.endEditing(true) })
                    }
                    else {
                        ErrorMessage(msg: (self.omnisearch.searchstring.count > 3 ? "No matches for: \(self.omnisearch.searchstring)" : "Search term too short"))
                    }
                }
            }
            
            Spacer()
        }
        .onReceive(omnisearch.objectWillChange, perform: loadData)
        .onAppear(perform: {
            self.endEditing(true)
        })
        .frame(maxWidth: .infinity)
    }
}

struct ComposersWorksSearch_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
