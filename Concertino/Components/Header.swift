//
//  Header.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/01/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct Header: View {
    var body: some View {
        Image("logo")
            .resizable()
            .scaledToFit()
            .frame(height: UIDevice.current.hasNotch ? 22 : 18)
            .padding(.top, UIDevice.current.hasNotch ? 0 : 6)
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header()
    }
}
