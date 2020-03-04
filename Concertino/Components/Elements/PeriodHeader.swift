//
//  PeriodHeader.swift
//  Concertino
//
//  Created by Adriano Brandao on 03/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct PeriodHeader: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        BackButton()
    }
}

struct PeriodHeader_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
