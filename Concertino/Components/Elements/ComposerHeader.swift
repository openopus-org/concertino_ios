//
//  ComposerDetail.swift
//  Concertino
//
//  Created by Adriano Brandao on 10/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import URLImage

struct ComposerHeader: View {
    var composer: Composer
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            BackButton()
            URLImage(composer.portrait!) { img in
                img.image
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .clipShape(Circle())
            }
            .frame(width: 70, height: 70)
            VStack {
                VStack(alignment: .leading) {
                    
                    Text(composer.name.uppercased())
                        .foregroundColor(Color(hex: 0xfe365e))
                        .font(.custom("Nunito-ExtraBold", size: 17))
                    Group{
                        Text(composer.complete_name)
                        Text("(" + composer.birth!.prefix(4)) + Text(composer.death != nil ? "-" : "") + Text((composer.death?.prefix(4) ?? "")) + Text(")")
                    }
                    .foregroundColor(.white)
                    .lineLimit(20)
                    .font(.custom("Nunito", size: 14))
                }
                .padding(8)
            }
            Spacer()
        }
        .onAppear(perform: { self.endEditing(true) })
    }
}

struct ComposerHeader_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
