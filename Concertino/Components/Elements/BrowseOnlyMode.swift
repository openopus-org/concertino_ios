//
//  BrowseOnlyMode.swift
//  Concertino
//
//  Created by Adriano Brandao on 07/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import StoreKit

struct BrowseOnlyMode: View {
    var size: String
    @EnvironmentObject var playState: PlayState
    
    var body: some View {
        Button(action: {
            SKCloudServiceController.requestAuthorization { status in
                if (SKCloudServiceController.authorizationStatus() == .authorized)
                {
                    let controller = SKCloudServiceController()
                    controller.requestCapabilities { capabilities, error in
                        if capabilities.contains(.musicCatalogPlayback) {
                            self.playState.recording = self.playState.recording
                        }
                        else {
                            if capabilities.contains(.musicCatalogSubscriptionEligible) {
                                DispatchQueue.main.async {
                                    let amc = AppleMusicSubscribeController()
                                    amc.showAppleMusicSignup()
                                }
                            }
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    }
                }
            }
        }, label: {
            HStack {
                Spacer()
                
                Image("browseonly")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size == "min" ? 18 : 26)
                    .foregroundColor(Color(hex: size == "min" ? 0x797979 : 0xfe365e))
                    .padding(.trailing, 2)
                VStack(alignment: .leading) {
                    Text("Browse-only mode")
                        .font(.custom("Nunito-ExtraBold", size: size == "min" ? 11 : 15))
                    Text("Click here to allow access to Apple Music")
                        .font(.custom("Nunito", size: size == "min" ? 9 : 13))
                }
                .foregroundColor(Color(hex: size == "min" ? 0x797979 : 0xfe365e))
                
                Spacer()
            }
        })
    }
}

struct BrowseOnlyMode_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
