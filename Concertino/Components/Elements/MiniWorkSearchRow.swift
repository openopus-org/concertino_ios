//
//  WorkSearchRow.swift
//  Concertino
//
//  Created by Adriano Brandao on 27/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct MiniWorkSearchRow: View {
    var work: Work
    var composer: Composer
    
    var body: some View {
        HStack {
            VStack {
                Image(work.genre.lowercased())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color(hex: 0xfe365e))
            }
            .frame(width: 36, height: 36)
            .clipped()
            .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(composer.name.uppercased())
                    .foregroundColor(Color(hex: 0xfe365e))
                    .font(.custom("Nunito-ExtraBold", size: 12))
                Text(work.title)
                    .font(.custom("Barlow-Regular", size: 12))
                if work.subtitle != "" {
                    Text(work.subtitle!)
                        .font(.custom("Barlow-Regular", size: 9))
                }
            }
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            
            Spacer()
        }
        .padding(EdgeInsets(top: 14, leading: 0, bottom: 14, trailing: 14))
    }
}

struct MiniWorkSearchRow_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
