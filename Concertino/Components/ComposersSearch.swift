//
//  Composers.swift
//  Concertino
//
//  Created by Adriano Brandao on 01/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

class ComposersSearchData: ObservableObject {
    @Published var dataIsLoaded: Bool = false
    @Published var composers = [Composer]()
    @Published var title: String = ""
    
    init() {
        loadData()
    }
    
    func loadData() {
        APIget(AppConstants.openOpusBackend+"/composer/list/rec.json") { results in
            let composersData: Composers = parseJSON(results)
            DispatchQueue.main.async {
                self.title = "Search Results"
                self.composers = composersData.composers ?? []
            }
        }
    }
}

struct ComposersSearch: View {
    @ObservedObject var composers = ComposersSearchData()
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        //if composers.dataIsLoaded {
        VStack(alignment: .leading) {
            Text(composers.title.uppercased())
                .foregroundColor(Color(hex: 0x717171))
                .font(.custom("Nunito", size: 12))
                .padding(EdgeInsets(top: 12, leading: 20, bottom: 0, trailing: 0))
            List(composers.composers, id: \.id) { composer in
                    ComposerRow(composer: composer)
                }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            Spacer()
        }
        
        //}
    }
}

struct ComposersSearch_Previews: PreviewProvider {
    static var previews: some View {
        ComposersSearch()
    }
}
