//
//  PeriodHeader.swift
//  Concertino
//
//  Created by Adriano Brandao on 03/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct PeriodHeader: View {
    var period: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            BackButton()
            Text(period)
                .font(.custom("Barlow-SemiBold", size: 17))
        }
    }
}

struct PeriodHeader_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
