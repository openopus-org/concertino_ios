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
import CommonCrypto

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

final class OmnisearchString: ObservableObject {
    let objectWillChange = PassthroughSubject<(), Never>()
    
    @Published var searchstring: String = "" {
        didSet {
            objectWillChange.send()
        }
    }
}

final class PlaylistSwitcher: ObservableObject {
    let objectWillChange = PassthroughSubject<(), Never>()
    
    @Published var playlist: String = "fav" {
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
}

final class PlayState: ObservableObject {
    let objectWillChange = PassthroughSubject<(), Never>()
    let playingstateWillChange = PassthroughSubject<(), Never>()
    
    @Published var recording = [FullRecording]() {
        didSet {
            objectWillChange.send()
        }
    }
    
    @Published var playing = false {
        didSet {
            playingstateWillChange.send()
        }
    }
    
    var autoplay = true
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
    print("✅ \(url)")
    
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

public func APIpost(_ url: String, parameters: [String: Any], completion: @escaping (Data) -> ()) {
    
    guard let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
        let urlR = URL(string: encoded) else
    {
        fatalError("Invalid URL")
    }
    
    print("✅ \(url)")
    parameters.forEach() { print("✴️ \($0)") }
    
    var request = URLRequest(url: urlR)
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    request.httpBody = parameters.percentEncoded()
    
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
    let player = MPMusicPlayerController.applicationQueuePlayer

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
    
    func setQueueAndPlay(tracks: [String], starttrack: String?, autoplay: Bool) {
        let queue = MPMusicPlayerStoreQueueDescriptor(storeIDs: tracks)
        
        if let sttrack = starttrack {
            print(sttrack)
            queue.startItemID = sttrack
        }
        
        player.setQueue(with: queue)
        player.prepareToPlay(completionHandler: {(error) in
            DispatchQueue.main.async {
                if error != nil {
                    print("🆘 \(error!.localizedDescription)")
                    let alertController = UIAlertController(title: "Couldn't play", message:
                        "Sorry, this recording is not available in your country.", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(alertController, animated: true, completion: nil)
                } else {
                    print("✅ No errors!")
                    if autoplay {
                        self.player.play()
                    }
                }
            }
        })
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
    
    func getCurrentPlaybackTime() -> Int {
        if (player.nowPlayingItem != nil) {
            return Int(player.currentPlaybackTime)
        } else {
            return 0
        }
    }
    
    func togglePlay() {
        if (player.playbackState == .playing) {
            player.pause()
        } else {
            player.play()
        }
    }
    
    func nextTrack() {
        player.skipToNextItem()
    }
    
    func previousTrack() {
        if (player.indexOfNowPlayingItem > 0) {
          player.skipToPreviousItem()
        } else {
          player.skipToBeginning()
        }
    }
    
    func stop() {
        player.stop()
    }
}

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

@propertyWrapper
struct RecordingUserDefault {
    let key: String

    init(_ key: String) {
        self.key = key
    }

    var wrappedValue: [FullRecording] {
        get {
            var ret = [FullRecording]()
            
            if let data = UserDefaults.standard.value(forKey: key) as? Data {
                ret = try! PropertyListDecoder().decode(Array<FullRecording>.self, from: data)
            }
            
            return ret
        }
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: key)
        }
    }
}

@propertyWrapper
struct PlaylistsUserDefault {
    let key: String

    init(_ key: String) {
        self.key = key
    }

    var wrappedValue: [Playlist] {
        get {
            var ret = [Playlist]()
            
            if let data = UserDefaults.standard.value(forKey: key) as? Data {
                ret = try! PropertyListDecoder().decode(Array<Playlist>.self, from: data)
            }
            
            return ret
        }
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: key)
        }
    }
}

final class SettingStore: ObservableObject {
    let composersWillChange = PassthroughSubject<Void, Never>()
    let playstateWillChange = PassthroughSubject<Void, Never>()
    let playlistsWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault("concertino.hideIncomplete", defaultValue: true) var hideIncomplete: Bool
    @UserDefault("concertino.hideHistorical", defaultValue: true) var hideHistorical: Bool
    @UserDefault("concertino.userId", defaultValue: 0) var userId: Int
    @UserDefault("concertino.lastLogged", defaultValue: 0) var lastLogged: Int
    @UserDefault("concertino.userAuth", defaultValue: "") var userAuth: String
    @RecordingUserDefault("concertino.lastPlayState") var lastPlayState: [FullRecording] {
        willSet {
            playstateWillChange.send()
        }
    }
    @UserDefault("concertino.favoriteComposers", defaultValue: [String]()) var favoriteComposers: [String] {
        willSet {
            composersWillChange.send()
        }
    }
    @UserDefault("concertino.favoriteWorks", defaultValue: [String]()) var favoriteWorks: [String]
    @UserDefault("concertino.forbiddenComposers", defaultValue: [String]()) var forbiddenComposers: [String]
    @PlaylistsUserDefault("concertino.playlists") var playlists: [Playlist] {
        willSet {
            playlistsWillChange.send()
        }
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

extension Date {
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}

public func MD5(_ string: String) -> String? {
    let length = Int(CC_MD5_DIGEST_LENGTH)
    var digest = [UInt8](repeating: 0, count: length)

    if let d = string.data(using: String.Encoding.utf8) {
        _ = d.withUnsafeBytes { body -> String in CC_MD5(body.baseAddress, CC_LONG(d.count), &digest)
            return ""
        }
    }

    return (0..<length).reduce("") {
        $0 + String(format: "%02x", digest[$1])
    }
}

public func authGen(userId: Int, userAuth: String) -> String? {
    let timestamp = (((Date().millisecondsSince1970 / 1000 | 0) + (60 * 1)) / (60 * 5) | 0)
    if let auth = MD5("\(timestamp)-\(userId)-\(userAuth)") {
        return auth
    }
    else {
        return ""
    }
}

public func timeframe(timestamp: Int, minutes: Int) -> Bool {
    let now = (Date().millisecondsSince1970 / (60 * 1000) | 0)
    let limit = timestamp + minutes
    
    if now >= limit {
        return true
    } else {
        return false
    }
}

extension Binding {
    func didSet(execute: @escaping (Value) ->Void) -> Binding {
        return Binding(
            get: {
                return self.wrappedValue
            },
            set: {
                execute($0)
                self.wrappedValue = $0
            }
        )
    }
}
