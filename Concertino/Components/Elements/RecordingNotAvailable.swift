//
//  RecordingNotAvailable.swift
//  Concertino
//
//  Created by Adriano Brandao on 15/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct RecordingNotAvailable: View {
    var size: String
    
    var body: some View {
        HStack {
            Spacer()
            
            Image("forbidden")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size == "min" ? 18 : 26)
                .foregroundColor(Color(hex: size == "min" ? 0x797979 : 0xfe365e))
                .padding(.trailing, 2)
            VStack(alignment: .leading) {
                Text("Non-playable recording")
                    .font(.custom("Nunito-ExtraBold", size: size == "min" ? 11 : 15))
                Text("This album isn't available in your country")
                    .font(.custom("Nunito", size: size == "min" ? 9 : 13))
            }
            .foregroundColor(Color(hex: size == "min" ? 0x797979 : 0xfe365e))
            
            Spacer()
        }
    }
}

struct RecordingNotAvailable_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
