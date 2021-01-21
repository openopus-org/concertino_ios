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
                .foregroundColor(self.active ? Color.white : Color.lightRed)
                .aspectRatio(contentMode: .fill)
                .frame(width: 14, height: 14)
                .padding(.bottom, 1)
                .padding(.top, 6)
            
            Text(playlist == "fav" ? "Your favorites" : "Recently played")
                .foregroundColor(self.active ? Color.white : Color.lightRed)
                .font(.custom("Nunito-Regular", size: 11))
                .lineLimit(20)
                .lineSpacing(-4)
        }
        .frame(minWidth: 95, maxWidth: 95, minHeight: 130,  maxHeight: 130)
        .background(self.active ? Color.lightRed : Color.lightBlack)
        .cornerRadius(13)
    }
}

struct FavoritesButton_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
