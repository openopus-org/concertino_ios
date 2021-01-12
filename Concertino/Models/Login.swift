//
//  Login.swift
//  Concertino
//
//  Created by Kyle Dold on 09/01/2021.
//  Copyright © 2021 Open Opus. All rights reserved.
//

struct Login: Codable {
    var user: User
    var composerworks: [String]?
    var favoriterecordings: [String]?
    var works: [String]?
    var favorite: [String]?
    var forbidden: [String]?
    var playlists: [Playlist]?
    var country: String?
}

