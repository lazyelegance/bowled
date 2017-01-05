//
//  BattingWheel.swift
//  Bowled
//
//  Created by Ezra Bathini on 15/12/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation

struct BattingWheel {
    var matchId: NSNumber
//    var seriesId: NSNumber
    var inningsId: NSNumber
    var teamId: NSNumber
    var runs = String()
    var balls = String()
    var fours = String()
    var sixes = String()
    var strikeRate = String()
    var shots = [Shot]()
    
    init(matchId: NSNumber, inningsId: NSNumber, teamId: NSNumber) {
        self.matchId = matchId
//        self.seriesId = seriesId
        self.inningsId = inningsId
        self.teamId = teamId
    }
    
    static func battingWheelFromResults(matchId: NSNumber, inningsId: NSNumber, results: NSDictionary) -> BattingWheel {
        
        if let bw = results["battingWheel"] as? [String: AnyObject] {
            if let teamId = bw["teamId"] as? NSNumber, let runs = bw["run"] as? String, let balls = bw["ball"] as? String, let fours = bw["four"] as? String, let six = bw["six"] as? String, let strikeRate = bw["strikeRate"] as? String, let shotsArray = bw["shots"] as? [[String: AnyObject]] {
                var newBattingWheel = BattingWheel(matchId: matchId, inningsId: inningsId, teamId: teamId)
                newBattingWheel.runs = runs
                newBattingWheel.balls = balls
                newBattingWheel.fours = fours
                newBattingWheel.sixes = six
                newBattingWheel.strikeRate = strikeRate
                newBattingWheel.shots = Shot.shotsFromArray(shotsArray: shotsArray)
                return newBattingWheel
            }
        }
        
        return BattingWheel(matchId: 0, inningsId: 0, teamId: 0)
    }
}
