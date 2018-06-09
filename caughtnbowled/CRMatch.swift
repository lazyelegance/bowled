//
//  CRMatch.swift
//  CricService
//
//  Created by Ezra Bathini on 9/06/18.
//  Copyright © 2018 Ezra Bathini. All rights reserved.
//

/*
 "unique_id": 1135149,
 "team-2": "Sri Lanka",
 "team-1": "West Indies",
 "type": "Test",
 "date": "2018-06-06T00:00:00.000Z",
 "dateTimeGMT": "2018-06-06T14:00:00.000Z",
 "squad": true,
 "toss_winner_team": "West Indies",
 "matchStarted": true
 */

import Foundation
import UIKit

struct CRMatch {
    let uniqueId: NSNumber
    let team1: String
    let team2: String
    let type: String
    let date: String
    let dateTimeGMT: String
    let squad: Bool
    var tossWinnerTeam: String = ""
    let matchStarted: Bool
    
    init(uniqueId: NSNumber,
         team1: String,
         team2: String,
         type: String,
         date: String,
         dateTimeGMT: String,
         squad: Bool,
         matchStarted: Bool) {
        self.uniqueId = uniqueId
        self.team1  = team1
        self.team2 = team2
        self.type = type
        self.date = date
        self.dateTimeGMT = dateTimeGMT
        self.squad = squad
        self.matchStarted = matchStarted
    }
    
    static func matchesFromApi(results: [AnyObject]) -> [CRMatch] {
        var matches = [CRMatch]()
        
        for result in results {
            if let uniqueId = result["unique_id"] as? NSNumber,let team1 = result["team-1"] as? String,let team2 = result["team-2"] as? String,let matchStarted = result["matchStarted"] as? NSNumber ,let type = result["type"] as? String,let squad = result["squad"] as? NSNumber,let date = result["date"] as? String,let dateTimeGMT = result["dateTimeGMT"] as? String{
                
                var newMatch = CRMatch(uniqueId: uniqueId, team1: team1, team2: team2, type: type, date: date, dateTimeGMT:dateTimeGMT, squad: Bool(truncating: squad), matchStarted: Bool(truncating: matchStarted))
                
                if let tossWinnerTeam = result["toss_winner_team"] as? String {
                    newMatch.tossWinnerTeam = tossWinnerTeam
                }
                
                matches.append(newMatch)
            }
        }
        return matches
    }
    
    
}
