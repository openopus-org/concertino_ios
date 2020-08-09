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
            /*if #available(iOS 14.0, *) {
                NavigationView {
                    VStack {
                        Home()
                        Spacer()
                    }
                }
                .padding(.top, UIDevice.current.hasNotch ? -100 : UIDevice.current.isLarge ? -145 : -155)
                .padding(.bottom, -8)
            } else {*/
                NavigationView {
                    VStack {
                        Home()
                        Spacer()
                    }
                }
                .padding(.top, UIDevice.current.hasNotch ? -50 : UIDevice.current.isLarge ? -95 : -105)
                .padding(.bottom, -8)
            //}
        }
        .clipped()
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
