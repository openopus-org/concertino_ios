//
//  PeriodList.swift
//  Concertino
//
//  Created by Adriano Brandao on 03/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct PeriodList: View {
    var navigationLevel: Int
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var search: WorkSearch
    @EnvironmentObject var navigation: NavigationState
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Browse by period".uppercased())
                .foregroundColor(Color(hex: 0x717171))
                .font(.custom("Nunito", size: 12))
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 14) {
                    ForEach(AppConstants.periodList, id: \.self) { period in
                        NavigationLink(
                            destination: PeriodDetail(period: period, navigationLevel: self.navigationLevel + 1).environmentObject(self.settingStore).environmentObject(self.AppState).environmentObject(self.search), 
                                    tag: String(describing: Self.self) + period,
                              selection: self.navigation.bindingForIdentifier(at: self.navigationLevel)) {
                            PeriodBox(period: period)
                        }
                    }
                }
                .frame(minHeight: 98)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
        }
    }
}

struct PeriodList_Previews: PreviewProvider {
    static var previews: some View {
        PeriodList(navigationLevel: 0)
    }
}

