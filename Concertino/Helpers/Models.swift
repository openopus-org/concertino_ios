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

struct Recordings: Codable {
    var recordings: [Recording]?
    var next: String?
}

struct FullRecording: Codable {
    var work: Work
    var recording: Recording
}

struct Track: Codable {
    var cd: Int
    var position: Int
    var length: Int
    var title: String
    var apple_trackid: String
    
    var readableLength: String {
        get { return convertSeconds(seconds: length) }
    }
}

extension Track: Identifiable {
    var id: String { return apple_trackid }
}

struct CurrentTrack: Codable {
    var track: Track
    var playing: Bool
    var position: Int
    
    var readablePosition: String {
        get { return convertSeconds(seconds: position) }
    }
}

struct Recording: Codable {
    var cover: URL
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
    
    var isVerified: Bool {
        get { return verified == "true" }
        set { verified = newValue ? "true" : "false" }
    }
    
    var readableLength: String {
        get { return convertSeconds(seconds: length ?? 0) }
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
