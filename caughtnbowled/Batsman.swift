//
//  Batsman.swift
//  Bowled
//
//  Created by Ezra Bathini on 21/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation


struct Batsman {
    
    var id: NSNumber
    var name: String
    var runsScored: String
    var ballsFaced: String
    var foursHit = "0"
    var sixesHit = "0"
    var strikeRate = "0.0"
    var fallOfWicket = "0/0"
    var fallOfWicketOver = "0.0"
    var fowOrder: NSNumber = 2
    var howOut = "Not Out"
    var isTopScorer = false
    var indexForPartnership: NSNumber = 0
    
    init(id: NSNumber, name: String, runsScored: String, ballsFaced: String) {
        self.id = id
        self.name = name
        self.runsScored = runsScored
        self.ballsFaced = ballsFaced
    }
    
    static func batsmanFromDictionary(batsmanDictionary: [String: AnyObject]) -> Batsman {
        
        if let playerId = batsmanDictionary["playerId"] as? NSNumber, let playerIndex = batsmanDictionary["playerIndex"] as? NSNumber, let name = batsmanDictionary["name"] as? String, let runs = batsmanDictionary["runs"] as? NSNumber, let balls = batsmanDictionary["balls"] as? NSNumber, let fours = batsmanDictionary["fours"] as? NSNumber, let sixes = batsmanDictionary["sixes"] as? NSNumber  {
            var newBatsman = Batsman(id: playerId, name: name, runsScored: String(describing: runs), ballsFaced: String(describing: balls))
            newBatsman.indexForPartnership = playerIndex
            newBatsman.foursHit = String(describing: fours)
            newBatsman.sixesHit = String(describing: sixes)
            return newBatsman
        }
        
        return Batsman(id: 0, name: "", runsScored: "0", ballsFaced: "0")
    }
    
    static func batsmanFromArray(batsmenArray: [[String: AnyObject]]) -> [Batsman] {
        var batsmanArray = [Batsman]()
        
        for item in batsmenArray {
            if let id = item["id"] as? NSNumber, let name = item["name"] as? String, let runsScored = item["runs"] as? String, let ballsFaced = item["balls"] as? String {
                var newBatsman = Batsman(id: id, name: name, runsScored: runsScored, ballsFaced: ballsFaced)
                
                if let fours = item["fours"] as? String, let sixes = item["sixes"] as? String, let strikeRate = item["strikeRate"] as? String, let howOut = item["howOut"] as? String, let fallOfWicket = item["fallOfWicket"] as? String, let fallOfWicketOver = item["fallOfWicketOver"] as? String, let fowOrder = item["fowOrder"] as? NSNumber {
                    newBatsman.fallOfWicket = fallOfWicket
                    newBatsman.fallOfWicketOver = fallOfWicketOver
                    newBatsman.fowOrder = fowOrder
                    newBatsman.foursHit = fours
                    newBatsman.sixesHit = sixes
                    newBatsman.strikeRate = strikeRate
                    newBatsman.howOut = howOut
                }
                batsmanArray.append(newBatsman)
            }
        }
        
        return batsmanArray
    }
}
