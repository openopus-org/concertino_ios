//
//  AlbumDetail.swift
//  Concertino
//
//  Created by Adriano Brandao on 25/10/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct AlbumDetail: View {
    var albumId: String
    @State private var error = false
    @State private var recordings = [FullRecording]()
    @State private var album = [Album]()
    @State private var loading = true
    @EnvironmentObject var settingStore: SettingStore
    
    func loadData() {
        loading = true
        
        getStoreFront() { countryCode in
            APIget(AppConstants.concBackend+"/album/\(countryCode ?? "us")/detail/\(self.albumId).json") { results in
                if let albumData: FullAlbum = safeJSON(results) {
                    DispatchQueue.main.async {
                        self.album = [albumData.album]
                        self.recordings = albumData.recordings
                        self.error = false
                        self.loading = false
                    }
                } else {
                    self.error = true
                    self.loading = false
                }
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
                else if error {
                    Spacer()
                    
                    VStack{
                        Spacer()
                        ErrorMessage(msg: "This album is not available.")
                        Spacer()
                    }
                    
                    Spacer()
                }
                else if album.count > 0 {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading) {
                            AlbumCoverTitle(album: album.first!)
                            
                            AlbumPlayButtons(album: album.first!, recordings: FullRecToRec (recordings: recordings))
                                .padding(.top, 16)
                                .padding(.bottom, 12)
                            
                            ForEach(self.recordings, id: \.id) { recording in
                                RecordingDetailTracks(recording: recording)
                            }
                            
                            HStack {
                                Spacer()
                                
                                Image("warning")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                        
                                Text("This album was fetched automatically with no human verification.")
                                    .font(.custom("Nunito-Regular", size: 10))
                                    .lineLimit(20)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Spacer()
                            }
                            .foregroundColor(Color.darkGray)
                            .padding(EdgeInsets(top: 20, leading: 30, bottom: 30, trailing: 30))
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 22))
            .onAppear(perform: {
                self.loadData()
            })
            
            Spacer()
        }
    }
}

struct AlbumDetail_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
