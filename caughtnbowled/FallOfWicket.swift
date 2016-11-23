//
//  FallOfWicket.swift
//  Bowled
//
//  Created by Ezra Bathini on 20/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation

struct FallOfWicket {
    var fallOfWicket = String()
    var fowRuns = Int()
    var fallOfWicketOver = String()
    var fowOrder = Int()
    var partnershipRuns = Int()
    
    init(fallOfWicket: String, fallOfWicketOver: String, fowOrder: Int, fowRuns: Int ) {
        self.fallOfWicket = fallOfWicket
        self.fallOfWicketOver = fallOfWicketOver
        self.fowOrder = fowOrder
        self.fowRuns = fowRuns
        self.partnershipRuns = 0
    }
}
