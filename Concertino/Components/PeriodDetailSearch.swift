//
//  PeriodDetail.swift
//  Concertino
//
//  Created by Adriano Brandao on 03/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct PeriodDetail: View {
    let period: String
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
                    List(self.composers, id: \.id) { composer in
                        NavigationLink(destination: ComposerDetail(composer: composer)) {
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

struct PeriodDetail_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
