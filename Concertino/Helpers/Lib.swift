//
//  Lib.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/01/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import Combine

final class AppState: ObservableObject  {
    @Published var currentTab = "library"
    @Published var currentLibraryTab = "home"
    @Published var fullPlayer = false
}

final class ComposerSearchString: ObservableObject {
    let objectWillChange = PassthroughSubject<(), Never>()
    
    @Published var searchstring: String = "" {
        didSet {
            objectWillChange.send()
        }
    }
}

extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
}

extension View {
    func endEditing(_ force: Bool) {
        UIApplication.shared.windows.forEach { $0.endEditing(force)}
    }
}

public struct SearchStyle: TextFieldStyle {
  public func _body(configuration: TextField<Self._Label>) -> some View {
    configuration
      .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
        .font(.custom("Nunito", size: 15))
        .foregroundColor(.black)
  }
}

public func APIget(_ url: String, completion: @escaping (Data) -> ()) {
    
    guard let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
        let urlR = URL(string: encoded) else
    {
        fatalError("Invalid URL")
    }
    
    let request = URLRequest(url: urlR)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        
        if let data = data {
            completion(data)
        }
        
    }.resume()
}

public func parseJSON<T: Decodable>(_ data: Data) -> T {
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse as \(T.self):\n\(error)")
    }
}
