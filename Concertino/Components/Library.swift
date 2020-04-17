//
//  Library.swift
//  Concertino
//
//  Created by Adriano Brandao on 10/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct Library: View {
    @EnvironmentObject var AppState: AppState
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    OmnisearchField().padding(EdgeInsets(top: 9, leading: 20, bottom: 6, trailing: 20))
                    
                    ZStack(alignment: .top) {
                        Home().opacity(self.AppState.currentLibraryTab == "home" ? 1 : 0)
                        ComposersWorksSearch().opacity(self.AppState.currentLibraryTab == "composersearch" ? 1 : 0)
                    }
                }
            }
            .padding(.top, UIDevice.current.hasNotch ? -50 : -95)
            .padding(.bottom, -8)
        }
        .clipped()
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
