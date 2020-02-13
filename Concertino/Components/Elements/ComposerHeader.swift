//
//  ComposerDetail.swift
//  Concertino
//
//  Created by Adriano Brandao on 10/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import URLImage

struct ComposerDetail: View {
    var composer: Composer
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            Button(
                action: { self.presentationMode.wrappedValue.dismiss() },
            label: {
                Image("handle")
                .resizable()
                .frame(width: 14, height: 36)
                .foregroundColor(Color(hex: 0xfe365e))
                .rotationEffect(.degrees(180))
                .padding(.trailing, 10)
            })
            URLImage(composer.portrait) { img in
                img.image
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .clipShape(Circle())
            }
            .frame(width: 72, height: 72)
            VStack {
                VStack(alignment: .leading) {
                    
                    Text(composer.name.uppercased())
                        .foregroundColor(Color(hex: 0xfe365e))
                        .font(.custom("Nunito-ExtraBold", size: 15))
                    Group{
                        Text(composer.complete_name)
                        Text("(" + composer.birth.prefix(4)) + Text(composer.death != nil ? "-" : "") + Text((composer.death?.prefix(4) ?? "")) + Text(")")
                    }
                    .foregroundColor(.white)
                    .lineLimit(20)
                    .font(.custom("Nunito", size: 12))
                }
                .padding(12)
            }
        }
        .onAppear(perform: { self.endEditing(true) })
    }
}

struct ComposerDetail_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
