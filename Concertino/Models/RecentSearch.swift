//
//  RecentSearch.swift
//  Concertino
//
//  Created by Kyle Dold on 09/01/2021.
//  Copyright © 2021 Open Opus. All rights reserved.
//

struct RecentSearch: Codable {
    var recording: Recording?
    var composer: Composer?
    var work: Work?
}

extension RecentSearch: Identifiable, Equatable {
    var id: String { return "albumid_\(recording?.apple_albumid ?? "0")_work_\(work?.id ?? "0")_composer_\(composer?.id ?? "0")" }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: RecentSearch, rhs: RecentSearch) -> Bool {
        return lhs.id == rhs.id
    }
}
