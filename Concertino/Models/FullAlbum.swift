//
//  FullAlbum.swift
//  Concertino
//
//  Created by Kyle Dold on 09/01/2021.
//  Copyright © 2021 Open Opus. All rights reserved.
//

struct FullAlbum: Codable {
    var album: Album
    var recordings: [FullRecording]
}
