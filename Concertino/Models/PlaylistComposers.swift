//
//  PlaylistComposers.swift
//  Concertino
//
//  Created by Kyle Dold on 09/01/2021.
//  Copyright © 2021 Open Opus. All rights reserved.
//

import SwiftUI

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
