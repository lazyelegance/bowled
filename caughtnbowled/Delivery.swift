//
//  Delivery.swift
//  Bowled
//
//  Created by Ezra Bathini on 23/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation

struct Delivery {
    var id: NSNumber
    var ballNumber: NSNumber
    var result: String
    var comments = [Comment]()
    
    init(id: NSNumber, ballNumber: NSNumber, result: String) {
        self.id = id
        self.ballNumber = ballNumber
        self.result = result
    }
    
    static func deliveriesFromArray(deliveries: [[String: AnyObject]]) -> [Delivery] {
        var deliveryArray = [Delivery]()
        deliveryArray.removeAll()
        for item in deliveries {
            if let id = item["id"] as? NSNumber, let ballNumber = item["ballNumber"] as? NSNumber, let result = item["result"] as? String, let comments = item["comments"] as? [[String: AnyObject]] {
                var newDelivery = Delivery(id: id, ballNumber: ballNumber, result: result)
                newDelivery.comments = Comment.commentsFromArray(comments: comments)
                
                deliveryArray.append(newDelivery)
            }
        }
        
        
        return deliveryArray
        
    }
}
