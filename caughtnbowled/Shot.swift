//
//  Shot.swift
//  Bowled
//
//  Created by Ezra Bathini on 15/12/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation

struct Shot {
    var ballId: NSNumber
    var batsmanId: NSNumber
    var bowlerId: NSNumber
    var fielderId: NSNumber
    var over = 0
    var runs = 0
    var angle = 0
    var distance = 0
    
    init(ballId: NSNumber) {
        self.ballId = ballId
        self.batsmanId = 0
        self.bowlerId = 0
        self.fielderId = 0
    }
    
    static func shotsFromArray(shotsArray: [[String: AnyObject]]) -> [Shot] {
        
        var shots = [Shot]()
        
        for item in shotsArray {
            if let ballId = item["ballId"] as? NSNumber, let batsmanId = item["batsmanId"] as? NSNumber, let bowlerId = item["bowlerId"] as? NSNumber, let fielderId = item["fielderId"] as? NSNumber, let over = item["over"] as? String, let runs = item["run"] as? String, let angle = item["angle"] as? String, let distance = item["distance"] as? String {
                var newShot = Shot(ballId: ballId)
                newShot.batsmanId = batsmanId
                newShot.bowlerId = bowlerId
                newShot.fielderId = fielderId
                if let runs_Int = Int(runs), let angle_Int = Int(angle), let over_Int = Int(over), let distance_Int = Int(distance) {
                    newShot.runs = runs_Int
                    newShot.angle = angle_Int
                    newShot.over = over_Int
                    newShot.distance = distance_Int
                }
                
                shots.append(newShot)
                
            }
        }
        
        return shots
    }
    
}
