//
//  PlaylistButton.swift
//  Concertino
//
//  Created by Adriano Brandao on 04/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import URLImage

struct PlaylistButton: View {
    var playlist: Playlist
    var active: Bool
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                ZStack {
                    ForEach(0 ..< playlist.summary.composers.portraits.prefix(4).count, id: \.self) { number in
                        URLImage(self.playlist.summary.composers.portraits[number], placeholder: { _ in
                            Circle()
                                .fill(Color.extraDarkGray)
                                .frame(width: 40, height: 40)
                        }) { img in
                            img.image
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                                .clipShape(Circle())
                        }
                        .frame(width: 40, height: 40)
                        .offset(x: CGFloat(number * (self.playlist.summary.composers.portraits.prefix(4).count == 4 ? 27 : 35)))
                    }
                }
                .padding(.top, 10)
                
                Text(playlist.name)
                    
                    .foregroundColor(Color(hex: (self.active ? 0xFFFFFF : 0xfe365e)))
                    .font(.custom("Nunito-ExtraBold", size: 12))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(20)
                
                Text("\(playlist.summary.works.rows) work\(self.playlist.summary.works.rows > 1 ? "s" : "") by \(playlist.summary.composers.nameList)")
                    
                    .foregroundColor(Color.white)
                    .font(.custom("Nunito-Regular", size: 9))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(20)
            }
            .frame(minWidth: 125, maxWidth: 125, minHeight: 130,  maxHeight: 130, alignment: .topLeading)
        }
        .frame(minWidth: 145, maxWidth: 145, minHeight: 130,  maxHeight: 130)
        .background(Color(hex: (self.active ? 0xfe365e : 0x202023)))
        .cornerRadius(13)
    }
}

struct PlaylistButton_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
