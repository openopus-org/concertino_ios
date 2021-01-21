//
//  PlaylistChooser.swift
//  Concertino
//
//  Created by Adriano Brandao on 25/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import URLImage

struct PlaylistChooser: View {
    var playlist: Playlist
    var active: Bool
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        ForEach(0 ..< playlist.summary.composers.portraits.prefix(8).count, id: \.self) { number in
                            URLImage(self.playlist.summary.composers.portraits[number], placeholder: { _ in
                                Circle()
                                    .fill(Color.extraDarkGray)
                                    .frame(width: 30, height: 30)
                            }) { img in
                                img.image
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipped()
                                    .clipShape(Circle())
                            }
                            .frame(width: 30, height: 30)
                        }
                    }
                    .padding(.top, 10)
                    
                    Text(playlist.name)
                        .foregroundColor(self.active ? Color.white : Color.lightRed)
                        .font(.custom("Nunito-Regular", size: 16))
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(20)
                }
                
                Spacer()
                
                if active {
                    Image("checked")
                        .resizable()
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 16)
                        .padding(20)
                }
            }
            .padding(.leading, 12)
            .frame(minWidth: 125, maxWidth: .infinity, minHeight: 80,  maxHeight: 80, alignment: .topLeading)
        }
        .frame(minWidth: 125, maxWidth: .infinity, minHeight: 80,  maxHeight: 80)
        .background(self.active ? Color.lightRed : Color.lightBlack)
        .cornerRadius(13)
    }
}

struct PlaylistChooser_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
