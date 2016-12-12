//
//  Player.swift
//  Bowled
//
//  Created by Ezra Bathini on 12/12/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation

struct Player {
    var id: NSNumber
    var fullName: String
    var firstName = String()
    var lastName = String()
    var imageURLString = String()
    var battingStyle = String()
    var bowlingStyle = String()
    var playerType = String()
    var dateOfBirth = String()
    var testDebutDate = String()
    var odiDebutDate = String()
    var t20DebutDate = String()
    var bio = String()
    var didYouKnow = String()
    var height = String()

    init(id: NSNumber, name: String) {
        self.id = id
        self.fullName = name
    }
    
    static func playersFromResults(results: [String: AnyObject]) -> [Player] {
        var players = [Player]()
        print("..getting match players... 2 ..")
        return players
    }
}
