//
//  TabButton.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/01/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct TabButton: View {
    @EnvironmentObject var AppState: AppState
    var icon: String
    var label: String
    var tab: String
    
    var body: some View {
        Button(
            action: { self.AppState.currentTab = self.tab },
            label: {
                VStack {
                    Spacer()
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color(hex: self.AppState.currentTab == self.tab ? 0xFE365E : 0x7C726E))
                        .frame(minHeight: 20)
                    Text(label)
                        .font(.custom("Nunito", size: 10))
                        .foregroundColor(Color(hex: self.AppState.currentTab == self.tab ? 0xFE365E : 0x7C726E))
                }
            })
            .frame(height: 40)
    }
}

struct TabButton_Previews: PreviewProvider {
    static var previews: some View {
        TabButton(icon: "radio", label: "Radio", tab: "radio")
    }
}
