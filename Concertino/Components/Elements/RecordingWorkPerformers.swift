//
//  RecordingDetailed.swift
//  Concertino
//
//  Created by Adriano Brandao on 16/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import URLImage

struct RecordingWorkPerformers: View {
    var recording: Recording
    var isSheet: Bool
    @State private var showSheet = false
    @State private var showPlaylistSheet = false
    @State private var loadingSheet = false
    @EnvironmentObject var settingStore: SettingStore
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Select an action"), message: nil, buttons: [
            .default(Text(self.settingStore.favoriteRecordings.contains("\(self.recording.id)") ? "Remove recording from favorites" : "Add recording to favorites"), action: {
                APIpost("\(AppConstants.concBackend)/dyn/user/recording/\(self.settingStore.favoriteRecordings.contains("\(self.recording.id)") ? "unfavorite" : "favorite")/", parameters: ["id": self.settingStore.userId, "auth": authGen(userId: self.settingStore.userId, userAuth: self.settingStore.userAuth) ?? "", "wid": self.recording.work!.id, "aid": self.recording.apple_albumid, "set": self.recording.set, "cover": self.recording.cover ?? AppConstants.concNoCoverImg, "performers": self.recording.jsonPerformers]) { results in
                    
                    print(String(decoding: results, as: UTF8.self))
                    
                    DispatchQueue.main.async {
                        let addRecordings: AddRecordings = parseJSON(results)
                        self.settingStore.favoriteRecordings = addRecordings.favoriterecordings
                        print(self.settingStore.favoriteRecordings)
                        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.showToast(message: "\(self.settingStore.favoriteRecordings.contains("\(self.recording.id)") ? "Added!" : "Removed!")")
                    }
                }
            }),
            .default(Text("Add recording to a playlist"), action: {
                self.showPlaylistSheet = true
            }),
            .cancel()
        ])
    }
    
    var body: some View {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    URLImage(recording.cover ?? URL(fileURLWithPath: AppConstants.concNoCoverImg), placeholder: { _ in
                        Rectangle()
                            .fill(Color(hex: 0x2B2B2F))
                            .frame(width: 110, height: 110)
                            .cornerRadius(20)
                    }) { img in
                        img.image
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipped()
                            .cornerRadius(20)
                    }
                    .frame(width: 110, height: 110)
                    .padding(.trailing, 8)
                    
                    VStack(alignment: .leading) {
                        Text(recording.work!.composer!.name.uppercased())
                            .font(.custom("Nunito-ExtraBold", size: 15))
                            .foregroundColor(Color(hex: 0xfe365e))
                        
                        Text(recording.work!.title)
                            .font(.custom("Barlow-SemiBold", size: 16))
                            .padding(.bottom, 4)
                            .lineLimit(20)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Group {
                            if recording.observation != "" && recording.observation != nil {
                                Text(recording.observation ?? "")
                            }
                            else if recording.work!.subtitle != "" && recording.work!.subtitle != nil {
                                Text(recording.work!.subtitle!)
                            }
                        }
                        .font(.custom("Barlow", size: 14))
                        .lineLimit(20)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 18)
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        ForEach(self.recording.performers, id: \.name) { performer in
                            Text(performer.name)
                                .font(.custom("Barlow-SemiBold", size: 14))
                            +
                            Text(performer.readableRole)
                                .font(.custom("Barlow", size: 13))
                        }
                        .foregroundColor(.white)
                        
                        Text(recording.label ?? "")
                            .font(.custom("Nunito", size: 11))
                            .padding(.top, 6)
                    }
                    
                    Spacer()
                    
                    if !isSheet {
                        Button(action: {
                            self.loadingSheet = true
                            APIget(AppConstants.concBackend+"/recording/shorturl/work/\(self.recording.work!.id)/album/\(self.recording.apple_albumid)/\(self.recording.set).json") { results in
                                
                                let recordingData: ShortRecordingDetail = parseJSON(results)
                                
                                DispatchQueue.main.async {
                                    let ac = UIActivityViewController(activityItems: ["\(self.recording.work!.composer!.name): \(self.recording.work!.title)", URL(string: "\(AppConstants.concShortFrontend)/\( String(Int(recordingData.recording.id) ?? 0, radix: 16))")!], applicationActivities: nil)
                                    ac.excludedActivityTypes = [.addToReadingList]
                                    self.loadingSheet = false
                                    UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(ac, animated: true)
                                }
                            }
                        })
                        {
                            ShareButton(isLoading: self.loadingSheet)
                        }
                    }
                    
                    if self.settingStore.userId > 0 {
                        Button(action: {
                            self.showSheet = true
                        })
                        {
                            EllipsisButton()
                        }
                    }
                }
        }
        .actionSheet(isPresented: $showSheet, content: { self.actionSheet })
        .sheet(isPresented: $showPlaylistSheet) {
            AddToPlaylist(recording: self.recording).environmentObject(self.settingStore)
        }
    }
}

struct RecordingWorkPerformers_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
