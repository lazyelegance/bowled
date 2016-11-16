//
//  CBSeries.swift
//  Bowled
//
//  Created by Ezra Bathini on 23/03/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation

struct CBTeamStanding {
    let teamId: NSNumber
    var teamName = String()
    var teamShortName = String()
    var groupName = String()
    var logoUrl = String()
    var position: Int = 0
    var played: NSNumber = 0
    var won: NSNumber = 0
    var drawn: NSNumber = 0
    var tied: NSNumber = 0
    var lost: NSNumber = 0
    var noResult: NSNumber = 0
    var bonus: NSNumber = 0
    var points: NSNumber = 0
    var netRunRate: NSNumber = 0
    
    init(teamId: NSNumber) {
        self.teamId = teamId
    }
    
    static func teamStandingFromResults(_ results: NSDictionary) -> CBTeamStanding {
        if results.count > 0 {
            if let id = results["id"] as? NSNumber, let name = results["name"] as? String, let shortName = results["shortName"] as? String, let groupName = results["groupName"] as? String {
                var team = CBTeamStanding(teamId: id)
                team.teamName = name
                team.teamShortName = shortName
                team.groupName = groupName
                
                if let logoUrl = results["logoUrl"] as? String {
                    team.logoUrl = logoUrl
                }
                if let played = results["played"] as? NSNumber, let won = results["won"] as? NSNumber, let drawn = results["drawn"] as? NSNumber, let tied = results["tied"] as? NSNumber, let lost = results["lost"] as? NSNumber, let noResult = results["noResult"] as? NSNumber, let bonus = results["bonus"] as? NSNumber, let points = results["points"] as? NSNumber, let netRunRate = results["netRunRate"] as? NSNumber, let position = results["position"] as? Int {
                    team.played = played
                    team.won = won
                    team.drawn = drawn
                    team.tied = tied
                    team.lost = lost
                    team.noResult = noResult
                    team.bonus = bonus
                    team.points = points
                    team.netRunRate = netRunRate
                    team.position = position
                }
                
                return team
                
            }
        }
        
        return CBTeamStanding(teamId: 0)
    }
    
}

struct CBSeries {
    let seriesId: NSNumber
    var state: String
    var isDomesticFirstClass: Bool = true
    var isReady = false
    var seriesName = String()
    var status: String
    var teams = [String: [CBTeamStanding]]()
    var result: String
    
    init(seriesId: NSNumber) {
        self.seriesId = seriesId
        self.state = "No State"
        self.status = "No Status"
        self.result = "No Result"
        
    }
    
    static func seriesStandingsFromResults(_ results: NSDictionary) -> CBSeries {
        if results.count > 0 {
            if let metaData = results["metaData"] as? NSDictionary {
                if let seriesId = metaData["seriesId"] as? NSNumber, let seriesName = metaData["series"] as? String, let state = metaData["state"] as? String, let result = metaData["result"] as? String {
                    var series = CBSeries(seriesId: seriesId)
                    series.seriesName = seriesName
                    series.state = state
                    series.result = result
                    
                    if let isDomesticFirstClass = metaData["isDomesticFirstClass"] as? Bool {
                        series.isDomesticFirstClass = isDomesticFirstClass
                    }
                    
                    if let teams = results["teams"] as? NSArray {
                        if teams.count > 0 {
                            series.teams.removeAll()
                            for team in teams {
                                if let group = team["groupName"] as? String {
                                    if series.teams[group] == nil {
                                        series.teams[group] = [CBTeamStanding.teamStandingFromResults(team as! NSDictionary)]
                                    } else {
                                        series.teams[group]?.append(CBTeamStanding.teamStandingFromResults(team as! NSDictionary))
                                    }
                                    
                                    
                                }
                                //series.teams.append(CBTeamStanding.teamStandingFromResults(team as! NSDictionary))
                            }
                        }
                    }
                    
                    return series
                    
                }
            }
        }
        
        
        return CBSeries(seriesId: 0)
    }
    
}
