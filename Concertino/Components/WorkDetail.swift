//
//  WorkDetail.swift
//  Concertino
//
//  Created by Adriano Brandao on 14/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct WorkDetail: View {
    @EnvironmentObject var settingStore: SettingStore
    var work: Work
    var composer: Composer
    var isSearch: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                WorkHeader(work: work, composer: composer)
            }
            .padding(EdgeInsets(top: 12, leading: 20, bottom: 0, trailing: 20))
            RecordingsList(work: work)
            Spacer()
        }
        .onAppear(perform: {
            var compwork: Work
            compwork = self.work
            compwork.composer = self.composer
            if self.isSearch { self.settingStore.recentSearches = MarkSearched(allSearches: self.settingStore.recentSearches, recentSearch: RecentSearch (work: compwork)) }
        })
    }
}

struct WorkDetail_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
