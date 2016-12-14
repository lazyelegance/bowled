//
//  Scorecard.swift
//  Bowled
//
//  Created by Ezra Bathini on 20/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation

struct ManOfTheMatch {
    var id: NSNumber
    var name: String
    var batting: String = "0 (0)"
    var bowling: String = "0/0"
    var hasBatting = false
    var hasBowling = false
    
    init(id: NSNumber, name: String) {
        self.id = id
        self.name = name
    }
}

struct TopBatsman {
    var id: NSNumber
    var name: String
    var batting: String = "0 (0)"
    
    init(id: NSNumber, name: String) {
        self.id = id
        self.name = name
    }
}

struct TopBowler {
    var id: NSNumber
    var name: String
    var bowling: String = "0/0"
    
    init(id: NSNumber, name: String) {
        self.id = id
        self.name = name
    }
}

struct Scorecard {
    let status: String
    
    var fullScorecard = NSDictionary()
    var inningsArray = NSArray()
    var inningsCount = 0
    var fullScorecardAwards = NSDictionary()
    var manOfTheMatchName = String()
    var fowDict = [NSNumber: [FallOfWicket]]()
    
    var innings = [Innings]()
    
    var hasMotM = false
    
    var motm = ManOfTheMatch(id: 0, name: "")
//    var topBatsman = TopBatsman()
//    var topBowler = TopBowler()
    
    
    var poweredBy = String()
    
    init(status: String ) {
        self.status = status
    }
    
    static func scorecardFromAPI(_ results: NSDictionary) -> Scorecard {
        var scorecard: Scorecard = Scorecard(status: "no results")
        
        if results.count > 0 {
            //temp
            if let status = results["status"] as? NSNumber {
                var newScorecard = Scorecard(status: "\(status)")
                if let fullScorecardAwards = results["fullScorecardAwards"] as? NSDictionary {
                    newScorecard.fullScorecardAwards = fullScorecardAwards
                    if let manOfTheMatchId = fullScorecardAwards["manOfTheMatchId"] as? NSNumber, let motmBattingResults = fullScorecardAwards["manOfMatchBattingResults"] as? [[String : AnyObject]]  , let motmBowlingResults = fullScorecardAwards["manOfMatchBowlngResults"] as? [[String : AnyObject]]  , let mostRunsResults = fullScorecardAwards["mostRunsAwardPlayerResults"] as? [[String : AnyObject]], let mostWicketsResults = fullScorecardAwards["mostRunsAwardPlayerResults"] as? [[String : AnyObject]]  {
                        
                        if (manOfTheMatchId != -1) {
                            newScorecard.hasMotM = true
                            var motm = ManOfTheMatch(id: 0, name: "")
                            if motmBattingResults.count > 0 {
                                for motmBattingResult in motmBattingResults {
                                    if let id = motmBattingResult["id"] as? NSNumber, let name = motmBattingResult["name"] as? String, let runs = motmBattingResult["runs"] as? String, let balls = motmBattingResult["balls"] as? String {
                                        motm.id = id
                                        motm.name = name
                                        
                                        if runs != "" {
                                            motm.batting = motm.batting == "0 (0)" ? runs + " (" + balls + ") " : motm.batting + " & " + runs + " (" + balls + ") "
                                            motm.hasBatting = true
                                        }
                
                                    }
                                }
                            }
                            if motmBowlingResults.count > 0 {
                                for motmBowlingResult in motmBowlingResults {
                                    if let id = motmBowlingResult["id"] as? NSNumber, let name = motmBowlingResult["name"] as? String, let runs = motmBowlingResult["runsConceded"] as? String, let wickets = motmBowlingResult["wickets"] as? String {
                                        motm.id = id
                                        motm.name = name
                                        motm.bowling = motm.bowling == "0/0" ? runs + "/" + wickets : motm.bowling + " & " + runs + "/" + wickets
                                        motm.hasBowling = true
                                    }
                                }
                            }
                            newScorecard.motm = motm
                        }
                    }
                }
                if let fullScorecard = results["fullScorecard"] as? NSDictionary {
                    newScorecard.fullScorecard = fullScorecard
                    if let inningsArray = fullScorecard["innings"] as? [AnyObject] {
                        newScorecard.inningsCount = inningsArray.count
                        newScorecard.inningsArray = inningsArray as NSArray
                        
                        for inn in inningsArray {
                            if let id = inn["id"] as? NSNumber, let name = inn["name"] as? String, let team = inn["team"] as? [String: AnyObject] {
                                var newInnings = Innings(id: id, name: name, teamId: team["id"] as! NSNumber, teamShortName: team["shortName"] as! String)
                                if let run = inn["run"] as? String, let wicket = inn["wicket"] as? String, let over = inn["over"] as? String, let extra = inn["extra"] as? String, let bye = inn["bye"] as? String, let legBye = inn["legBye"] as? String, let wide = inn["wide"] as? String, let noBall = inn["noBall"] as? String, let runRate = inn["runRate"] as? String, let requiredRunRate = inn["requiredRunRate"] as? String   {
                                    newInnings.bye = bye
                                    newInnings.legBye = legBye
                                    newInnings.wide = wide
                                    newInnings.noBall = noBall
                                    newInnings.extra = extra
                                    
                                    newInnings.runRate = runRate
                                    newInnings.requiredRunRate = requiredRunRate
                                    
                                    newInnings.run = run
                                    newInnings.wicket = wicket
                                    newInnings.over = over
                                }
                                
                                if let batsmenArray = inn["batsmen"] as? [[String: AnyObject]], let bowlersArray = inn["bowlers"] as? [[String: AnyObject]] {
                                    (newInnings.batsmen, newInnings.batsmenToBat) = Batsman.batsmanFromArray(batsmenArray: batsmenArray)
                                    newInnings.bowlers = Bowler.bowlerFromArray(bowlersArray: bowlersArray)
                                }

                                newScorecard.innings.append(newInnings)
                            }
                        }
                    }
                    
                }
                scorecard = newScorecard
                
                return scorecard
            } else if let status = results["status"] as? String {
                scorecard = Scorecard(status: status)
                return scorecard
            }
        }
        
        return scorecard
        
        
    }
}
