//
//  Playlist.swift
//  Concertino
//
//  Created by Kyle Dold on 09/01/2021.
//  Copyright © 2021 Open Opus. All rights reserved.
//

struct Playlist: Codable, Identifiable {
    var id: String
    var name: String
    var owner: String
    var summary: PlaylistSummary
}
