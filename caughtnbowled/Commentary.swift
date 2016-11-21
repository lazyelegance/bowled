//
//  Commentary.swift
//  Bowled
//
//  Created by Ezra Bathini on 21/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation


struct Commentary {
    var inningsArray = NSArray()
    var inningsCount = 0
    
    var inningsNamesArray = [String]()
    var innings0 = NSDictionary()
    var innings1 = NSDictionary()
    var innings2 = NSDictionary()
    var innings3 = NSDictionary()
    
    var currentBatsmanId = NSNumber()
    var currentOffStrikeBatsmanId = NSNumber()
    var currentBowlerId = NSNumber()
    
    init(inningsArray: NSArray ) {
        self.inningsArray  = inningsArray
    }
    
    static func commentaryFromAPI(_ results: NSDictionary) -> Commentary {
        var matchCommentary = Commentary(inningsArray: ["no data"])
        
        if results.count > 0 {
            //temp
            
            if let commentary = results["commentary"] as? NSDictionary {
                if let inningsArray = commentary["innings"] as? NSArray {
                    matchCommentary = Commentary(inningsArray: inningsArray)
                    matchCommentary.inningsCount = inningsArray.count
                    var inningsNamesArray = [String]()
                    for i in 0..<inningsArray.count {
                        if let currArray = inningsArray[i] as? NSDictionary {
                            switch i {
                            case 0:
                                matchCommentary.innings0 = currArray
                                let oversArray = currArray["overs"] as! NSArray
                                let latestOver = oversArray[0] as! NSDictionary
                                let ballsArray = latestOver["balls"] as! NSArray
                                
                                let latestBallDetail = ballsArray[0] as! NSDictionary
                                let commentsArray = latestBallDetail["comments"] as! NSArray
                                let commentDetail = commentsArray[0] as! NSDictionary
                                
                                matchCommentary.currentBatsmanId = commentDetail["batsmanId"] as! NSNumber
                                matchCommentary.currentOffStrikeBatsmanId = commentDetail["offStrikeBatsmanId"] as! NSNumber
                                matchCommentary.currentBowlerId = commentDetail["bowlerId"] as! NSNumber
                                
                                
                            case 1:
                                matchCommentary.innings1 = currArray
                            case 2:
                                matchCommentary.innings2 = currArray
                            case 3:
                                matchCommentary.innings3 = currArray
                            default:
                                break
                            }
                            
                            
                            
                            if let inningsName = currArray["name"] as? String {
                                inningsNamesArray.append(inningsName.uppercased())
                            }
                        }
                    }
                    
                    matchCommentary.inningsNamesArray = inningsNamesArray
                }
            } else {
                matchCommentary = Commentary(inningsArray: ["no commentary"])
            }
            
        } else {
            matchCommentary = Commentary(inningsArray: ["no data"])
        }
        
        
        
        
        return matchCommentary
        
    }
}
