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
import StoreKit
import UIKit

final class AppState: ObservableObject  {
    let externalUrlWillChange = PassthroughSubject<(), Never>()
    
    @Published var currentTab = "library"
    @Published var currentLibraryTab = "home"
    @Published var fullPlayer = false
    @Published var isLoading = true
    @Published var externalUrl = [String]() {
        didSet {
            externalUrlWillChange.send()
        }
    }
}

final class RadioState: ObservableObject {
    @Published var isActive = false
    @Published var playlistId = ""
    @Published var genreId = ""
    @Published var canSkip = false
    @Published var nextWorks = [Work]()
    @Published var nextRecordings = [Recording]()
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
    
    @Published var recording = [Recording]() {
        didSet {
            objectWillChange.send()
        }
    }
    
    @Published var playing = false {
        didSet {
            playingstateWillChange.send()
        }
    }
    
    var keepQueue = false
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
            self.count = 1
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

public struct EditFieldStyle: TextFieldStyle {
  public func _body(configuration: TextField<Self._Label>) -> some View {
    configuration
        .padding(12)
        .font(.custom("Nunito", size: 15))
        .cornerRadius(12)
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
    //parameters.forEach() { print("✴️ \($0)") }
    
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

func imageGet(url: URL, completion: @escaping (MPMediaItemArtwork) -> ()) {
    URLSession.shared.dataTask(with: url) { data, _, error in
        guard let data = data,
        let image = UIImage(data: data) else {
            
            if let error = error {
                print(error)
            }
            
            return
        }
        
        completion(.init(boundsSize: image.size) { _ in image })
    }.resume()
}

public func safeJSON<T: Decodable>(_ data: Data) -> T? {
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        return nil
    }
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
            queue.startItemID = sttrack
        }
        
        player.setQueue(with: queue)
        self.prepareToPlay(autoplay)
    }
    
    func prepareToPlay(_ autoplay: Bool) {
        player.prepareToPlay(completionHandler: {(error) in
            if error != nil {
                /*let status: [String : Any] = [
                    "index": 0,
                    "title": 0,
                    "success": false
                ]
                NotificationCenter.default.post(name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: self, userInfo: status)*/
            }
            else if autoplay {
                DispatchQueue.main.async {
                    self.player.play()
                }
            }
        })
    }
    
    func addToQueue(tracks: [String]) {
        let queue = MPMusicPlayerStoreQueueDescriptor(storeIDs: tracks)
        
        player.append(queue)
    }
    
    @objc func playItemChanged(_ notification:Notification) {
        let status: [String : Any] = [
            "index": player.indexOfNowPlayingItem,
            "title": player.nowPlayingItem?.title ?? "",
            "success": player.nowPlayingItem != nil
            ]
        
        print(status)
        
        if player.indexOfNowPlayingItem < 1000 {
            NotificationCenter.default.post(name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: self, userInfo: status)
        }
    }
    
    @objc func playbackStateChanged(_ notification:Notification) {
        print(player.playbackState == .playing)
        
        NotificationCenter.default.post(name: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange, object: self, userInfo: ["playing": (player.playbackState == .playing)])
    }
    
    func getCurrentPlaybackState() -> Bool {
        if (player.playbackState == .playing) {
            return true
        } else {
            return false
        }
    }
    
    func getCurrentPlaybackTime() -> Int {
        if (player.nowPlayingItem != nil) {
            return Int(player.currentPlaybackTime)
        } else {
            return 0
        }
    }
    
