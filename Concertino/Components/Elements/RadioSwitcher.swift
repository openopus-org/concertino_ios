//
//  RadioSwitcher.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct RadioSwitcher: View {
    var name: String
    var isPicture: Bool
    var isActive: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                if isPicture {
                    Image(name.lowercased())
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                } else {
                    Image(name == "Essential works" ? "popular" : name.lowercased())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(hex: isActive ? 0xFFFFFF : 0xfe365e))
                }
            }
            .frame(width: 44, height: 44)
            .background(Color(hex: isActive ? 0xfe365e : 0x000000))
            .clipped()
            .clipShape(Circle())
            .padding(.bottom, -6)
            
            Text(name)
                .font(.custom("Nunito", size: 9))
                .foregroundColor(.white)
            
            Spacer()
        }
        .frame(minWidth: 72, maxWidth: 72, minHeight: 72,  maxHeight: 72, alignment: .top)
        .background(Color(hex: self.isActive ? 0xfe365e : 0x202023))
        .padding(0)
        .cornerRadius(12)
    }
}

struct RadioSwitcher_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
