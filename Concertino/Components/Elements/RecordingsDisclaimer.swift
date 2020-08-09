//
//  RecordingsDisclaimer.swift
//  Concertino
//
//  Created by Adriano Brandao on 15/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct RecordingsDisclaimer: View {
    var msg: String
    
    var body: some View {
        Text(msg)
            .font(.custom("Nunito-Regular", size: 12))
            .foregroundColor(Color(hex: 0xa7a6a6))
            .padding(15)
    }
}

struct RecordingsDisclaimer_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsDisclaimer(msg: "Disclaimer")
    }
}
