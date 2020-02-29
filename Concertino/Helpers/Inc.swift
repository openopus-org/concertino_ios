//
//  Inc.swift
//  Concertino
//
//  Created by Adriano Brandao on 01/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import Foundation

struct AppConstants {
    static let openOpusBackend = "https://beta.api.openopus.org"
    static let concBackend = "https://beta.api.concertino.app"
    static let concFrontend = "https://beta.concertino.app"
    static let concNoCoverImg = concFrontend + "/img/nocover.png"
    static let genreList = ["Chamber", "Keyboard", "Orchestral", "Stage", "Vocal"]
    static let groupList = ["Orchestra", "Choir", "Ensemble"]
    static let maxPerformers = 5
    static let mainPerformersList = ["Orchestra", "Ensemble", "Piano", "Conductor", "Violin", "Cello"]
    static let appleLink = "https://geo.music.apple.com/us/album/-/"
    static let developerToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkZES0o3TE01U1QifQ.eyJpYXQiOjE1NzM1OTAwMTUsImV4cCI6MTU4OTE0MjAxNSwiaXNzIjoiVFhXMlc1MzJCOSJ9.Z5JuJKLdxX2M7yy9EePzrB-8zmKsP8KjrscjCCA3c1ielWqRvy8C3KX7Zqjn8fxnAYj-FoiAki4rYkX_vzNl3A"
    static let appleAPI = "https://api.music.apple.com/v1"
}
