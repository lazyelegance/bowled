//
//  Scorecard.swift
//  Bowled
//
//  Created by Ezra Bathini on 20/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation


struct Scorecard {
    let status: String
    
    var fullScorecard = NSDictionary()
    var inningsArray = NSArray()
    var inningsCount = 0
    var fullScorecardAwards = NSDictionary()
    var manOfTheMatchName = String()
    var fowDict = [NSNumber: [FallOfWicket]]()
    
    
    var innings = [Innings]()
    
    
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
                                    newInnings.batsmen = Batsman.batsmanFromArray(batsmenArray: batsmenArray)
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
