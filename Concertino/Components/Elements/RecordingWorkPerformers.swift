//
//  RecordingDetailed.swift
//  Concertino
//
//  Created by Adriano Brandao on 16/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import URLImage

struct ActivityView: UIViewControllerRepresentable {

    let activityItems: [Any]
    let applicationActivities: [UIActivity]?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems,
                                        applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: UIViewControllerRepresentableContext<ActivityView>) {

    }
}

struct RecordingWorkPerformers: View {
    var recording: Recording
    var isSheet: Bool
    var isPlayer: Bool
    @State private var showSheet = false
    @State private var shareURL = ""
    @State private var showShareSheet = false
    @State private var showPlaylistSheet = false
    @State private var loadingSheet = false
    @State private var showShare = false
    @State private var shareItem = ""
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var AppState: AppState
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var radioState: RadioState
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Select an action"), message: nil, buttons: [
            .default(Text(self.settingStore.favoriteRecordings.contains("\(self.recording.id)") ? "Remove recording from favorites" : "Add recording to favorites"), action: {
                APIpost("\(AppConstants.concBackend)/dyn/user/recording/\(self.settingStore.favoriteRecordings.contains("\(self.recording.id)") ? "unfavorite" : "favorite")/", parameters: ["id": self.settingStore.userId, "auth": authGen(userId: self.settingStore.userId, userAuth: self.settingStore.userAuth) ?? "", "wid": self.recording.work!.id, "aid": self.recording.apple_albumid, "set": self.recording.set, "cover": self.recording.cover ?? AppConstants.concNoCoverImg, "performers": self.recording.jsonPerformers, "work": (self.recording.work!.id.contains("at*") ? self.recording.work!.title : ""), "composer": (self.recording.work!.composer!.id == "0" ? self.recording.work!.composer!.complete_name : (self.recording.work!.id.contains("at*") ? self.recording.work!.composer!.name : ""))]) { results in
                    
                    if let addRecordings: AddRecordings = safeJSON(results) {
                        DispatchQueue.main.async {
                            self.settingStore.favoriteRecordings = addRecordings.favoriterecordings
                            
                            if let topMostViewController = UIApplication.shared.topMostViewController() {
                                topMostViewController.showToast(message: "\(self.settingStore.favoriteRecordings.contains("\(self.recording.id)") ? "Added!" : "Removed!")", image: "checked", text: nil)
                            }
                        }
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
                if isSheet || isPlayer {
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
                } else {
                    NavigationLink(destination: AlbumDetail(albumId: recording.apple_albumid).environmentObject(self.settingStore).environmentObject(self.AppState).environmentObject(self.playState).environmentObject(self.radioState), label: {
                        VStack {
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
                            
                            HStack {
                                Spacer()
                                Text("view album".uppercased())
                                    .font(.custom("Nunito-Regular", size: 8))
                                Spacer()
                            }
                            .frame(width: 110)
                            .padding(.bottom, 4)
                            .padding(.top, 4)
                            .foregroundColor(.white)
                            .background(Color(hex: 0x4F4F4F))
                            .cornerRadius(16)
                        }
                        .padding(.trailing, 8)
                    })
                }
                
                VStack(alignment: .leading) {
                    if recording.work!.composer!.id != "0" {
                        Text(recording.work!.composer!.name.uppercased().trimmingCharacters(in: .whitespacesAndNewlines))
                            .font(.custom("Nunito-ExtraBold", size: 15))
                            .foregroundColor(Color(hex: 0xfe365e))
                    } else if recording.work!.composer!.name != "None" {
                        ForEach(recording.work!.composer!.name.components(separatedBy: CharacterSet(charactersIn: "&,")), id: \.self) { composer in
                            Text(composer.uppercased().trimmingCharacters(in: .whitespacesAndNewlines))
                            .font(.custom("Nunito-ExtraBold", size: 15))
                            .foregroundColor(Color(hex: 0xfe365e))
                        }
                    }
                    
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
                    .font(.custom("Barlow-Regular", size: 14))
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
                            .font(.custom("Barlow-Regular", size: 13))
                    }
                    .foregroundColor(.white)
                    
                    Text(recording.label ?? "")
                        .font(.custom("Nunito-Regular", size: 11))
                        .padding(.top, 6)
                }
                
                Spacer()
                
                if !isSheet {
                    Button(action: {
                        self.loadingSheet = true
                        APIget(AppConstants.concBackend+"/recording/shorturl/work/\(self.recording.work!.id)/album/\(self.recording.apple_albumid)/\(self.recording.set).json") { results in
                            
                            if let recordingData: ShortRecordingDetail = safeJSON(results) {
                                DispatchQueue.main.async {
                                    self.shareURL = "\(AppConstants.concShortFrontend)/\( String(Int(recordingData.recording.id) ?? 0, radix: 16))"
                                    self.loadingSheet = false
                                    self.showShareSheet = true
                                }
                            }
                        }
                    })
                    {
                        ShareButton(isLoading: self.loadingSheet)
                    }
                    .sheet(isPresented: $showShareSheet, content: {
                        ActivityView(activityItems: ["\(self.recording.work!.composer!.name): \(self.recording.work!.title)", URL(string: self.shareURL)!] as [Any], applicationActivities: nil)
                    })
                }
                
                if self.settingStore.userId > 0 {
                    Button(action: {
                        self.showSheet = true
                    })
                    {
                        EllipsisButton()
                            .actionSheet(isPresented: $showSheet, content: { self.actionSheet })
                            .sheet(isPresented: $showPlaylistSheet) {
                                AddToPlaylist(recording: self.recording).environmentObject(self.settingStore)
                            }
                    }
                }
            }
        }
    }
}

struct RecordingWorkPerformers_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
