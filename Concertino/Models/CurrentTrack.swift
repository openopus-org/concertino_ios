//
//  CurrentTrack.swift
//  Concertino
//
//  Created by Kyle Dold on 09/01/2021.
//  Copyright © 2021 Open Opus. All rights reserved.
//

import  SwiftUI

struct CurrentTrack: Codable {
    var track_index: Int
    var zero_index: Int
    var playing: Bool
    var loading: Bool
    var starting_point: Int
    var track_position: Int
    var track_length: Int
    var full_position: Int
    var full_length: Int
    var preview: Bool
    
    var track_progress: CGFloat {
        get { return CGFloat(Double (track_position)/(preview ? 30 : Double (track_length))) }
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
