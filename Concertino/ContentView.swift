//
//  ContentView.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/01/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    //@EnvironmentObject var AppState: AppState
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: 0x121212)
                .edgesIgnoringSafeArea(.all)
            LinearGradient(gradient: Gradient(colors: [Color(hex: 0x3C3C3C), Color(hex: 0x121212)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                .frame(height: 60)
            Structure()
        }
        .foregroundColor(.white)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



