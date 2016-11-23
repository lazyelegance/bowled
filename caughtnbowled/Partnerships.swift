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
    var name: String
    var partnerships: [Partnership]
    
    init(name: String, partnerships: [Partnership]) {
        self.name = name
        self.partnerships = partnerships
    }
    
    static func partnershipsFromAPI(name: String, results: NSDictionary) -> Partnerships {
        
        if results.count > 0 {
            if let meta = results["meta"] as? NSDictionary {
                if let inningsid = meta["inningId"] as? NSNumber {
                    if let partners = results["partners"] as? [[String: AnyObject]] {
                        let partnerships = Partnership.partnershipsFromAray(partnerships: partners)
                        return Partnerships(name: name, partnerships: partnerships)
                    }
                }
            }
        }
        var dummyBatsman = Batsman(id: 0, name: "", runsScored: "", ballsFaced: "")
        var partnership = Partnership(firstBatsman: dummyBatsman, secondBatsman: dummyBatsman)
        return Partnerships(name: "", partnerships: [partnership])
    }
    
}
