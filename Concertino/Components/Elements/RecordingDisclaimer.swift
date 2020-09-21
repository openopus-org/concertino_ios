//
//  RecordingDisclaimer.swift
//  Concertino
//
//  Created by Adriano Brandao on 17/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct RecordingDisclaimer: View {
    var isVerified: Bool
    
    var body: some View {
        HStack {
            Spacer()
            
            Image(isVerified ? "checked" : "warning")
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
                    
            Text(isVerified ? "This recording was verified by a human and its metadata were considered right." : "This recording was fetched automatically with no human verification.")
                .font(.custom("Nunito-Regular", size: 10))
                .lineLimit(20)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .foregroundColor(Color(hex: 0xa7a6a6))
        .padding(EdgeInsets(top: 20, leading: 30, bottom: 30, trailing: 30))
    }
}

struct RecordingDisclaimer_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
