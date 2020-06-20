//
//  FullLoader.swift
//  Concertino
//
//  Created by Adriano Brandao on 16/06/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct FullLoader: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            HStack(alignment: .top) {
                Spacer()
                
                ActivityIndicator(isAnimating: true)
                    .configure { $0.color = .white; $0.style = .large }
                
                Spacer()
            }
            
            Spacer()
        }
        .background(Color.black)
    }
}

struct FullLoader_Previews: PreviewProvider {
    static var previews: some View {
        FullLoader()
    }
}
