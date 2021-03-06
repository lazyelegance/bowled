//
//  Comment.swift
//  Bowled
//
//  Created by Ezra Bathini on 23/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation


struct Comment {
    var id: NSNumber
    var ballType: String
    var dateTime = String()// more later
    var text: String = "No Comments"
    var runs: String = ""
    var wickets: NSNumber = 0
    var battingTeamScore: NSNumber = 0
    
    var isFallOfWicket: Bool = false
    var batsmanId: NSNumber = 0
    var bowlerId: NSNumber = 0
    var offStrikeBatsmanId: NSNumber = 0
    var overNumber: NSNumber = 0
    var deliveryNumber: NSNumber = 0
    var result: String = ""
    var deliveryNumRep = "0.0"
    
    var isHighlight = false
    
    
    init(id: NSNumber, ballType: String) {
        self.id = id
        self.ballType = ballType
    }
    
    
    static func commentsFromArray(overNumber: NSNumber, deliveryNumber: NSNumber, result: String, comments: [[String: AnyObject]]) -> [Comment] {
        var commentsArray = [Comment]()
    
        commentsArray.removeAll()
        for item in comments {
            if let id = item["id"] as? NSNumber,
                let ballType = item["ballType"] as? String,
                let dateTime = item["dateTime"] as? String,
                let text = item["text"] as? String,
                let runs = item["runs"] as? String,
                let wickets = item["wickets"] as? NSNumber,
                let isFallOfWicket = item["isFallOfWicket"] as? Bool,
                let batsmanId = item["batsmanId"] as? NSNumber,
                let bowlerId = item["bowlerId"] as? NSNumber,
                let offStrikeBatsmanId = item["offStrikeBatsmanId"] as? NSNumber,
                let battingTeamScore = item["battingTeamScore"] as? NSNumber {
                var newComment = Comment(id: id, ballType: ballType)
                newComment.batsmanId = batsmanId
                newComment.battingTeamScore = battingTeamScore
                newComment.bowlerId = bowlerId
                newComment.dateTime = dateTime
                newComment.isFallOfWicket = isFallOfWicket
                newComment.offStrikeBatsmanId = offStrikeBatsmanId
                newComment.runs = runs
                newComment.text = text
                newComment.wickets = wickets
                
                newComment.overNumber = overNumber
                newComment.deliveryNumber = deliveryNumber
                
                
                
                newComment.deliveryNumRep = "\((overNumber as! Int) - 1).\(deliveryNumber)"
                
                
                switch ballType {
                case "Wide":
                    newComment.result = isFallOfWicket ? "W" : result + "wd"
                default:
                    newComment.result = isFallOfWicket ? "W" : result
                }
                
                if isFallOfWicket || result == "4" || result == "6" || ballType == "NonBallComment"{
                    newComment.isHighlight = true
                }
                
                
                commentsArray.append(newComment)
        
            }
        }
        
        return commentsArray
        
    }
    
    
}
