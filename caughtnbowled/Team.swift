//
//  Team.swift
//  Bowled
//
//  Created by Ezra Bathini on 23/12/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation

struct Team {
    let id: NSNumber
    let name: String
    
    init(id: NSNumber, name: String) {
        self.id = id
        self.name = name
    }
}
