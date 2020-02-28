//
//  WorkSearchRow.swift
//  Concertino
//
//  Created by Adriano Brandao on 27/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct WorkSearchRow: View {
    var work: Work
    var composer: Composer
    
    var body: some View {
        HStack() {
            VStack {
                Image(work.genre.lowercased())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 28, height: 28)
                    .foregroundColor(Color(hex: 0xfe365e))
            }
            .frame(width: 60, height: 60)
            .background(Color(hex: 0x202023))
            .clipped()
            .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(composer.name.uppercased())
                    .foregroundColor(Color(hex: 0xfe365e))
                    .font(.custom("Nunito-ExtraBold", size: 12))
                Text(work.title)
                    .font(.custom("Barlow", size: 16))
                if work.subtitle != "" {
                    Text(work.subtitle!)
                        .font(.custom("Barlow", size: 12))
                }
            }
            .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 0))
        }
    }
}

struct WorkSearchRow_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
