//
//  Album.swift
//  Concertino
//
//  Created by Kyle Dold on 09/01/2021.
//  Copyright © 2021 Open Opus. All rights reserved.
//

import SwiftUI

struct Album: Codable {
    var cover: URL?
    var apple_albumid: String
    var title: String
    var label: String
    var length: Int?
    var apple_tracks: [String]?
    var previews: [URL]?
    var year: String
    
    var readableLength: String {
        get { return convertSeconds(seconds: length ?? 0) }
    }
}