    func getCurrentTrackIndex() -> Int {
        if (player.nowPlayingItem != nil) {
            return Int(player.indexOfNowPlayingItem)
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
    
    func skipToBeginning() {
        player.skipToBeginning()
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

    var wrappedValue: [Recording] {
        get {
            var ret = [Recording]()
            
            if let data = UserDefaults.standard.value(forKey: key) as? Data {
                ret = try! PropertyListDecoder().decode(Array<Recording>.self, from: data)
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
    let composersDidChange = PassthroughSubject<Void, Never>()
    let playstateWillChange = PassthroughSubject<Void, Never>()
    let playlistsWillChange = PassthroughSubject<Void, Never>()
    let playlistsDidChange = PassthroughSubject<Void, Never>()
    let playedRecordingDidChange = PassthroughSubject<Void, Never>()
    let composersFavoriteWorksWillChange = PassthroughSubject<Void, Never>()
    let composersFavoriteWorksDidChange = PassthroughSubject<Void, Never>()
    let recordingsWillChange = PassthroughSubject<Void, Never>()
    let recordingsDidChange = PassthroughSubject<Void, Never>()
    
    var lastPlayedRecording = [Recording]() {
        didSet {
            playedRecordingDidChange.send()
        }
    }
    
    @UserDefault("concertino.firstUsage", defaultValue: true) var firstUsage: Bool
    @UserDefault("concertino.hideIncomplete", defaultValue: true) var hideIncomplete: Bool
    @UserDefault("concertino.hideHistorical", defaultValue: true) var hideHistorical: Bool
    @UserDefault("concertino.userId", defaultValue: 0) var userId: Int
    @UserDefault("concertino.lastLogged", defaultValue: 0) var lastLogged: Int
    @UserDefault("concertino.userAuth", defaultValue: "") var userAuth: String
    @UserDefault("concertino.country", defaultValue: "") var country: String
    
    @RecordingUserDefault("concertino.lastPlayState") var lastPlayState: [Recording] {
        willSet {
            playstateWillChange.send()
        }
    }
    @UserDefault("concertino.favoriteComposers", defaultValue: [String]()) var favoriteComposers: [String] {
        willSet {
            composersWillChange.send()
        }
        didSet {
            composersDidChange.send()
        }
    }
    @UserDefault("concertino.favoriteRecordings", defaultValue: [String]()) var favoriteRecordings: [String] {
        willSet {
            recordingsWillChange.send()
        }
        didSet {
            recordingsDidChange.send()
        }
    }
    @UserDefault("concertino.favoriteWorks", defaultValue: [String]()) var favoriteWorks: [String]
    @UserDefault("concertino.composersFavoriteWorks", defaultValue: [String]()) var composersFavoriteWorks: [String] {
        willSet {
            composersFavoriteWorksWillChange.send()
        }
        didSet {
            composersFavoriteWorksDidChange.send()
        }
    }
    @UserDefault("concertino.forbiddenComposers", defaultValue: [String]()) var forbiddenComposers: [String]
    @PlaylistsUserDefault("concertino.playlists") var playlists: [Playlist] {
        willSet {
            playlistsWillChange.send()
        }
        
        didSet {
            playlistsDidChange.send()
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

func MarkPlayed(settingStore: SettingStore, playState: PlayState, completion: @escaping (Data) -> ()) {
    APIpost("\(AppConstants.concBackend)/dyn/user/recording/played/", parameters: ["auth": authGen(userId: settingStore.userId, userAuth: settingStore.userAuth) ?? "", "id": settingStore.userId, "wid": playState.recording.first!.work!.id, "aid": playState.recording.first!.apple_albumid, "set": playState.recording.first!.set, "cover": playState.recording.first!.cover ?? AppConstants.concNoCoverImg, "performers": playState.recording.first!.jsonPerformers]) { results in
            completion(results)
    }
}

class AppleMusicSubscribeController: UIViewController {
    func showAppleMusicSignup() {
        let vc = SKCloudServiceSetupViewController()
        vc.delegate = self as? SKCloudServiceSetupViewControllerDelegate

        let options: [SKCloudServiceSetupOptionsKey: Any] = [
            .action: SKCloudServiceSetupAction.subscribe,
            .messageIdentifier: SKCloudServiceSetupMessageIdentifier.join
        ]
            
        vc.load(options: options) { success, error in
            if success {
                UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(vc, animated: true)
            }
        }
    }
}

public func startRadio(userId: Int, parameters: [String: Any], completion: @escaping (Data) -> ()) {
    APIpost("\(AppConstants.concBackend)/dyn/user/work/random/", parameters: ["id": userId, "popularcomposer": parameters["popularcomposer"] ?? "", "recommendedcomposer": parameters["recommendedcomposer"] ?? "", "popularwork": parameters["popularwork"] ?? "", "recommendedwork": parameters["recommendedwork"] ?? "", "genre": parameters["genre"] ?? "", "epoch": parameters["epoch"] ?? "", "composer": parameters["composer"] ?? "", "work": parameters["work"] ?? ""]) { results in
            completion(results)
    }
}

func randomRecording(workQueue: [Work], hideIncomplete: Bool, country: String, completion: @escaping ([Recording]) -> ()) {
    var workQ = workQueue
    let work = workQ.removeFirst()
    
    APIget(AppConstants.concBackend+"/recording/" + (country != "" ? country + "/" : "") + "list/work/\(work.id)/0.json") { results in
        if let recsData: Recordings = parseJSON(results) {
            if let recds = recsData.recordings {
                print("found, everything OK")
                if let rec = recds.filter({
                    ($0.isCompilation == false) || (hideIncomplete == false)
                }).randomElement() {
                    print("*️⃣ Compilation: \(rec.isCompilation)")
                    APIget(AppConstants.concBackend+"/recording/" + (country != "" ? country + "/" : "") + "detail/work/\(work.id)/album/\(rec.apple_albumid)/\(rec.set).json") { results in
                        if let recordingData: FullRecording = safeJSON(results) {
                            var rec = recordingData.recording
                            rec.work = recordingData.work
                            completion([rec])
                        }
                    }
                }
            }
            else {
                print("nothing found, starting again")
                randomRecording(workQueue: workQ, hideIncomplete: hideIncomplete, country: country) { rec in
                    completion(rec)
                }
            }
        }
    }
}

func getRecordingDetail(recording: Recording, country: String, completion: @escaping ([Recording]) -> ()) {
    APIget(AppConstants.concBackend+"/recording/" + (country != "" ? country + "/" : "") + "detail/work/\(recording.work!.id)/album/\(recording.apple_albumid)/\(recording.set).json") { results in
        if let recordingData: FullRecording = parseJSON(results) {
            var rec = recordingData.recording
            rec.work = recordingData.work
            completion([rec])
        }
    }
}

public func alertError(_ msg: String) {
    let alertController = UIAlertController(title: "Error", message:
        msg, preferredStyle: UIAlertController.Style.alert)
    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(alertController, animated: true, completion: nil)
}

extension UIViewController {
    func showToast(message: String) {
        let toastView = UIView(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height/2 - 75, width: 150, height: 150))
        //toastView.backgroundColor = Color(hex: 0xFE365E).uiColor().withAlphaComponent(1.0)
        toastView.backgroundColor = Color(hex: 0x7d7f82).uiColor().withAlphaComponent(0.7)
        toastView.alpha = 1.0
        toastView.layer.cornerRadius = 30
        toastView.clipsToBounds = false
        toastView.layer.shadowOpacity = 1
        toastView.layer.shadowColor = UIColor.black.cgColor
        toastView.layer.shadowRadius = 15
        toastView.layer.shadowOffset = .zero
        
        
        let toastLabel = UILabel()
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "Nunito-ExtraBold", size: 14.0)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastView.addSubview(toastLabel)
        
        NSLayoutConstraint.activate([
            toastLabel.topAnchor.constraint(equalTo: toastView.layoutMarginsGuide.centerYAnchor, constant: 28),
            toastLabel.centerXAnchor.constraint(equalTo: toastView.layoutMarginsGuide.centerXAnchor),
        ])
        
        let toastImage = UIImageView(frame: CGRect(x: (150/2)-(48/2), y: (150/2)-(36/2), width: 48, height: 36))
        toastImage.clipsToBounds = true
        toastImage.autoresizesSubviews = true
        toastImage.contentMode = UIView.ContentMode.scaleAspectFit
        toastImage.tintColor = UIColor.white
        toastImage.image = UIImage(named: "checked")
        toastView.addSubview(toastImage)
        
        self.view.addSubview(toastView)
        UIView.animate(withDuration: 1.0, delay: 1.5, options: .curveEaseOut, animations: {
            toastView.alpha = 0.0
        }, completion: {(isCompleted) in
            toastView.removeFromSuperview()
        })
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
      
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
      
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}

extension Array {
    func chunked(into size:Int) -> [[Element]] {
        
        var chunkedArray = [[Element]]()
        
        for index in 0...self.count {
            if index % size == 0 && index != 0 {
                chunkedArray.append(Array(self[(index - size)..<index]))
            } else if(index == self.count) {
                chunkedArray.append(Array(self[index - 1..<index]))
            }
        }
        
        return chunkedArray
    }
}

func getStoreFront(completion: @escaping (String?) -> ()) {
    SKCloudServiceController.requestAuthorization { status in
        if (SKCloudServiceController.authorizationStatus() == .authorized) {
            let controller = SKCloudServiceController()
            controller.requestStorefrontCountryCode { countryCode, error in
                completion(countryCode)
            }
        } else {
            completion(nil)
        }
    }
}

func userLogin(_ autoplay: Bool, completion: @escaping (_ country: String, _ canPlay: Bool, _ login: Login?) -> ()) {
    let settingStore = SettingStore()
    
    SKCloudServiceController.requestAuthorization { status in
        if (SKCloudServiceController.authorizationStatus() == .authorized) {
            let controller = SKCloudServiceController()
            controller.requestStorefrontCountryCode { countryCode, error in
                controller.requestCapabilities { capabilities, error in
                    if capabilities.contains(.musicCatalogPlayback) {
                            if timeframe(timestamp: settingStore.lastLogged, minutes: 120)  {
                                APIget(AppConstants.concBackend+"/applemusic/token.json") { results in
                                    let token: Token = parseJSON(results)
                                    controller.requestUserToken(forDeveloperToken: token.token) { userToken, error in
                                        APIpost("\(AppConstants.concBackend)/dyn/user/sslogin/", parameters: ["token": userToken ?? "", "auth": authGen(userId: settingStore.userId, userAuth: settingStore.userAuth) ?? "", "id": settingStore.userId, "country": countryCode ?? ""]) { results in
                                            print(String(decoding: results, as: UTF8.self))
                                            let login: Login = parseJSON(results)
                                
                                            completion(countryCode ?? "us", true, login)
                                        }
                                    }
                                }
                            } else {
                                completion(countryCode ?? "us", true, nil)
                            }
                    } else if capabilities.contains(.musicCatalogSubscriptionEligible) && autoplay {
                        DispatchQueue.main.async {
                            let amc = AppleMusicSubscribeController()
                            amc.showAppleMusicSignup()
                        }
                        
                        completion(countryCode ?? "us", false, nil)
                    } else {
                        completion(countryCode ?? "us", false, nil)
                    }
                }
            }
        } else {
            completion("us", false, nil)
        }
    }
}

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.topMostViewController()
    }
}
