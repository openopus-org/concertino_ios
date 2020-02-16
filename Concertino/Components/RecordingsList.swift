//
//  RecordingsList.swift
//  Concertino
//
//  Created by Adriano Brandao on 14/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct RecordingsList: View {
    var work: Work
    @State private var loading = true
    @State private var page = "0"
    @State private var nextpage = "0"
    @State private var recordings = [Recording]()
    
    init(work: Work) {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        self.work = work
    }
    
    func loadData() {
        loading = true
        
        APIget(AppConstants.concBackend+"/recording/list/work/\(self.work.id)/\(self.page).json") { results in
            let recsData: Recordings = parseJSON(results)
            
            DispatchQueue.main.async {
                if let recds = recsData.recordings {
                    for rec in recds {
                        if !self.recordings.contains(rec) {
                            self.recordings.append(rec)
                        }
                    }
                }
                else {
                    self.recordings += [Recording]()
                }
                
                if let nextpg = recsData.next {
                    self.nextpage = nextpg
                }
                else {
                    self.nextpage = "0"
                }
                
                self.loading = false
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
                List {
                    ForEach(self.recordings, id: \.id) { recording in
                        RecordingRow(recording: recording)
                    }
                    
                    HStack {
                        Spacer()
                        if (loading) {
                            ActivityIndicator(isAnimating: loading)
                                .configure { $0.color = .white; $0.style = .large }
                        } else if self.recordings.count > 0 {
                            RecordingsDisclaimer(msg: "Those recordings were fetched automatically from the Apple Music catalog. The list might be inaccurate or incomplete. Please reach us for requests, questions or suggestions.")
                        } else {
                            ErrorMessage(msg: "Concertino couldn't find any recording of this work in the Apple Music catalog. It might be an error, though. Please reach us if you know a recording. This will help us correct our algorithm.")
                        }
                        Spacer()
                    }
                    .padding(40)
                    .onAppear() {
                        if (self.nextpage != "0") {
                            self.page = self.nextpage
                            self.loadData()
                        }
                    }
               }
               .listStyle(DefaultListStyle())
            
        }
        .frame(maxWidth: .infinity)
        .onAppear(perform: loadData)
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
