//
//  Library.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/01/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct Library: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                SearchField().padding(EdgeInsets(top: 9, leading: 20, bottom: 6, trailing: 20))
                ComposersList()
            }
        }
        //.background(Color.black.opacity(0))
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
