//
//  ExternalRecordingSheet.swift
//  Concertino
//
//  Created by Adriano Brandao on 18/04/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct ExternalRecordingSheet: View {
    var workId: String
    var recordingId: String
    var recordingSet: Int
    @EnvironmentObject var AppState: AppState
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                
                Button(action: {
                    self.AppState.externalUrl = [String]()
                }, label: {
                    Text("Close")
                        .foregroundColor(Color(hex: 0xfe365e))
                        .font(.custom("Barlow", size: 14))
                })
            }
            .padding(30)
            
            RecordingDetail(workId: workId, recordingId: recordingId, recordingSet: recordingSet, isSheet: true, isSearch: false)
                .padding(.top, -55)
            
            Spacer()
        }
    }
}

struct ExternalRecordingSheet_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
