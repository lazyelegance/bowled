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
    
    var runs: Int = 0
    var balls: Int = 0
    var fours: Int = 0
    var sixes: Int = 0
    
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
            newBatsman.fours = Int(fours)
            newBatsman.sixes = Int(sixes)
            newBatsman.runs = Int(runs)
            
            return newBatsman
        }
        
        return Batsman(id: 0, name: "", runsScored: "0", ballsFaced: "0")
    }
    
    static func batsmanFromArray(batsmenArray: [[String: AnyObject]]) -> ([Batsman], [Batsman]) {
        var batsmanArray = [Batsman]()
        var batsmanToBatArray = [Batsman]()
        
        for item in batsmenArray {
            if let id = item["id"] as? NSNumber, let name = item["name"] as? String, let runsScored = item["runs"] as? String, let ballsFaced = item["balls"] as? String {
                var newBatsman = Batsman(id: id, name: name, runsScored: runsScored, ballsFaced: ballsFaced)
                print(item)
                if let fours = item["fours"] as? String, let sixes = item["sixes"] as? String, let strikeRate = item["strikeRate"] as? String {
                    
                    newBatsman.foursHit = fours
                    newBatsman.sixesHit = sixes
                    newBatsman.strikeRate = strikeRate
                    
                    print("\(newBatsman.name)...\(newBatsman.strikeRate)")
                }
                if let howOut = item["howOut"] as? String, let fallOfWicket = item["fallOfWicket"] as? String, let fallOfWicketOver = item["fallOfWicketOver"] as? String, let fowOrder = item["fowOrder"] as? NSNumber {
                    newBatsman.howOut = howOut
                    newBatsman.fallOfWicket = fallOfWicket
                    newBatsman.fallOfWicketOver = fallOfWicketOver
                    newBatsman.fowOrder = fowOrder
                }
                if newBatsman.strikeRate != "-" {
                    batsmanArray.append(newBatsman)
                } else {
                    batsmanToBatArray.append(newBatsman)
                }
            }
        }
        
        return (batsmanArray, batsmanToBatArray)
    }
}
