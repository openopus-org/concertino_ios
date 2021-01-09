//
//  FullRecording.swift
//  Concertino
//
//  Created by Kyle Dold on 09/01/2021.
//  Copyright © 2021 Open Opus. All rights reserved.
//

struct FullRecording: Codable {
    var work: Work
    var recording: Recording
}

extension FullRecording: Identifiable, Equatable {
    var id: String { return "\(recording.tracks!.first!.apple_trackid)-\(work.id)-\(recording.apple_albumid)-\(recording.set)" }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: FullRecording, rhs: FullRecording) -> Bool {
        return lhs.id == rhs.id
    }
}
