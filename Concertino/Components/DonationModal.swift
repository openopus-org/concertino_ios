//
//  DonationModal.swift
//  Concertino
//
//  Created by Adriano Brandao on 19/10/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import StoreKit
import SwiftyStoreKit

struct DonationModal: View {
    @State private var donationIsLoading = true
    @State private var donationDone = false
    @State private var inAppOffers = [SKProduct]()
    @EnvironmentObject var settingStore: SettingStore
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Close")
                        .foregroundColor(Color(hex: 0xfe365e))
                        .font(.custom("Barlow-Regular", size: 14))
                })
            }
            .padding(.bottom, 26)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    Text("Thank you for using Concertino!")
                        .foregroundColor(Color(hex: 0xfe365e))
                        .font(.custom("Nunito-ExtraBold", size: 20))
                        .multilineTextAlignment(.center)
                        .lineLimit(20)
                    
                    Text("We're very glad that Concertino is useful and fun for you. Now we need your help.")
                        .foregroundColor(Color.white)
                        .font(.custom("Barlow-SemiBold", size: 18))
                        .multilineTextAlignment(.center)
                        .lineLimit(20)
                    
                    Text("Concertino is a completely free and open project based on sheer love for classical music. But it runs on web servers that cost money, and its maintenance takes a lot of time.")
                        .foregroundColor(Color.white)
                        .font(.custom("Nunito-Regular", size: 14))
                        .multilineTextAlignment(.center)
                        .lineLimit(20)
                    
                    Text("Help keeping Concertino free. Please donate and back our development and hosting costs!")
                        .foregroundColor(Color(hex: 0xfe365e))
                        .font(.custom("Barlow-SemiBold", size: 14))
                        .multilineTextAlignment(.center)
                        .lineLimit(20)
                    
                    Text("Choose a tip value below".uppercased())
                        .foregroundColor(Color.gray)
                        .font(.custom("Nunito-Regular", size: 12))
                        .multilineTextAlignment(.center)
                        .lineLimit(20)
                        .padding(.top, 40)
                }
            
                HStack {
                    Spacer()
                    
                    if donationIsLoading {
                        ActivityIndicator(isAnimating: donationIsLoading)
                            .configure { $0.color = .white; $0.style = .medium }
                            //.padding(.top, 40)
                    } else if donationDone {
                        Group{
                            Image("favorites")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color(hex: 0xfe365e))
                                .frame(height: 18)
                                .padding(.trailing, 1)
                            
                            Text("Thank you so much for your donation!")
                                .font(.custom("Barlow-Regular", size: 15))
                        }
                        //.padding(.top, 40)
                    } else {
                        HStack {
                            ForEach (self.inAppOffers.sorted { $0.price.decimalValue < $1.price.decimalValue }, id: \.self) { product in
                                Button(
                                    action: {
                                        self.donationIsLoading = true
                                        SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: true) { result in
                                            self.donationIsLoading = false
                                            switch result {
                                                case .success(let purchase):
                                                    self.donationDone = true
                                                    self.settingStore.hasDonated = true
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
                                            .foregroundColor(.white)
                                            .font(.custom("Nunito-Regular", size: 13))
                                            .padding(13)
                                            .background(Color(hex: 0xfe365e))
                                            .cornerRadius(16)
                                    })
                                    .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 60)
                
                Text("Tipping is optional. You will be charged only once and the transaction will be processed through Apple.")
                    .font(.custom("Nunito-Regular", size: 10))
                    .foregroundColor(Color(hex: 0xa7a6a6))
                    .multilineTextAlignment(.center)
            }
            .padding(20)
            //.padding(.top, 10)
            //.padding(.leading, 20)
            //.padding(.trailing, 20)
        }
        .onAppear(perform: {
            SwiftyStoreKit.retrieveProductsInfo(Set(AppConstants.inAppPurchases)) { result in
                if result.retrievedProducts.first != nil {
                    for prod in result.retrievedProducts {
                        self.inAppOffers.append(prod)
                    }
                    self.donationIsLoading = false
                }
            }
        })
    }
}

struct DonationModal_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
