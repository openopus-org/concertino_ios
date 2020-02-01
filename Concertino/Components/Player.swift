//
//  Player.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/01/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct Player: View {
    @EnvironmentObject var AppState: AppState
    
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(gradient: Gradient(colors: [Color(hex: 0x4F4F4F), Color(hex: 0x2B2B2F)]), startPoint: .top, endPoint: .bottom)
                .frame(minHeight: 130, maxHeight: self.AppState.fullPlayer ? .infinity : 130)
            .cornerRadius(25)
            
        Button(
            action: { self.AppState.fullPlayer.toggle() },
            label: {
                Image("handle")
                .resizable()
                .frame(width: 7, height: 32)
                .foregroundColor(Color(hex: 0x696969))
                    .rotationEffect(.degrees(self.AppState.fullPlayer ? 90 : 270))
            })
        }
        .padding(EdgeInsets(top: 32, leading: 0, bottom: 46, trailing: 0))
    }
}

struct Player_Previews: PreviewProvider {
    static var previews: some View {
        Player()
    }
}
