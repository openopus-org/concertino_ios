//
//  WorkHeader.swift
//  Concertino
//
//  Created by Adriano Brandao on 14/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct WorkHeader: View {
    var work: Work
    var composer: Composer
    
    var body: some View {
        HStack {
            BackButton()
            VStack {
                VStack(alignment: .leading) {
                    
                    Text(composer.name.uppercased())
                        .foregroundColor(Color(hex: 0xfe365e))
                        .font(.custom("Nunito-ExtraBold", size: 17))
                    Group{
                        Text(work.title)
                        .font(.custom("Barlow-SemiBold", size: 17))
                        if work.subtitle != "" {
                            Text(work.subtitle!)
                            .font(.custom("Barlow", size: 14))
                        }
                    }
                    .foregroundColor(.white)
                    .lineLimit(20)
                    
                }
                .padding(8)
            }
            Spacer()
        }
        .onAppear(perform: { self.endEditing(true) })
    }
}

struct WorkHeader_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
