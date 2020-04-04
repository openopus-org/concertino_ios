//
//  Loader.swift
//  Concertino
//
//  Created by Adriano Brandao on 02/04/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct Loader: View {
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    Spacer()
                    
                    Image("vertical-logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 240, height: 128)
                    
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    
                    ActivityIndicator(isAnimating: true)
                        .configure { $0.color = .white; $0.style = .large }
                        .padding(.top, 244)
                    
                    Spacer()
                }
            }
            
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        Loader()
    }
}
