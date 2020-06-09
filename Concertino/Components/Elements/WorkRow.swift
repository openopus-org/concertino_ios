//
//  WorkRow.swift
//  Concertino
//
//  Created by Adriano Brandao on 12/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct WorkRow: View {
    var work: Work
    var composer: Composer
    @EnvironmentObject var settingStore: SettingStore
    
    var body: some View {
        NavigationLink(destination: WorkDetail(work: work, composer: composer).environmentObject(self.settingStore), label: {
            VStack(alignment: .leading) {
                Text(work.title)
                    .font(.custom("Barlow", size: 15))
                if work.subtitle != "" {
                    Text(work.subtitle!)
                        .font(.custom("Barlow", size: 12))
                }
            }
            .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 0))
        })
    }
}

struct WorkRow_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
