//
//  PeriodBox.swift
//  Concertino
//
//  Created by Adriano Brandao on 03/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct PeriodBox: View {
    var period: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(period)
                .foregroundColor(Color.white)
                .font(.custom("Barlow", size: 13))
                .padding(12)
            
            Spacer()
        }
        .frame(minWidth: 100, maxWidth: 100, minHeight: 108,  maxHeight: 108, alignment: .topLeading)
        .background(
            ZStack(alignment: .topLeading) {
                Image(period.lowercased())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 110, height: 110)
                
                LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .top, endPoint: .bottom)
                    .opacity(0.7)
                    .frame(width: 110, height: 90)
            })
        .padding(0)
        .cornerRadius(12)
    }
}

struct PeriodBox_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
