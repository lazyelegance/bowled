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
    
    init(firstBatsman: Batsman, secondBatsman: Batsman) {
        self.firstBatsman = firstBatsman
        self.secondBatsman = secondBatsman
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
