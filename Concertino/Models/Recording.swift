//
//  Recording.swift
//  Concertino
//
//  Created by Kyle Dold on 09/01/2021.
//  Copyright © 2021 Open Opus. All rights reserved.
//

import SwiftUI

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
    var previews: [URL]?
    var work: Work?
    var position: Int?
    var recording_id: String?
    
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
    var id: String {
        if let rid = recording_id {
            return rid
        }
        else {
            return "\(work?.id ?? "0")-\(apple_albumid)-\(set)"
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Recording, rhs: Recording) -> Bool {
        return lhs.id == rhs.id
    }
}
