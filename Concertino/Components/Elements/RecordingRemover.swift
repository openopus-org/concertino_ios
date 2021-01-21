//
//  RecordingRemover.swift
//  Concertino
//
//  Created by Adriano Brandao on 26/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct RecordingRemover: View {
    var recording: Recording
    var playlistId: String
    @State private var isSelected = false
    @EnvironmentObject var settingStore: SettingStore
    @Binding var selectedRecordings: [Recording]
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.isSelected.toggle()
                    if self.isSelected {
                        self.selectedRecordings.append(self.recording)
                    } else {
                        self.selectedRecordings = self.selectedRecordings.filter { $0.id != self.recording.id }
                    }   
                }, label: {
                    Image(self.isSelected ? "checked" : "remove")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22)
                        .foregroundColor(self.isSelected ? Color.white : Color.lightRed)
                        .padding(.leading, 20)
                        .padding(.trailing, 6)
                })
                
                MiniRecordingRow(recording: recording, accentColor: self.isSelected ? Color.white : Color.lightRed)
            }
        }
        .frame(minWidth: 125, maxWidth: .infinity)
        .background(self.isSelected ? Color.lightRed : Color.lightBlack)
        .cornerRadius(20)
    }
}

struct RecordingRemover_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
