//
//  ErrorMessage.swift
//  Concertino
//
//  Created by Adriano Brandao on 14/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct ErrorMessage: View {
    var msg: String
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                Image("warning")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(hex: 0xa7a6a6))
                    .frame(height: 28)
                    .padding(5)
                Text(msg)
                    .foregroundColor(Color(hex: 0xa7a6a6))
                    .font(.custom("Barlow", size: 14))
            }
        }.padding(15)
    }
}

struct ErrorMessage_Previews: PreviewProvider {
    static var previews: some View {
        ErrorMessage(msg: "Error")
    }
}
