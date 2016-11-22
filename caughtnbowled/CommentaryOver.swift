//
//  CommentaryOver.swift
//  Bowled
//
//  Created by Ezra Bathini on 23/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation

struct CommentaryOver {
    var id: NSNumber
    var uniqueOverId: String
    var overNumber: NSNumber
    var deliveries = [Delivery]()
    
    
    init(id: NSNumber, overNumber: NSNumber, uniqueOverId: String) {
        self.id = id
        self.overNumber = overNumber
        self.uniqueOverId = uniqueOverId
        
    }
    
    static func oversFromArray(overs: [[String: AnyObject]]) -> [CommentaryOver] {
        var overArray = [CommentaryOver]()
        overArray.removeAll()
        
        for item in overs {
            if let id = item["id"] as? NSNumber, let uniqueOverId = item["uniqueOverId"] as? String, let overNumber = item["number"] as? NSNumber, let deliveries = item["balls"] as? [[String: AnyObject]] {
                var newCommentaryOver = CommentaryOver(id: id, overNumber: overNumber, uniqueOverId: uniqueOverId)
               
                newCommentaryOver.deliveries = Delivery.deliveriesFromArray(deliveries: deliveries)
                overArray.append(newCommentaryOver)
            }
        }
        
        
        return overArray
    }
}
