//
//  Performer.swift
//  Concertino
//
//  Created by Kyle Dold on 09/01/2021.
//  Copyright © 2021 Open Opus. All rights reserved.
//

struct Performer: Codable {
    var name: String
    var role: String?
    
    var readableRole: String {
        get {
            var ret = ""
            
            if let rol = role {
                if (rol != "" && !AppConstants.groupList.contains(rol)) {
                    ret = ", \(rol)"
                }
            }
            
            return ret
        }
    }
}
