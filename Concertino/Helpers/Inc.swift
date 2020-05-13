//
//  Inc.swift
//  Concertino
//
//  Created by Adriano Brandao on 01/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import Foundation

struct AppConstants {
    static let version = "1.20.4.24"
    static let openOpusBackend = "https://api.openopus.org"
    static let concBackend = "https://beta.api.concertino.app"
    static let concFrontend = "https://concertino.app"
    static let concShortFrontend = "https://cncert.in/r"
    static let concNoCoverImg = concFrontend + "/img/nocover.png"
    static let genreList = ["Chamber", "Keyboard", "Orchestral", "Stage", "Vocal"]
    static let periodList = ["Medieval", "Renaissance", "Baroque", "Classical", "Early Romantic", "Romantic", "Late Romantic", "20th Century", "Post-War", "21st Century"]
    static let groupList = ["Orchestra", "Choir", "Ensemble"]
    static let maxPerformers = 5
    static let mainPerformersList = ["Orchestra", "Ensemble", "Piano", "Conductor", "Violin", "Cello"]
    static let appleLink = "https://geo.music.apple.com/%%COUNTRY%%/album/-/"
}
