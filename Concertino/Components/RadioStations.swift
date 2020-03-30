//
//  RadioStations.swift
//  Concertino
//
//  Created by Adriano Brandao on 28/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct RadioStations: View {
    @State private var stations = [RadioStationPlaylist]()
    
    func loadData() {
        APIget(AppConstants.concBackend+"/playlist/public/list.json") { results in
            var stationsData: RadioStationPlaylists = parseJSON(results)
            DispatchQueue.main.async {
                stationsData.playlists.shuffle()
                self.stations = Array(stationsData.playlists.prefix(10))
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Suggested radio stations".uppercased())
                .foregroundColor(Color(hex: 0x717171))
                .font(.custom("Nunito", size: 12))
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 14) {
                    ForEach(self.stations, id: \.id) { station in
                        RadioStationButton(id: station.id, name: station.name, cover: station.cover)
                    }
                }
                .frame(minHeight: 138)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
        }
        .onAppear(perform: {
            if self.stations.count == 0 {
                print("🆗 radio stations loaded from appearance")
                self.loadData()
            }
        })
    }
}

struct RadioStations_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
