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
                    Spacer()
                        .frame(height: UIDevice.current.isLarge ? 0 : 10)
                    Home()
                    Spacer()
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .padding(.top, paddingCalc())
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
