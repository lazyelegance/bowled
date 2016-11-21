//
//  Partnerships.swift
//  Bowled
//
//  Created by Ezra Bathini on 21/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation

struct Partnerships {
    var partners = NSArray()
    var inningsid = NSNumber()
    
    
    init(partners: NSArray, inningsid: NSNumber ) {
        self.partners  = partners
        self.inningsid = inningsid
    }
    
    static func partnershipsFromAPI(_ results: NSDictionary) -> Partnerships {
        let defPartnerships = Partnerships(partners: [], inningsid: -1)
        if results.count > 0 {
            if let meta = results["meta"] as? NSDictionary {
                if let inningsid = meta["inningId"] as? NSNumber {
                    if let partners = results["partners"] as? NSArray {
                        let partnerships = Partnerships(partners: partners, inningsid: inningsid)
                        return partnerships
                    }
                }
            }
        }
        return defPartnerships
    }
}
