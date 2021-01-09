//
//  OmniResults.swift
//  Concertino
//
//  Created by Kyle Dold on 09/01/2021.
//  Copyright © 2021 Open Opus. All rights reserved.
//

struct OmniResults: Codable {
    var composer: Composer
    var work: Work?
    var next: Int?
}

extension OmniResults: Identifiable {
    var id: String { return "work_\(work?.id ?? "0")_composer_\(composer.id)" }
}
