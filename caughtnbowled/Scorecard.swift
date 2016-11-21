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
    var inningsNamesArray = [String]()
    var innings0 = NSDictionary()
    var innings1 = NSDictionary()
    var innings2 = NSDictionary()
    var innings3 = NSDictionary()
    
    
    var innings0batsmen = NSArray()
    var innings1batsmen = NSArray()
    var innings2batsmen = NSArray()
    var innings3batsmen = NSArray()
    var innings0bowlers = NSArray()
    var innings1bowlers = NSArray()
    var innings2bowlers = NSArray()
    var innings3bowlers = NSArray()
    var innings0toBat = NSArray()
    var innings1toBat = NSArray()
    var innings2toBat = NSArray()
    var innings3toBat = NSArray()
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
                        var inningsNamesArray = [String]()
                        
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
                        
                        for i in 0..<inningsArray.count {
                            
                            if let currArray = inningsArray[i] as? NSDictionary {
 
                                var fowArray = [FallOfWicket]()
                                fowArray.removeAll()
                                
                                if let currInningsId = currArray["id"] as? NSNumber {
                                    if let currBatsmanArray = currArray["batsmen"] as? [AnyObject]  {
                                        
                                        for currBatsman in currBatsmanArray {
                                            if let fowfullstring = currBatsman["fallOfWicket"] as? String{
                                                if let fowString = fowfullstring.components(separatedBy: "-") as? NSArray {
                                                    if let fow = Int(fowString[1] as! String)! as? Int {
                                                        if let fowov = currBatsman["fallOfWicketOver"] as? String {
                                                            if let fowo = currBatsman["fowOrder"] as? NSNumber {
                                                                fowArray.append(FallOfWicket(fallOfWicket: fowfullstring, fallOfWicketOver: fowov, fowOrder: fowo.intValue, fowRuns: fow))
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                            }
                                        }
                                        
                                        if let totalRuns = currArray["run"] as? String  {
                                            
                                            let totalRunsInt = Int(totalRuns)
                                            
                                            if fowArray.count > 1 {
                                                let lastFowCount = fowArray.count - 1
                                                let lastFowRuns = fowArray[lastFowCount].fowRuns
                                                let lastFowOrder = fowArray[lastFowCount].fowOrder
                                                
                                                
                                                let currFowRuns = totalRunsInt!
                                                let currFowOrder = lastFowOrder + 1
                                                
                                                fowArray.append(FallOfWicket(fallOfWicket: "In Progress", fallOfWicketOver: "In Progress", fowOrder: currFowOrder, fowRuns: currFowRuns))
                                            } else {
                                                fowArray.append(FallOfWicket(fallOfWicket: "In Progress", fallOfWicketOver: "In Progress", fowOrder: 0, fowRuns: totalRunsInt!))
                                            }
                                            
                                            
                                        }
                                        
                                        fowArray.sort { (item1, item2) -> Bool in
                                            let item1foworder = item1.fowOrder
                                            let item2foworder = item2.fowOrder
                                            return item1foworder < item2foworder
                                        }
                                        
                                        newScorecard.fowDict[currInningsId] = fowArray
                                        for i in 0..<fowArray.count {
                                            if i == 0 {
                                                fowArray[i].partnershipRuns = fowArray[i].fowRuns
                                            } else {
                                                
                                                fowArray[i].partnershipRuns = fowArray[i].fowRuns - fowArray[(i - 1)].fowRuns
                                            }
                                        }
                                        
                                        newScorecard.fowDict[currInningsId] = fowArray
                                    }
                                }
                                switch i {
                                case 0:
                                    newScorecard.innings0 = currArray
                                    newScorecard.innings0batsmen = currArray["batsmen"] as! NSArray
                                    newScorecard.innings0bowlers = currArray["bowlers"] as! NSArray
                                case 1:
                                    newScorecard.innings1 = currArray
                                case 2:
                                    newScorecard.innings2 = currArray
                                case 3:
                                    newScorecard.innings3 = currArray
                                default:
                                    break
                                }
                                
                                if let inningsName = currArray["name"] as? String {
                                    inningsNamesArray.append(inningsName.uppercased())
                                }
                            }
                        }
                        
                        
                        newScorecard.inningsNamesArray = inningsNamesArray
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
