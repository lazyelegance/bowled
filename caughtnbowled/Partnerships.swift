//
//  Partnerships.swift
//  Bowled
//
//  Created by Ezra Bathini on 21/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation

struct Partnerships {
    var isValid: Bool = false
    var inningsid: NSNumber
    var partnerships: [Partnership]
    
    init(inningsid: NSNumber, partnerships: [Partnership]) {
        self.inningsid = inningsid
        self.partnerships = partnerships
    }
    
    static func partnershipsFromAPI(results: NSDictionary) -> Partnerships {
        
        if results.count > 0 {
            if let meta = results["meta"] as? NSDictionary {
                if let inningsid = meta["inningId"] as? NSNumber {
                    if let partners = results["partners"] as? [[String: AnyObject]] {
                        let partnerships = Partnership.partnershipsFromAray(partnerships: partners)
                        return Partnerships(inningsid: inningsid, partnerships: partnerships)
                    }
                }
            }
        }
        var dummyBatsman = Batsman(id: 0, name: "", runsScored: "", ballsFaced: "")
        var partnership = Partnership(firstBatsman: dummyBatsman, secondBatsman: dummyBatsman)
        return Partnerships(inningsid: 0, partnerships: [partnership])
    }
    
}
