//
//  ComposerDetail.swift
//  Concertino
//
//  Created by Adriano Brandao on 10/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import URLImage

struct ComposerHeader: View {
    var composer: Composer
    @State private var showSheet = false
    @EnvironmentObject var settingStore: SettingStore
    @EnvironmentObject var AppState: AppState
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Select an action"), message: nil, buttons: [
            .default(Text(self.settingStore.favoriteComposers.contains(composer.id) ? "Remove \(composer.name) from favorites" : "Add \(composer.name) to favorites"), action: {
                
                APIpost("\(AppConstants.concBackend)/dyn/user/composer/\(self.settingStore.favoriteComposers.contains(self.composer.id) ? "unfavorite" : "favorite")/", parameters: ["id": self.settingStore.userId, "auth": authGen(userId: self.settingStore.userId, userAuth: self.settingStore.userAuth) ?? "", "cid": self.composer.id]) { results in
                    
                    print(String(decoding: results, as: UTF8.self))
                    
                    DispatchQueue.main.async {
                        let addComposer: AddComposer = parseJSON(results)
                        self.settingStore.favoriteComposers = addComposer.list
                        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.showToast(message: "\(self.settingStore.favoriteComposers.contains(self.composer.id) ? "Added!" : "Removed!")")
                    }
                }
            }),
            .default(Text(self.settingStore.forbiddenComposers.contains(composer.id) ? "Remove \(composer.name) from the forbidden list" : "Add \(composer.name) to the forbidden list"), action: {
                
                APIpost("\(AppConstants.concBackend)/dyn/user/composer/\(self.settingStore.favoriteComposers.contains(self.composer.id) ? "permit" : "forbid")/", parameters: ["id": self.settingStore.userId, "auth": authGen(userId: self.settingStore.userId, userAuth: self.settingStore.userAuth) ?? "", "cid": self.composer.id]) { results in
                    
                    print(String(decoding: results, as: UTF8.self))
                    
                    DispatchQueue.main.async {
                        let addComposer: AddComposer = parseJSON(results)
                        self.settingStore.forbiddenComposers = addComposer.list
                        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.showToast(message: "\(self.settingStore.forbiddenComposers.contains(self.composer.id) ? "Added!" : "Removed!")")
                    }
                }
            }),
            .cancel()
        ])
    }
    
    var body: some View {
        HStack {
            BackButton()
            
            URLImage(composer.portrait!) { img in
                img.image
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .clipShape(Circle())
            }
            .frame(width: 70, height: 70)
            
            VStack {
                VStack(alignment: .leading) {
                    
                    Text(composer.name.uppercased())
                        .foregroundColor(Color(hex: 0xfe365e))
                        .font(.custom("Nunito-ExtraBold", size: 17))
                    
                    Group{
                        Text(composer.complete_name)
                        Text("(" + composer.birth!.prefix(4)) + Text(composer.death != nil ? "-" : "") + Text((composer.death?.prefix(4) ?? "")) + Text(")")
                    }
                    .foregroundColor(.white)
                    .lineLimit(20)
                    .font(.custom("Nunito", size: 14))
                }
                .padding(8)
            }
            
            Spacer()
            
            Button(action: {
                self.showSheet = true
            })
            {
                EllipsisButton()
            }
        }
        .onAppear(perform: { self.endEditing(true) })
        .actionSheet(isPresented: $showSheet, content: { self.actionSheet })
    }
}

struct ComposerHeader_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
