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
    var shortName: String
    var logoString = "http://www.cricket.com.au/-/media/Logos/Teams/International/default.ashx"
    var teamColor = "#FFFFFF"
    var isInternational = false
    var isWomensTeam = false
    var teamType: String
    
    init(name: String, shortName: String, logoString: String, teamColor: String, isInternational: Bool, isWomensTeam: Bool, teamType: String ) {
        self.name = name
        self.shortName = shortName
        self.teamColor = teamColor
        self.logoString = logoString
        self.isInternational = isInternational
        self.isWomensTeam = isWomensTeam
        self.teamType = teamType
    }
}
