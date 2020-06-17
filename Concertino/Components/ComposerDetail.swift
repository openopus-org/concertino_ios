//
//  ComposerDetail.swift
//  Concertino
//
//  Created by Adriano Brandao on 11/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct ComposerDetailv1: View {
    var composer: Composer
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                ComposerHeader(composer: composer)
                    .padding(.top, 12)
                GenreBar(composerId: composer.id)
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            
            WorksSearch(composer: composer)
            
            Spacer()
        }
    }
}

struct ComposerDetailv1_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
