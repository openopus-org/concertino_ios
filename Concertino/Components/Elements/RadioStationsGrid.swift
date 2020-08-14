//
//  RadioStationsGrid.swift
//  Concertino
//
//  Created by Adriano Brandao on 31/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct RadioStationsGrid: View {
    @State private var stations = [[RadioStationPlaylist]]()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    func loadData() {
        APIget(AppConstants.concBackend+"/playlist/public/list.json") { results in
            if var stationsData: RadioStationPlaylists = safeJSON(results) {
                DispatchQueue.main.async {
                    stationsData.playlists.shuffle()
                    self.stations = Array(stationsData.playlists.chunked(into: self.horizontalSizeClass == .compact ? 2 : 3))
                }
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0 ..< stations.count, id: \.self) { index in
                HStack(spacing: 12) {
                    ForEach(self.stations[index], id: \.id) { station in
                        RadioStationSuperButton(id: station.id, name: station.name, cover: station.cover)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 138, maxHeight: 138, alignment: .topLeading)
                    }
                }
                .padding(.bottom, 12)
            }
        }
        .padding(.top, 12)
        .onAppear(perform: {
            if self.stations.count == 0 {
                print("🆗 radio stations loaded from appearance")
                self.loadData()
            }
        })
    }
}

struct RadioStationsGrid_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
