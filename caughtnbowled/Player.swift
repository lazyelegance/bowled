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
    var imageURL = URL(fileURLWithPath: Bundle.main.path(forResource: "playerdefault", ofType: "png")!)
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
    
    var teamName = String()
    var teamId = NSNumber()
    var teamShortName = String()
    var teamLogoURL = URL(fileURLWithPath: Bundle.main.path(forResource: "playerdefault", ofType: "png")!)
    
    

    init(id: NSNumber, name: String) {
        self.id = id
        self.fullName = name
    }
    
    static func playersFromResults(results: [String: AnyObject]) -> [NSNumber: Player] {
        
        var homeTeamPlayers = [NSNumber: Player]()
        var awayTeamPlayers = [NSNumber: Player]()
        
        print("..getting match players... 2 ..")
    
        if let homeTeam = results["homeTeam"] as? [String: AnyObject] {
            if let playersArray = homeTeam["players"] as? [[String: AnyObject]], let team = homeTeam["team"] as? [String: AnyObject] {
                homeTeamPlayers = Player.playersFromArray(playersArray: playersArray, team: team)
            }
        }
        
        if let awayTeam = results["awayTeam"] as? [String: AnyObject] {
            if let playersArray = awayTeam["players"] as? [[String: AnyObject]], let team = awayTeam["team"] as? [String: AnyObject] {
                awayTeamPlayers = Player.playersFromArray(playersArray: playersArray, team: team)
            }
        }
        
        for one in awayTeamPlayers {
            homeTeamPlayers[one.key] = one.value
        }
        
        return homeTeamPlayers
    }
    
    static func playersFromArray(playersArray: [[String: AnyObject]], team: [String: AnyObject]) -> [NSNumber: Player] {
        var players = [NSNumber: Player]()
        for item in playersArray {
            if let id = item["playerId"] as? NSNumber, let name = item["fullName"] as? String {
                var player = Player(id: id, name: name)
                if let  firstName = item["firstName"] as? String, let lastName = item["lastName"] as? String, let imageURLString = item["imageURL"] as? String, let battingStyle = item["battingStyle"] as? String, let bowlingStyle = item["bowlingStyle"] as? String, let playerType = item["playerType"] as? String, let dob = item["dob"] as? String, let testDebutDate = item["testDebutDate"] as? String, let odiDebutDate = item["odiDebutDate"] as? String, let t20DebutDate = item["t20DebutDate"] as? String, let height = item["height"] as? String {
                    player.firstName = firstName
                    player.lastName = lastName
                    if let imageURL = URL(string: imageURLString) {
                        player.imageURL = imageURL
                    }
                    player.battingStyle = battingStyle
                    player.bowlingStyle = bowlingStyle
                    player.playerType = playerType
                    player.dateOfBirth = dob
                    player.testDebutDate = testDebutDate
                    player.odiDebutDate = odiDebutDate
                    player.t20DebutDate = t20DebutDate
                    player.height = height
                }
                
                if let teamName = team["name"] as? String, let teamId = team["id"] as? NSNumber, let teamShortName = team["shortName"] as? String, let teamLogoURLString = team["logoUrl"] as? String {
                    player.teamId = teamId
                    player.teamName = teamName
                    player.teamShortName = teamShortName
                    if let teamLogoURL = URL(string: teamLogoURLString) {
                        player.teamLogoURL = teamLogoURL
                    }
                }
                
                players[id] = player
            }
        }
        return players
        
    }
}
