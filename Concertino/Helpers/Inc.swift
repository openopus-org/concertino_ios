//
//  Inc.swift
//  Concertino
//
//  Created by Adriano Brandao on 01/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import Foundation

struct AppConstants {
    static let version = "1.20.1216"
    static let openOpusBackend = "https://api.openopus.org"
    static let concBackend = "https://api.concertino.app"
    static let concFrontend = "https://concertino.app"
    static let concShortFrontend = "https://cncert.in/r"
    static let concNoCoverImg = concFrontend + "/img/nocover.png"
    static let genreList = ["Chamber", "Keyboard", "Orchestral", "Stage", "Vocal"]
    static let periodList = ["Medieval", "Renaissance", "Baroque", "Classical", "Early Romantic", "Romantic", "Late Romantic", "20th Century", "Post-War", "21st Century"]
    static let groupList = ["Orchestra", "Choir", "Ensemble"]
    static let maxPerformers = 5
    static let mainPerformersList = ["Orchestra", "Ensemble", "Piano", "Conductor", "Violin", "Cello"]
    static let appleLink = "https://geo.music.apple.com/%%COUNTRY%%/album/-/"
    static let strucTopPadding = 50
    static let strucTopPadding14Offset = 50
    static let strucTopPaddingNoNotchOffset = 45
    static let strucTopPaddingSmallOffset = 10
    static let strucTopPaddingiPad14Offset = 0
    static let inAppPurchases = ["org.openopus.concertino.ios.tip", "org.openopus.concertino.ios.vgtip", "org.openopus.concertino.ios.sgtip"]
    static let minsToAskDonation = 7 * 24 * 60
    static let minsToAskDonationHasDonated = 30 * 24 * 60
    static let minsToLogin = 2 * 60
}
