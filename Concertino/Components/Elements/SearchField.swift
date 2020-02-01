//
//  SearchField.swift
//  Concertino
//
//  Created by Adriano Brandao on 31/01/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct SearchField: View {
    @State private var search = ""
    
    var body: some View {
        HStack {
            Image("search")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color(hex: 0xFE365E))
                .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 0))
                .frame(maxHeight: 15)
            
            ZStack(alignment: .leading) {
                if search.isEmpty {
                    Text("Search composer by name")
                        .foregroundColor(.black)
                        .font(.custom("Nunito", size: 15))
                        .padding(1)
                }
               TextField("", text: $search, onEditingChanged: { isEditing in
                    
                }, onCommit: {
                    
                    }).textFieldStyle(SearchStyle())
            }
            
        }
        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
        .foregroundColor(.black)
        .background(Color(.white))
        .cornerRadius(12)
    }
}

struct SearchField_Previews: PreviewProvider {
    static var previews: some View {
        SearchField()
    }
}
