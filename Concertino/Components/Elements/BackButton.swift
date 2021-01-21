//
//  BackButton.swift
//  Concertino
//
//  Created by Adriano Brandao on 14/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(
            action: { self.presentationMode.wrappedValue.dismiss() },
        label: {
            Image("handle")
            .resizable()
            .frame(width: 14, height: 36)
            .foregroundColor(Color.lightRed)
            .rotationEffect(.degrees(180))
            .padding(.trailing, 10)
        })
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton()
    }
}
