//
//  WorkDetail.swift
//  Concertino
//
//  Created by Adriano Brandao on 14/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct WorkDetail: View {
    var work: Work
    var composer: Composer
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                WorkHeader(work: work, composer: composer)
                /*Text("Recordings".uppercased())
                    .foregroundColor(Color(hex: 0x717171))
                    .font(.custom("Nunito", size: 12))*/
            }
            .padding(EdgeInsets(top: 12, leading: 20, bottom: 0, trailing: 20))
            RecordingsList(work: work)
            Spacer()
        }
    }
}

struct WorkDetail_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
