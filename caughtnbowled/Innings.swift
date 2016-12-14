//
//  Innings.swift
//  Bowled
//
//  Created by Ezra Bathini on 21/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation


struct Innings {
    var id: NSNumber
    var name: String
    var teamId: NSNumber
    var teamShortName: String
    var wicket = "0"
    var run = "0"
    var over = "0"
    var extra = "0"
    var bye = "0"
    var legBye = "0"
    var wide = "0"
    var noBall = "0"
    var runRate = "0.00"
    var requiredRunRate = ""
    var isDeclared = false
    
    var batsmen = [Batsman]()
    var bowlers = [Bowler]()
    var batsmenToBat = [Batsman]()
    
    init(id: NSNumber, name: String, teamId: NSNumber, teamShortName: String) {
        self.id = id
        self.name = name
        self.teamId = teamId
        self.teamShortName = teamShortName
    }
}
