//
//  Track.swift
//  Concertino
//
//  Created by Kyle Dold on 09/01/2021.
//  Copyright © 2021 Open Opus. All rights reserved.
//

import SwiftUI

struct Track: Codable {
    var cd: Int
    var index: Int
    var length: Int
    var title: String
    var apple_trackid: String
    var preview: URL?
    var starting_point: Int
    
    var readableLength: String {
        get { return convertSeconds(seconds: length) }
    }
}

extension Track: Identifiable {
    var id: String { return apple_trackid }
}
