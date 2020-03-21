//
//  WorksList.swift
//  Concertino
//
//  Created by Adriano Brandao on 14/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct WorksList: View {
    var genre: String
    var genrelist: [String]
    var works: [Work]
    var composer: Composer
    var essential: Bool
    
    var body: some View {
        Group {
            if self.genre == "Popular" || self.genre == "Recommended" {
                List {
                    Section(header:
                        WorksRadioButton(genreId: "\(self.composer.id)-\(self.genre)")
                            .padding(.bottom, -20)
                    ){
                        EmptyView()
                    }
                    ForEach(self.genrelist, id: \.self) { genre in
                        Section(header:
                            Text(genre)
                                .font(.custom("Barlow-SemiBold", size: 13))
                                .foregroundColor(Color(hex: 0xFE365E))
                            ){
                            ForEach(self.works.filter({$0.genre == genre}), id: \.id) { work in
                                WorkRow(work: work, composer: self.composer)
                            }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
            }
            else if self.essential {
                List {
                    Section(header:
                        WorksRadioButton(genreId: "\(self.composer.id)-\(self.genre)")
                            .padding(.bottom, -20)
                    ){
                        EmptyView()
                    }
                    ForEach(["1", "0"], id: \.self) { rec in
                        Section(header:
                            Text(rec == "1" ? "Essential" : "Other works")
                                .font(.custom("Barlow-SemiBold", size: 13))
                                .foregroundColor(Color(hex: 0xFE365E))
                            ){
                            ForEach(self.works.filter({$0.recommended == rec}), id: \.id) { work in
                                WorkRow(work: work, composer: self.composer)
                            }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
            }
            else {
                List {
                    WorksRadioButton(genreId: "\(self.composer.id)-\(self.genre)")
                    ForEach(self.works, id: \.id) { work in
                        WorkRow(work: work, composer: self.composer)
                    }
                }
                .padding(.bottom, 34)
            }
        }
    }
}

struct WorksList_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
