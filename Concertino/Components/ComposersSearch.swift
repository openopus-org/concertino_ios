//
//  Composers.swift
//  Concertino
//
//  Created by Adriano Brandao on 01/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct ComposersSearch: View {
    @EnvironmentObject var composersSearch: ComposerSearchString
    @State private var composers = [Composer]()
    @State private var loading = true
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    func loadData() {
        if self.composersSearch.searchstring.count > 3 {
            APIget(AppConstants.openOpusBackend+"/composer/list/search/\(self.composersSearch.searchstring).json") { results in
                let composersData: Composers = parseJSON(results)
                
                DispatchQueue.main.async {
                    if let compo = composersData.composers {
                        self.composers = compo
                        self.loading = false
                    }
                }
            }
        }
        else if self.composersSearch.searchstring == "" {
            DispatchQueue.main.async {
                self.composers = [Composer]()
                self.loading = false
            }
        }
    }
    
    var body: some View {

        VStack(alignment: .leading) {
            Text("Search Results For: \(self.composersSearch.searchstring)".uppercased())
                .foregroundColor(Color(hex: 0x717171))
                .font(.custom("Nunito", size: 12))
                .padding(EdgeInsets(top: 12, leading: 20, bottom: 0, trailing: 0))
            if self.loading { Text("loading...") }
            List(self.composers, id: \.id) { composer in
                    ComposerRow(composer: composer)
            }
            .onAppear(perform: loadData)
            .onReceive(composersSearch.objectWillChange, perform: loadData)
            Spacer()
        }
        
    }
}

struct ComposersSearch_Previews: PreviewProvider {
    static var previews: some View {
        ComposersSearch()
    }
}
