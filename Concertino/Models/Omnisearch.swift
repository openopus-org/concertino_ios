//
//  Omnisearch.swift
//  Concertino
//
//  Created by Kyle Dold on 09/01/2021.
//  Copyright © 2021 Open Opus. All rights reserved.
//

struct Omnisearch: Codable {
    var recordings: [Recording]?
    var composers: [Composer]?
    var works: [Work]?
    var next: Int?
}
