//
//  Team.swift
//  Bowled
//
//  Created by Ezra Bathini on 23/12/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation

struct Team {
    var id: NSNumber = 0
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    init(id: NSNumber, name: String) {
        self.id = id
        self.name = name
    }
}
