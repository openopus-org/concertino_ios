//
//  AirPlayButton.swift
//  Concertino
//
//  Created by Adriano Brandao on 23/04/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import AVKit

struct AirPlayView: UIViewRepresentable {
    let frame: CGRect

    func makeUIView(context: Self.Context) -> UIView {
        let someView = UIView(frame: self.frame)
        let someButton = AVRoutePickerView(frame: self.frame)
        
        someButton.activeTintColor = .white
        someButton.tintColor = Color.lightRed.uiColor()
        
        someView.addSubview(someButton)
        
        return someView
      }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<AirPlayView>) {
        
    }
}

struct AirPlayButton: View {
    var body: some View {
        GeometryReader { proxy in
            AirPlayView(frame: proxy.frame(in: .local))
        }
    }
}

struct AirPlayButton_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
