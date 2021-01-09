//
//  User.swift
//  Concertino
//
//  Created by Kyle Dold on 09/01/2021.
//  Copyright © 2021 Open Opus. All rights reserved.
//

struct User: Codable, Identifiable {
    var apple_recid: String
    var id: Int
    var auth: String?
    var heavyuser: Int?
}
