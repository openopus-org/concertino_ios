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
    @Published var title: String = ""
    
    init() {
        loadData()
    }
    
    func loadData() {
        APIget(AppConstants.openOpusBackend+"/composer/list/pop.json") { results in
            let composersData: Composers = parseJSON(results)
            DispatchQueue.main.async {
                self.title = "Most Requested Composers"
                self.composers = composersData.composers ?? []
            }
        }
    }
}

struct ComposersList: View {
    @ObservedObject var composers = ComposersData()
    
    var body: some View {
        //if composers.dataIsLoaded {
        VStack(alignment: .leading) {
            Text(composers.title.uppercased())
                .foregroundColor(Color(hex: 0x717171))
                .font(.custom("Nunito", size: 12))
                .padding(EdgeInsets(top: 12, leading: 20, bottom: 0, trailing: 0))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 14) {
                    ForEach(composers.composers, id: \.id) { composer in
                        ComposerRow(composer: composer)
                    }
                }
                .frame(minHeight: 174)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
        }
        //}
    }
}

struct ComposersList_Previews: PreviewProvider {
    static var previews: some View {
        ComposersList()
    }
}
