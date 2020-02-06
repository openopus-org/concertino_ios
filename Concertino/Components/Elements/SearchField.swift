//
//  SearchField.swift
//  Concertino
//
//  Created by Adriano Brandao on 31/01/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct SearchField: View {
    @EnvironmentObject var composersSearch: ComposerSearchString
    @EnvironmentObject var AppState: AppState
    
    var body: some View {
        HStack {
            HStack {
                Image("search")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(hex: 0xFE365E))
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 0))
                    .frame(maxHeight: 15)
                
                ZStack(alignment: .leading) {
                    if self.composersSearch.searchstring.isEmpty {
                        Text("Search composer by name")
                            .foregroundColor(.black)
                            .font(.custom("Nunito", size: 15))
                            .padding(1)
                    }
                    TextField("", text: $composersSearch.searchstring, onEditingChanged: { isEditing in
                            if (isEditing) {
                                self.AppState.currentTab = "composersearch"
                            }
                    })
                        .textFieldStyle(SearchStyle())
                        .disableAutocorrection(true)
                }
                
            }
                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(.black)
                .background(Color(.white))
                .cornerRadius(12)
            if self.AppState.currentTab == "composersearch" {
                Button(action: {
                        self.AppState.currentTab = "library"
                    self.composersSearch.searchstring = ""
                        self.endEditing(true) },
                       label: { Text("Cancel")
                        .foregroundColor(Color(hex: 0xfe365e))
                        .font(.custom("Nunito", size: 13))
                        .padding(4)
                })
            }
        }
        
    }
}

struct SearchField_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
        //SearchField(composersSearch: "")
    }
}
