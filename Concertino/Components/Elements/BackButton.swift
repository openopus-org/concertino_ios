//
//  BackButton.swift
//  Concertino
//
//  Created by Adriano Brandao on 14/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import Combine

final class NavigationState: ObservableObject  {
    @Published var identifierStack: [Int:String] = [:]
    func popAll() {
        identifierStack = [:]
    }
    func pop() {
        let lastIndex = identifierStack.values.count - 1
        identifierStack[lastIndex] = nil
    }
    func bindingForIdentifier(at index: Int) -> Binding<String?> {
        Binding(
            get: { return self.identifierStack[index] },
            set: { newValue in self.identifierStack[index] = newValue })
    }
}

fileprivate struct BackButtonImage: View {
    var body: some View {
        Image("handle")
            .resizable()
            .frame(width: 14, height: 36)
            .foregroundColor(Color(hex: 0xfe365e))
            .rotationEffect(.degrees(180))
            .padding(.trailing, 10)
    }
}

struct NavigationBackButton: View {
    @EnvironmentObject var navigation: NavigationState
    
    var body: some View {
        Button(action: { self.navigation.pop() }) { BackButtonImage() }
    }
}

struct PresentationBackButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: { self.presentationMode.wrappedValue.dismiss() }) { BackButtonImage() }
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        PresentationBackButton()
    }
}
