//
//  PeriodDetail.swift
//  Concertino
//
//  Created by Adriano Brandao on 03/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct PeriodDetail: View {
    var period: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                PeriodHeader(period: period)
                    .padding(.top, 12)
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            PeriodDetailSearch(period: period)
            Spacer()
        }
    }
}

struct PeriodDetail_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
