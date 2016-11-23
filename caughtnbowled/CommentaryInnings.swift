//
//  CommentaryInnings.swift
//  Bowled
//
//  Created by Ezra Bathini on 23/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation


struct CommentaryInnings {
    var id: NSNumber
    var name: String
    var shortName: String
    var teamId: NSNumber
    var commentaryOvers = [CommentaryOver]()
    
    init(id: NSNumber, name: String, shortName: String, teamId: NSNumber) {
        self.id = id
        self.name = name
        self.shortName = shortName
        self.teamId = teamId
    }
}
