//
//  Partnership.swift
//  Bowled
//
//  Created by Ezra Bathini on 23/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation


struct Partnership {
    var firstBatsman: Batsman
    var secondBatsman: Batsman
    var totalRuns: Int
    var firstBatsmanContrib: Float
    var secondBatsmanContrib: Float
    
    init(firstBatsman: Batsman, secondBatsman: Batsman) {
        self.firstBatsman = firstBatsman
        self.secondBatsman = secondBatsman
        
        if (firstBatsman.runs + secondBatsman.runs) != 0 {
            self.totalRuns = firstBatsman.runs + secondBatsman.runs
            self.firstBatsmanContrib = Float(firstBatsman.runs) * 2 / Float(firstBatsman.runs + secondBatsman.runs)
            self.secondBatsmanContrib = Float(secondBatsman.runs) * 2 / Float(firstBatsman.runs + secondBatsman.runs)
        } else {
            self.totalRuns = 0
            self.firstBatsmanContrib = 0.0
            self.secondBatsmanContrib = 0.0
        }
    }
    
    static func partnershipsFromAray(partnerships: [[String: AnyObject]]) -> [Partnership] {
        var partnershipsArray = [Partnership]()
        
        for item in partnerships {
            if let f = item["firstBatsman"] as? [String: AnyObject], let s = item["secondBatsman"] as? [String: AnyObject] {
                partnershipsArray.append(Partnership(firstBatsman: Batsman.batsmanFromDictionary(batsmanDictionary: f), secondBatsman: Batsman.batsmanFromDictionary(batsmanDictionary: s)))
            }
        }
        return partnershipsArray
    }
}
