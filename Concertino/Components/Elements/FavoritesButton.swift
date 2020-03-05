//
//  FavoritesButton.swift
//  Concertino
//
//  Created by Adriano Brandao on 04/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct FavoritesButton: View {
    var playlist: String
    var active: Bool
    
    var body: some View {
        VStack {
            Image(playlist == "fav" ? "favorites" : "recent")
                .resizable()
                .foregroundColor(Color(hex: (self.active ? 0xFFFFFF : 0xfe365e)))
                .aspectRatio(contentMode: .fill)
                .frame(width: 16, height: 16)
                .padding(.bottom, 1)
            
            Text(playlist == "fav" ? "Your favorites" : "Recently played")
                .foregroundColor(Color(hex: (self.active ? 0xFFFFFF : 0xfe365e)))
                .font(.custom("Nunito", size: 12))
        }
        .frame(minWidth: 115, maxWidth: 115, minHeight: 115,  maxHeight: 115)
        .background(Color(hex: (self.active ? 0xfe365e : 0x202023)))
        .cornerRadius(13)
    }
}

struct FavoritesButton_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
