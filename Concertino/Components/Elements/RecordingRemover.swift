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
                        .foregroundColor(Color(hex: (self.isSelected ? 0xFFFFFF : 0xfe365e)))
                        .padding(.leading, 20)
                        .padding(.trailing, 6)
                })
                
                MiniRecordingRow(recording: recording, accentColor: Color(hex: (self.isSelected ? 0xFFFFFF : 0xfe365e)))
            }
        }
        .frame(minWidth: 125, maxWidth: .infinity)
        .background(Color(hex: (self.isSelected ? 0xfe365e : 0x202023)))
        .cornerRadius(20)
    }
}

struct RecordingRemover_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
