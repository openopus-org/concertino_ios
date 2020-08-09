//
//  GenreButton.swift
//  Concertino
//
//  Created by Adriano Brandao on 11/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct GenreButton: View {
    var genre: String
    var active: Bool
    
    var body: some View {
        VStack {
            VStack {
                Image(genre.lowercased())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(hex: self.active ? 0x000000 : 0xfe365e))
            }
            .frame(width: 44, height: 44)
            .background(Color(hex: self.active ? 0xfe365e : 0x202023))
            .clipped()
            .clipShape(Circle())
            
            /*if #available(iOS 14.0, *) {
                Text(genre == "Recommended" ? "Essential" : genre)
                    
                    .font(.custom("Nunito-Regular", size: 9))
                    .foregroundColor(.white)
                    .textCase(.none)
            } else {*/
                Text(genre == "Recommended" ? "Essential" : genre)
                    
                    .font(.custom("Nunito-Regular", size: 9))
                    .foregroundColor(.white)
            //}
        }
        
    }
}

struct GenreButton_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
