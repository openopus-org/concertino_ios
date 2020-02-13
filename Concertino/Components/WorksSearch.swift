//
//  WorksSearch.swift
//  Concertino
//
//  Created by Adriano Brandao on 12/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct WorksSearch: View {
    var composerId: String
    @EnvironmentObject var genre: WorkSearchGenre
    @State private var loading = true
    @State private var works = [Work]()
    
    init(composerId: String) {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        self.composerId = composerId
    }
    
    func loadData() {
        loading = true
        
        APIget(AppConstants.openOpusBackend+"/work/list/composer/\(self.composerId)/\(self.genre.searchgenre).json") { results in
            let worksData: Works = parseJSON(results)
            
            DispatchQueue.main.async {
                if let wrks = worksData.works {
                    self.works = wrks
                }
                else {
                    self.works = [Work]()
                }
                
                self.loading = false
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if self.loading {
                HStack {
                    Spacer()
                    ActivityIndicator(isAnimating: loading)
                    .configure { $0.color = .white; $0.style = .large }
                    Spacer()
                }
                .padding(40)
            }
            else {
                if self.works.count > 0 {
                    List {
                        ForEach(AppConstants.genreList, id: \.self) { genre in
                            //if self.works.filter({$0.genre == genre}).count > 0 {
                                Section(header:
                                    Text(genre)
                                        .font(.custom("Barlow-SemiBold", size: 14))
                                        .padding(.top, 14)
                                    ){
                                    ForEach(self.works.filter({$0.genre == genre}), id: \.id) { work in
                                        //NavigationLink(destination: ) {
                                            WorkRow(work: work)
                                        //}
                                    }
                                }
                            //}
                        }
                    }
                    .listStyle(GroupedListStyle())
                    .gesture(DragGesture().onChanged{_ in self.endEditing(true) })
                }
                else {
                    HStack(alignment: .top) {
                        VStack {
                            Image("warning")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color(hex: 0xa7a6a6))
                                .frame(height: 28)
                                .padding(5)
                            Text("No works found.")
                                .foregroundColor(Color(hex: 0xa7a6a6))
                                .font(.custom("Barlow", size: 14))
                        }
                    }.padding(15)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .onReceive(genre.objectWillChange, perform: loadData)
    }
}

struct WorksSearch_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
