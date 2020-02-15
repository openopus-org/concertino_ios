//
//  Models.swift
//  Concertino
//
//  Created by Adriano Brandao on 01/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct Composers: Codable {
    var composers: [Composer]?
}

struct Composer: Codable, Identifiable {
    var id: String
    var name: String
    var complete_name: String
    var birth: String
    var death: String?
    var epoch: String
    var portrait: URL
}

struct Genres: Codable {
    var genres: [String]?
}

struct Works: Codable {
    var works: [Work]?
}

struct Work: Codable, Identifiable {
    var id: String
    var title: String
    var subtitle: String?
    var genre: String
    var recommended: String
    var popular: String
}

struct Recordings: Codable {
    var recordings: [Recording]?
    var next: String?
}

struct Recording: Codable, Identifiable {
    let id = UUID()
    var cover: URL
    var apple_albumid: String
    var singletrack: String
    var compilation: String
    var observation: String?
    var performers: [Performer]
    var set: Int
    var historic: String
    var verified: String
}

struct Performer: Codable {
    var name: String
    var role: String?
}
