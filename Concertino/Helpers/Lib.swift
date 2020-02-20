//
//  Lib.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/01/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import Combine
import MediaPlayer

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

final class WorkSearch: ObservableObject {
    let objectWillChange = PassthroughSubject<(), Never>()
    
    @Published var loadingGenres: Bool = true {
        didSet {
            objectWillChange.send()
        }
    }
    
    @Published var genreName: String = "" {
        didSet {
            objectWillChange.send()
        }
    }
    
    @Published var composerId: String = "" {
        didSet {
            objectWillChange.send()
        }
    }
    
    @Published var searchString: String = "" {
        didSet {
            objectWillChange.send()
        }
    }
}

final class PlayState: ObservableObject {
    let objectWillChange = PassthroughSubject<(), Never>()
    
    @Published var recording = [FullRecording]() {
        didSet {
            objectWillChange.send()
        }
    }
}

class TimerHolder: ObservableObject {
    var timer: Timer!
    let objectWillChange = PassthroughSubject<(),Never>()
    
    @Published var count = 0 {
        didSet {
            objectWillChange.send()
        }
    }
    
    func start() {
        self.timer?.invalidate()
        self.count = 0
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            _ in
            self.count += 1
        }
    }
    
    func stop() {
        self.timer?.invalidate()
        self.count = 0
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
    
    func uiColor() -> UIColor {
        let components = self.components()
        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }
    
    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
}

extension Collection {
  func enumeratedArray() -> Array<(offset: Int, element: Self.Element)> {
    return Array(self.enumerated())
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
    
    let sessionConfig = URLSessionConfiguration.default
    sessionConfig.timeoutIntervalForRequest = 3000000.0
    sessionConfig.timeoutIntervalForResource = 6000000.0
    
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

public func convertSeconds (seconds: Int) -> String {
    let h = seconds / 3600
    let min = (seconds % 3600) / 60
    let s = (seconds % 3600) % 60
    
    if (h > 0) {
        return String(format: "%d:%02d:%02d", h, min, s)
    }
    else {
        return String(format: "%d:%02d", min, s)
    }
}

class MediaBridge: ObservableObject {
    let player = MPMusicPlayerController.applicationMusicPlayer

    init() {
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(MediaBridge.playItemChanged(_:)),
        name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
        object: player
      )
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(MediaBridge.playbackStateChanged(_:)),
        name: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange,
        object: player
      )
      player.beginGeneratingPlaybackNotifications()
    }

    deinit {
      player.endGeneratingPlaybackNotifications()
      player.stop()
    }
    
    func setQueueAndPlay(tracks: [String]) {
        let queue  = MPMusicPlayerStoreQueueDescriptor(storeIDs: tracks)

        player.setQueue(with: queue)
        player.prepareToPlay()
        player.play()
    }
    
    @objc func playItemChanged(_ notification:Notification) {
        let status: [String : Any] = [
            "index": player.indexOfNowPlayingItem,
            "title": player.nowPlayingItem?.title ?? ""
            ]
        
        NotificationCenter.default.post(name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: self, userInfo: status)
    }
    
    @objc func playbackStateChanged(_ notification:Notification) {
        NotificationCenter.default.post(name: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange, object: self, userInfo: ["playing": (player.playbackState == .playing)])
    }
    
    func togglePlay() {
        if (player.playbackState == .playing) {
            player.pause()
        } else {
            player.play()
        }
    }
}
