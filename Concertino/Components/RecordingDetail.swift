//
//  RecordingDetail.swift
//  Concertino
//
//  Created by Adriano Brandao on 16/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct RecordingDetail: View {
    var workId: String
    var recordingId: String
    var recordingSet: Int
    @State private var recording = [FullRecording]()
    @State private var loading = true
    
    func loadData() {
        loading = true
    APIget(AppConstants.concBackend+"/recording/detail/work/\(self.workId)/album/\(self.recordingId)/\(self.recordingSet).json") { results in
            let recordingData: FullRecording = parseJSON(results)
            
            DispatchQueue.main.async {
                self.recording = [recordingData]
                self.loading = false
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                BackButton()
                    .padding(.top, 6)
                
                if (loading) {
                    Spacer()
                    
                    VStack{
                        Spacer()
                        ActivityIndicator(isAnimating: loading)
                        .configure { $0.color = .white; $0.style = .large }
                        Spacer()
                    }
                    
                    Spacer()
                }
                else if recording.count > 0 {
                    RecordingDetailed(recording: recording.first!)
                }
            }
            .padding(EdgeInsets(top: 12, leading: 20, bottom: 0, trailing: 28))
            .onAppear(perform: loadData)
            
            Spacer()
        }
    }
}

struct RecordingDetail_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
