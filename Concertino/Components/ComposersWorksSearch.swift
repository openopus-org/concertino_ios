//
//  ComposerWorkSearch.swift
//  Concertino
//
//  Created by Adriano Brandao on 01/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct ComposerWorkSearch: View {
    @EnvironmentObject var omnisearch: OmnisearchString
    @State private var results = [OmniResults]()
    @State private var offset = 0
    @State private var loading = true
    
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
                        
                        print(results)
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
                        /*Text("Composers".uppercased())
                        .foregroundColor(Color(hex: 0x717171))
                        .font(.custom("Nunito", size: 12))
                        .padding(EdgeInsets(top: 7, leading: 20, bottom: 0, trailing: 0))*/
                        List(self.results, id: \.id) { result in
                            NavigationLink(destination: ComposerDetail(composer: result.composer)) {
                                ComposerRow(composer: result.composer)
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
        .frame(maxWidth: .infinity)
    }
}

struct ComposerWorkSearch_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
