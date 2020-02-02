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
