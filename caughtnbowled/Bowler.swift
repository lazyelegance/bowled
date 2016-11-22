//
//  Bowler.swift
//  Bowled
//
//  Created by Ezra Bathini on 21/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation


struct Bowler {
    
    var id: NSNumber
    var name: String
    var overs: String
    var maidens: String
    var runsConceded: String
    var wides = "0"
    var noBalls = "0"
    var wickets: String
    var ecomony: String
    var isTopWickettaker = false
    
    init(id: NSNumber, name: String, overs: String, maidens: String, runsConceded: String, wickets: String, economy: String) {
        self.id = id
        self.name = name
        self.overs = overs
        self.runsConceded = runsConceded
        self.maidens = maidens
        self.ecomony = economy
        self.wickets = wickets
    }
    
    
    static func bowlerFromArray(bowlersArray: [[String: AnyObject]]) -> [Bowler] {
        var bowlerArray = [Bowler]()
        
        for item in bowlersArray {
            if let id = item["id"] as? NSNumber, let name = item["name"] as? String, let overs = item["overs"] as? String, let maidens = item["maidens"] as? String, let runsConceded = item["runsConceded"] as? String, let wickets = item["wickets"] as? String, let economy = item["economy"] as? String {
                var newBowler = Bowler(id: id, name: name, overs: overs, maidens: maidens, runsConceded: runsConceded, wickets: wickets, economy: economy)

                
                if let noBalls = item["noBalls"] as? String, let wides = item["wides"] as? String {
                    newBowler.noBalls = noBalls
                    newBowler.wides = wides
                }
                
                bowlerArray.append(newBowler)
            }
        }
        
        return bowlerArray
    }
}
