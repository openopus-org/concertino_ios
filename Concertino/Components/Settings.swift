//
//  Settings.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/01/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import SwiftyStoreKit
import UIKit
import AuthenticationServices
import StoreKit

struct Settings: View {
    @Environment(\.window) var window: UIWindow?
    @EnvironmentObject var settingStore: SettingStore
    @State var appleSignInDelegates: SignInWithAppleDelegates! = nil
    @State private var supporters = [String]()
    @State private var showSignIn = false
    @State private var alreadyLogged = false
    @State private var signInLoading = false
    @State private var inAppOffers = [SKProduct]()
    
    func loadData() {
        APIget(AppConstants.openOpusBackend+"/patron/list.json") { results in
            if var supportersData: Supporters = safeJSON(results) {
                DispatchQueue.main.async {
                    supportersData.patrons.shuffle()
                    self.supporters = supportersData.patrons
                }
            }
        }
    }
    
    private func performSignIn(using requests: [ASAuthorizationRequest]) {
      self.signInLoading = true
        
      appleSignInDelegates = SignInWithAppleDelegates(window: window) { appleId in
        if appleId != "error" {
            APIpost("\(AppConstants.concBackend)/dyn/user/sync/", parameters: ["auth": authGen(userId: settingStore.userId, userAuth: settingStore.userAuth) ?? "", "id": settingStore.userId, "recid": appleId]) { results in
                
                if let login: Login = safeJSON(results) {
                    
                    DispatchQueue.main.async {
                        self.settingStore.userId = login.user.id
                        self.settingStore.appleId = appleId
                        
                        if let auth = login.user.auth {
                            self.settingStore.userAuth = auth
                        }
                        
                        if let favoritecomposers = login.favorite {
                            self.settingStore.favoriteComposers = favoritecomposers
                        }
                        
                        if let favoriteworks = login.works {
                            self.settingStore.favoriteWorks = favoriteworks
                        }
                        
                        if let composersfavoriteworks = login.composerworks {
                            self.settingStore.composersFavoriteWorks = composersfavoriteworks
                        }
                        
                        if let favoriterecordings = login.favoriterecordings {
                            self.settingStore.favoriteRecordings = favoriterecordings
                        }
                        
                        if let forbiddencomposers = login.forbidden {
                            self.settingStore.forbiddenComposers = forbiddencomposers
                        }
                        
                        if let playlists = login.playlists {
                            self.settingStore.playlists = playlists
                        }
                        
                        self.signInLoading = false
                        self.alreadyLogged = true
                    }
                }
            }
        } else {
            self.signInLoading = false
        }
      }

      let controller = ASAuthorizationController(authorizationRequests: requests)
      controller.delegate = appleSignInDelegates
      controller.presentationContextProvider = appleSignInDelegates

      controller.performRequests()
    }

