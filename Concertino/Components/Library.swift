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
                    OmnisearchField().padding(EdgeInsets(top: UIDevice.current.isLarge ? 9 : 14, leading: 20, bottom: UIDevice.current.isLarge ? 6 : 0, trailing: 20))
                    
                    ZStack(alignment: .top) {
                        Home().opacity(self.AppState.currentLibraryTab == "home" ? 1 : 0)
                        ComposersWorksSearch().opacity(self.AppState.currentLibraryTab == "composersearch" ? 1 : 0)
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .padding(.top, UIDevice.current.hasNotch ? -50 : UIDevice.current.isLarge ? -95 : -105)
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
