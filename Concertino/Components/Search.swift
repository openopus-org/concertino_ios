//
//  Search.swift
//  Concertino
//
//  Created by Adriano Brandao on 22/07/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct Search: View {
    @EnvironmentObject var AppState: AppState
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    OmnisearchField().padding(EdgeInsets(top: UIDevice.current.isLarge ? 9 : 14, leading: 10, bottom: UIDevice.current.isLarge ? 6 : 0, trailing: 10))
                    FreeSearch()
                    Spacer()
                }
            }
            .padding(.top, UIDevice.current.hasNotch ? -50 : -95)
            .padding(.bottom, -8)
        }
        .clipped()
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
