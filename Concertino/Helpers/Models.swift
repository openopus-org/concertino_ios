//
//  Models.swift
//  Concertino
//
//  Created by Adriano Brandao on 01/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct Composers: Codable {
    var composers: [Composer]?
}

struct Composer: Codable, Identifiable {
    let id: String
    var name: String
    var complete_name: String
    var birth: String?
    var death: String?
    var epoch: String
    var portrait: URL?
}

struct Genres: Codable {
    var genres: [String]?
}

struct Works: Codable {
    var works: [Work]?
}

struct Work: Codable, Identifiable {
    let id: String
    var title: String
    var subtitle: String?
    var genre: String
    var recommended: String?
    var popular: String?
    var composer: Composer?
}

struct Omnisearch: Codable {
    var results: [OmniResults]?
}

struct OmniResults: Codable {
    var composer: Composer
    var work: Work?
    var next: Int?
}

extension OmniResults: Identifiable {
    var id: String { return "work_\(work?.id ?? "0")_composer_\(composer.id)" }
}

struct PlaylistRecordings: Codable {
    var recordings: [Recording]?
}

struct FullRecording: Codable {
    var work: Work
    var recording: Recording
}

struct Recordings: Codable {
    var recordings: [Recording]?
    var next: String?
}

struct Track: Codable {
    var cd: Int
    var index: Int
    var length: Int
    var title: String
    var apple_trackid: String
    var starting_point: Int
    
    var readableLength: String {
        get { return convertSeconds(seconds: length) }
    }
}

extension Track: Identifiable {
    var id: String { return apple_trackid }
}

struct CurrentTrack: Codable {
    var track_index: Int
    var playing: Bool
    var loading: Bool
    var starting_point: Int
    var track_position: Int
    var track_length: Int
    var full_position: Int
    var full_length: Int
    
    var track_progress: CGFloat {
        get { return CGFloat(Double (track_position)/Double (track_length)) }
    }
    
    var full_progress: CGFloat {
        get { return CGFloat(Double (full_position)/Double (full_length)) }
    }
    
    var readable_track_position: String {
        get { return convertSeconds(seconds: track_position) }
    }
    
    var readable_full_position: String {
        get { return convertSeconds(seconds: full_position) }
    }
}

struct Recording: Codable {
    var cover: URL?
    var apple_albumid: String
    var singletrack: String?
    var compilation: String?
    var observation: String?
    var performers: [Performer]
    var set: Int
    var historic: String?
    var verified: String
    var label: String?
    var length: Int?
    var tracks: [Track]?
    var apple_tracks: [String]?
    var work: Work?
    
    var isVerified: Bool {
        get { return verified == "true" }
        set { verified = newValue ? "true" : "false" }
    }
    
    var isCompilation: Bool {
        get { return compilation == "true" }
        set { compilation = newValue ? "true" : "false" }
    }
    
    var readableLength: String {
        get { return convertSeconds(seconds: length ?? 0) }
    }
    
    var jsonPerformers: String {
        get {
            do {
                let jsonData = try JSONEncoder().encode(performers)
                return String(data: jsonData, encoding: .utf8)!
            } catch {
                return ""
            }
        }
    }
}

extension Recording: Identifiable, Equatable {
    var id: String { return "\(apple_albumid)-\(set)" }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Recording, rhs: Recording) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Performer: Codable {
    var name: String
    var role: String?
    
    var readableRole: String {
        get {
            var ret = ""
            
            if let rol = role {
                if (rol != "" && !AppConstants.groupList.contains(rol)) {
                    ret = ", \(rol)"
                }
            }
            
            return ret
        }
    }
}

struct Recommendations: Codable {
    var data: [Recommendation]
}

struct Recommendation: Codable, Identifiable {
    var id: String
    var type: String
}

struct Login: Codable {
    var user: User
    var composerworks: [String]?
    var works: [String]?
    var favorite: [String]?
    var forbidden: [String]?
    var playlists: [Playlist]?
}

struct User: Codable, Identifiable {
    var apple_recid: String
    var id: Int
    var auth: String?
}

struct Token: Codable {
    var token: String
}

struct Playlist: Codable, Identifiable {
    var id: String
    var name: String
    var owner: String
    var summary: PlaylistSummary
}

struct PlaylistSummary: Codable {
    var composers: PlaylistComposers
    var works: PlaylistWorks
}

struct PlaylistComposers: Codable {
    var portraits: [URL]
    var names: [String]
    var rows: Int
    
    var nameList: String {
        get {
            return (names.prefix(4).map{String($0)}).joined(separator: ", ")
        }
    }
}

struct PlaylistWorks: Codable {
    var rows: Int
}

struct AddComposer: Codable {
    var list: [String]
}

struct AddWork: Codable {
    var list: [String]
    var composerworks: [String]
}
