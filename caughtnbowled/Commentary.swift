//
//  Commentary.swift
//  Bowled
//
//  Created by Ezra Bathini on 21/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation


struct Commentary {
    
    var status: NSNumber
    var commentaryInnings = [CommentaryInnings]()
    init(status: NSNumber ) {
        self.status = status
    }
    
    static func commentaryFromAPI(_ results: NSDictionary) -> Commentary {
        var matchCommentary = Commentary(status: 0)
        
        if results.count > 0 {
            //temp
            
            if let commentary = results["commentary"] as? NSDictionary {
                if let inningsArray = commentary["innings"] as? [AnyObject] {
                    
                    for inn in inningsArray {
                        if let id = inn["id"] as? NSNumber, let name = inn["name"] as? String, let shortName = inn["shortName"] as? String, let teamId = inn["teamId"] as? NSNumber, let overs = inn["overs"] as? [[String: AnyObject]] {
                            var newCommentaryInnings = CommentaryInnings(id: id, name: name, shortName: shortName, teamId: teamId)
                            
                            newCommentaryInnings.commentaryOvers = CommentaryOver.oversFromArray(overs: overs)
                            matchCommentary.commentaryInnings.append(newCommentaryInnings)
                        }
                    }
                }
            } else {
                matchCommentary = Commentary(status: 404)
            }
        } else {
            matchCommentary = Commentary(status: 404)
        }
        return matchCommentary
        
    }
}
