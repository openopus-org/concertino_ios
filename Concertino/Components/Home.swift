//
//  Library.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/01/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var settingStore: SettingStore
    var navigationLevel = 0
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                ComposersList(navigationLevel: navigationLevel)
                PeriodList(navigationLevel: navigationLevel)
                FavoriteComposersList(navigationLevel: navigationLevel)
                RadioStations()
                RecentReleases(navigationLevel: navigationLevel)
                Spacer()
                    .frame(height: 26)
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
