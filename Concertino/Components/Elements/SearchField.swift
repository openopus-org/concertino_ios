//
//  SearchField.swift
//  Concertino
//
//  Created by Adriano Brandao on 27/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

/*
import SwiftUI

struct SearchField: View {
    @EnvironmentObject var composersSearch: ComposerSearchString
    @EnvironmentObject var AppState: AppState
    @State private var searchString = ""
    
    var body: some View {
        HStack {
            HStack {
                Image("search")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.black)
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 0))
                    .frame(maxHeight: 15)
                
                ZStack(alignment: .leading) {
                    if self.composersSearch.searchstring.isEmpty {
                        Text("Search composer by name")
                            .foregroundColor(.black)
                            .font(.custom("Nunito-Regular", size: 15))
                            .padding(1)
                    }
                    TextField("", text: $searchString, onEditingChanged: { isEditing in
                            if (isEditing) {
                                self.AppState.currentLibraryTab = "composersearch"
                            }
                        }, onCommit: {
                            self.composersSearch.searchstring = self.searchString
                        })
                        .textFieldStyle(SearchStyle())
                        .disableAutocorrection(true)
                }
                
            }
            .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
            .foregroundColor(.black)
            .background(Color(.white))
            .cornerRadius(12)
            .clipped()
            
            if self.AppState.currentLibraryTab == "composersearch" {
                Button(action: {
                        self.AppState.currentLibraryTab = "home"
                        self.composersSearch.searchstring = ""
                        self.endEditing(true)
                    
                },
                       label: { Text("Cancel")
                        .foregroundColor(Color(hex: 0xfe365e))
                        .font(.custom("Nunito-Regular", size: 13))
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
*/
