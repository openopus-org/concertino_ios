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
                Image("forbidden")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size == "min" ? 16 : 23)
                    .foregroundColor(Color.white)
                    .padding(.trailing, size == "min" ? 0 : 2)
                
                VStack(alignment: .leading) {
                    Text("Preview-only mode")
                        .font(.custom("Nunito-ExtraBold", size: size == "min" ? 10 : 13))
                        .padding(.top, size == "min" ? 0 : 2)
                    Text("Tap to enable playback")
                        .font(.custom("Nunito-Regular", size: size == "min" ? 8 : 11))
                        .padding(.top, size == "min" ? -2 : -2)
                }
                .foregroundColor(Color.white)
            }
        })
    }
}

struct BrowseOnlyMode_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
