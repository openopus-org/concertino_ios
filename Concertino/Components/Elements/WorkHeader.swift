//
//  WorkHeader.swift
//  Concertino
//
//  Created by Adriano Brandao on 14/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct WorkHeader: View {
    var work: Work
    var composer: Composer
    @State private var showSheet = false
    @EnvironmentObject var settingStore: SettingStore
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Select an action"), message: nil, buttons: [
            .default(Text(self.settingStore.favoriteWorks.contains(work.id) ? "Remove work from favorites" : "Add work to favorites"), action: {
                
                APIpost("\(AppConstants.concBackend)/dyn/user/work/\(self.settingStore.favoriteWorks.contains(self.work.id) ? "unfavorite" : "favorite")/", parameters: ["id": self.settingStore.userId, "auth": authGen(userId: self.settingStore.userId, userAuth: self.settingStore.userAuth) ?? "", "wid": self.work.id, "cid": self.composer.id]) { results in
                    
                    print(String(decoding: results, as: UTF8.self))
                    
                    DispatchQueue.main.async {
                        let addWork: AddWork = parseJSON(results)
                        self.settingStore.favoriteWorks = addWork.list
                        self.settingStore.composersFavoriteWorks = addWork.composerworks
                        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.showToast(message: "\(self.settingStore.favoriteWorks.contains(self.work.id) ? "Added!" : "Removed!")")
                    }
                }
            }),
            .cancel()
        ])
    }
    
    var body: some View {
        HStack {
            PresentationBackButton()
            VStack {
                VStack(alignment: .leading) {
                    
                    Text(composer.name.uppercased())
                        .foregroundColor(Color(hex: 0xfe365e))
                        .font(.custom("Nunito-ExtraBold", size: 17))
                    
                    Group{
                        Text(work.title)
                        .font(.custom("Barlow-SemiBold", size: 17))
                        if work.subtitle != "" {
                            Text(work.subtitle!)
                            .font(.custom("Barlow", size: 14))
                        }
                    }
                    .foregroundColor(.white)
                    .lineLimit(20)
                    
                }
                .padding(8)
            }
            
            Spacer()
            
            if self.settingStore.userId > 0 {
                Button(action: {
                    self.showSheet = true
                })
                {
                    EllipsisButton()
                }
            }
        }
        .onAppear(perform: { self.endEditing(true) })
        .actionSheet(isPresented: $showSheet, content: { self.actionSheet })
    }
}

struct WorkHeader_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
