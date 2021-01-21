//
//  RecordingNotAvailable.swift
//  Concertino
//
//  Created by Adriano Brandao on 15/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct RecordingNotAvailable: View {
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var mediaBridge: MediaBridge
    var size: String
    
    var body: some View {
        Button(action: {
            //self.playState.recording = [self.playState.recording.first!]
            self.mediaBridge.prepareToPlay(self.playState.autoplay)
        },
        label: {
            HStack {
                Spacer()
                
                Image("warning")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size == "min" ? 18 : 26)
                    .foregroundColor(size == "min" ? Color.lightGray : Color.lightRed)
                    .padding(.trailing, 2)
                VStack(alignment: .leading) {
                    Text("Couldn't connect to Apple Music")
                        .font(.custom("Nunito-ExtraBold", size: size == "min" ? 11 : 15))
                    Text("Please tap here to try again")
                        .font(.custom("Nunito-Regular", size: size == "min" ? 9 : 13))
                }
                .foregroundColor(size == "min" ? Color.lightGray : Color.lightRed)
                
                Spacer()
            }
        })
    }
}

struct RecordingNotAvailable_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
