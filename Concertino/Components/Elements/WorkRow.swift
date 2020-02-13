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
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text(work.title)
                .font(.custom("Barlow", size: 15))
            if work.subtitle != nil {
                Text(work.subtitle!)
                    .font(.custom("Barlow", size: 12))
            }
        }
        .padding(EdgeInsets(top: 8, leading: 2, bottom: (work.subtitle != nil ? 15 : 0), trailing: 0))
    }
}

struct WorkRow_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
