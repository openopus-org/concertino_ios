//
//  ComposerRow.swift
//  Concertino
//
//  Created by Adriano Brandao on 01/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import URLImage

struct MiniComposerRow: View {
    var composer: Composer
    
    var body: some View {
        HStack {
            URLImage(composer.portrait!, placeholder: { _ in
                Circle()
                    .fill(Color(hex: 0x2B2B2F))
                    .frame(width: 36, height: 36)
            }) { img in
                img.image
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .clipShape(Circle())
            }
            .frame(width: 36, height: 36)
            
            VStack {
                VStack(alignment: .leading) {
                    
                    Text(composer.name.uppercased())
                        .foregroundColor(Color.lightRed)
                        .font(.custom("Nunito-ExtraBold", size: 12))
                    
                    Text(composer.complete_name)
                        
                        .foregroundColor(.white)
                        .lineLimit(20)
                        .font(.custom("Nunito-Regular", size: 11))
                    
                    Group {
                        Text("(" + composer.birth!.prefix(4)) + Text(composer.death != nil ? "-" : "") + Text((composer.death?.prefix(4) ?? "")) + Text(")")
                    }
                    .foregroundColor(.white)
                    .lineLimit(20)
                    .font(.custom("Nunito-Regular", size: 9))
                }
                .padding(.leading, 10)
            }
            
            Spacer()
        }
        .padding(EdgeInsets(top: 14, leading: 0, bottom: 14, trailing: 14))
    }
}

struct MiniComposerRow_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