    private func showAppleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        
        performSignIn(using: [request])
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section(header:
                    VStack(alignment: .leading) {
                        Text("Library filters".uppercased())
                            .font(.custom("Nunito-ExtraBold", size: 13))
                            .foregroundColor(Color(hex: 0xfe365e))
                        if #available(iOS 14.0, *) {
                            Text("Automatic filters that try to eliminate bad or undesirable recordings from the library. They are not perfect, but definitely can improve your playing experience.")
                                .textCase(.none)
                                .font(.custom("Barlow-Regular", size: 13))
                                .foregroundColor(.white)
                                .lineLimit(20)
                        } else {
                            Text("Automatic filters that try to eliminate bad or undesirable recordings from the library. They are not perfect, but definitely can improve your playing experience.")
                                .font(.custom("Barlow-Regular", size: 13))
                                .foregroundColor(.white)
                                .lineLimit(20)
                        }
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 16)
                    ){
                        Toggle(isOn: self.$settingStore.hideIncomplete) {
                            Text("Hide incomplete recordings")
                            .font(.custom("Barlow-Regular", size: 16))
                        }
                        .listRowBackground(Color.black)
                    
                        Toggle(isOn: self.$settingStore.hideHistorical) {
                            Text("Hide old, historical recordings")
                            .font(.custom("Barlow-Regular", size: 16))
                        }
                        .listRowBackground(Color.black)
                }
                
                if showSignIn {
                    Section(header:
                        VStack(alignment: .leading) {
                            Text("Device sync".uppercased())
                                .font(.custom("Nunito-ExtraBold", size: 13))
                                .foregroundColor(Color(hex: 0xfe365e))
                            if #available(iOS 14.0, *) {
                                Text("Signed-in users have their favorites, playlists and playing history synchronized between multiple devices.")
                                    .textCase(.none)
                                    .font(.custom("Barlow-Regular", size: 13))
                                    .foregroundColor(.white)
                                    .lineLimit(20)
                            } else {
                                Text("Signed-in users have their favorites, playlists and playing history synchronized between multiple devices.")
                                    .font(.custom("Barlow-Regular", size: 13))
                                    .foregroundColor(.white)
                                    .lineLimit(20)
                            }
                        }
                        .padding(.top, 12)
                        .padding(.bottom, 16)
                        ){
                            HStack {
                                Spacer()
                                
                                if self.signInLoading {
                                    ActivityIndicator(isAnimating: signInLoading)
                                        .configure { $0.color = .white; $0.style = .medium }
                                } else {
                                    if !self.alreadyLogged {
                                        SignInWithApple()
                                            .frame(width: 200, height: 36)
                                            .onTapGesture(perform: showAppleLogin)
                                    } else {
                                        VStack {
                                            Image("checked")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 12, height: 12)
                                            .foregroundColor(Color.black)
                                        }
                                        .frame(width: 22, height: 22)
                                        .background(Color(hex: 0xfe365e))
                                        .clipped()
                                        .clipShape(Circle())
                                        .padding(.trailing, 4)
                                        
                                        Text("Logged-in, devices synced!")
                                            .font(.custom("Barlow-Regular", size: 16))
                                    }
                                }
                                
                                Spacer()
                            }
                            .listRowBackground(Color.black)
                    }
                }
                
                Section(header:
                    VStack(alignment: .leading) {
                        Text("Support us!".uppercased())
                            .font(.custom("Nunito-ExtraBold", size: 13))
                            .foregroundColor(Color(hex: 0xfe365e))
                        if #available(iOS 14.0, *) {
                            Text("Help us keeping Concertino free! Donate and back our development and hosting costs.")
                                .textCase(.none)
                                .font(.custom("Barlow-Regular", size: 13))
                                .foregroundColor(.white)
                                .lineLimit(20)
                        } else {
                            Text("Help us keeping Concertino free! Donate and back our development and hosting costs.")
                                .font(.custom("Barlow-Regular", size: 13))
                                .foregroundColor(.white)
                                .lineLimit(20)
                        }
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 16)
                ) {
                    HStack {
                        ForEach (self.inAppOffers.sorted { $0.price.decimalValue < $1.price.decimalValue }, id: \.self) { product in
                            Button(
                                action: {
                                    SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: true) { result in
                                        switch result {
                                            case .success(let purchase):
                                                print("Purchase Success: \(purchase.productId)")
                                            case .error(let error):
                                                switch error.code {
                                                    case .unknown: print("Unknown error. Please contact support")
                                                    case .clientInvalid: print("Not allowed to make the payment")
                                                    case .paymentCancelled: break
                                                    case .paymentInvalid: print("The purchase identifier was invalid")
                                                    case .paymentNotAllowed: print("The device is not allowed to make the payment")
                                                    case .storeProductNotAvailable: print("The product is not available in the current storefront")
                                                    case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                                                    case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                                                    case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                                                    default: print((error as NSError).localizedDescription)
                                                }
                                        }
                                    }
                                },
                                label: {
                                    Text("\(product.localizedPrice!)")
                                })
                                .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    .listRowBackground(Color.black)
                }
                
                Section(header:
                    Text("About".uppercased())
                        .font(.custom("Nunito-ExtraBold", size: 13))
                        .foregroundColor(Color(hex: 0xFE365E))
                    ){
                        SettingsMenuItem(title: "Version", description: AppConstants.version)
                            .listRowBackground(Color.black)
                        /*
                        Button(
                            action: { UIApplication.shared.open(URL(string: "https://patreon.com/openopus")!) },
                            label: {
                                SettingsMenuItem(title: "Support our projects", description: "Help us keeping Concertino free! Donate and back our development and hosting costs.")
                        })
                            .listRowBackground(Color.black)
                        */
                        
                        Button(
                            action: { UIApplication.shared.open(URL(string: "https://github.com/openopus-org/concertino_ios")!) },
                            label: {
                                SettingsMenuItem(title: "Contribute with code", description: "Concertino is an open source project. You may fork it or help us with code!")
                        })
                            .listRowBackground(Color.black)
                    
                        Button(
                            action: { UIApplication.shared.open(URL(string: "https://twitter.com/concertinoapp")!) },
                            label: {
                                SettingsMenuItem(title: "Find us on Twitter", description: "And tell us how has been your experience with Concertino so far!")
                        })
                            .listRowBackground(Color.black)
                }
                
                Section(header:
                    Text("Thanks for our supporters".uppercased())
                        .font(.custom("Nunito-ExtraBold", size: 13))
                        .foregroundColor(Color(hex: 0xFE365E))
                    ){
                        ForEach(supporters, id: \.self) { supporter in
                            SettingsMenuItem(title: supporter)
                        }
                        .listRowBackground(Color.black)
                }
            }
            .listStyle(GroupedListStyle())
        }
        .onAppear(perform: {
            if self.supporters.count == 0 {
                print("🆗 supporters loaded from appearance")
                self.loadData()
            }
            
            self.showSignIn = (self.settingStore.userId > 0)
            self.alreadyLogged = !self.settingStore.appleId.isEmpty
            
            SwiftyStoreKit.retrieveProductsInfo(Set(AppConstants.inAppPurchases)) { result in
                if result.retrievedProducts.first != nil {
                    for prod in result.retrievedProducts {
                        self.inAppOffers.append(prod)
                    }
                }
            }
        })
        .onReceive(settingStore.userIdDidChange, perform: {
            print("🆗 user id changed")
            self.showSignIn = (self.settingStore.userId > 0)
            self.alreadyLogged = !self.settingStore.appleId.isEmpty
        })
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
