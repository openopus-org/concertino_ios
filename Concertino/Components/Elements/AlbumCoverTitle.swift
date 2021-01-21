//
//  AlbumCoverTitle.swift
//  Concertino
//
//  Created by Adriano Brandao on 25/10/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import URLImage

struct AlbumCoverTitle: View {
    var album: Album
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var radioState: RadioState
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                URLImage(album.cover ?? URL(fileURLWithPath: AppConstants.concNoCoverImg), placeholder: { _ in
                    Rectangle()
                        .fill(Color(hex: 0x2B2B2F))
                        .frame(width: 160, height: 160)
                        .cornerRadius(20)
                }) { img in
                    img.image
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        .cornerRadius(20)
                }
                .frame(width: 160, height: 160)
                .padding(.trailing, 8)
                
                VStack(alignment: .leading) {
                    Text(album.title)
                        .font(.custom("Barlow-SemiBold", size: 18))
                        .padding(.bottom, 4)
                        .lineLimit(20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("©℗ \(album.year) \(album.label)")
                        .lineLimit(20)
                        .font(.custom("Nunito-Regular", size: 12))
                        .padding(.top, 6)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack {
                        Text("playing time".uppercased())
                            .font(.custom("Nunito-Regular", size: 5))
                        Text("\(album.readableLength)")
                            .padding(.top, -10)
                    }
                    .foregroundColor(Color.gray)
                    .font(.custom("Nunito-Regular", size: 12))
                    .padding(EdgeInsets(top: 4, leading: 6, bottom: 2, trailing: 6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.top, 12)
                }
            }
        }
    }
}

struct AlbumCoverTitle_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
