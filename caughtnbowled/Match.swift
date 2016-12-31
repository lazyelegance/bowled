//
//  Match.swift
//  caughtnbowled
//
//  Created by Ezra Bathini on 16/10/15.
//  Copyright © 2015 Ezra Bathini. All rights reserved.
//

import Foundation
import UIKit



struct Match {
    
    let matchId: NSNumber
    var matchTypeId  = NSNumber()
    
    let seriesId: NSNumber
    var seriesName: String = "series name"
    var seriesSName: String = "shortName"
    var seriesshieldImageUrl: URL!
    
    
    var matchName: String = "match name"
    var status = MatchStatus.none
    
    var venueName: String = "venue name"
    var venueSName: String = "venue shot name"
    
    var hometeamId = NSNumber()
    var hometeamName  = String()
    var hometeamSName  = String()
    var hometeamLogoURL: URL!
    var hometeamLogo = UIImage()
    var hometeamColor  = String()
    var hometeamIsBatting: Bool = false
    var hometeamIsSelected: Bool = false
    
    var awayteamId = NSNumber()
    var awayteamName  = String()
    var awayteamSName  = String()
    var awayteamLogoURL: URL!
    var awayteamLogo = UIImage()
    var awayteamColor  = String()
    var awayteamIsBatting: Bool = false
    var awayteamIsSelected: Bool = false
    
    var currentMatchState: String = "current match state"
    var isMultiDay: Bool = false
    var matchSummaryText: String = "Match Summary"
    
    var scores = NSDictionary()
    var miniscoreexists = false
    var homeScore = String()
    var homeRuns = String()
    var homeWickets = String()
    var homeRunRate = String()
    var awayScore = String()
    var homeOvers = String()
    var awayOvers = String()
    var awayRuns = String()
    var awayWickets = String()
    var awayRunRate = String()
    
    var isMatchDrawn: Bool = false
    var isMatchAbandoned: Bool = false
    
    var winningTeamId: NSNumber = 999999
    var startDateTimeUTCDateFormat = Date()
    var startDateTimeUTC = String()
    var startDateTimeLocalDateFormat = Date()
    var startDateTimeLocal = String()
    var endDateTime = String()
    var localStartDate = String()
    var localStartTime = String()
    var hasRelDate = false
    var relStartDate = String()
    var relStartDateHuman = String()
    
    var isWomensMatch: Bool = false
    var isInternational: Bool = false
    var cmsMatchType = String()
    var cmsMatchAssociatedType = String()
    
    
    
    
    
    
    
    init(matchId: NSNumber, seriesId: NSNumber, status: MatchStatus ) {
        self.matchId = matchId
        self.seriesId = seriesId
        self.status = status
    }
    
    static func topMatchesFromAPI(results: [AnyObject], internationalOnly: Bool) -> ([Match],[Match],[Match],[Match]) {
        let (liveMatches, completedMatches, upcomingMatches) = self.filterMatchesFromAPI(results: results, internationalOnly: internationalOnly)
        var topMatches = [Match]()
        
        if liveMatches.count > 0 {
            topMatches = liveMatches
        }
        
        if completedMatches.count > 0 {
//            var i = 0
            for match in completedMatches {
                if match.hasRelDate {
                    topMatches.append(match)
//                    i += 1
                }
            }
        }
        
        
        
        if upcomingMatches.count > 0 {
            var i = 0
            for match in upcomingMatches {
                if match.hasRelDate && i < 2 && match.hometeamName != "To Be Decided" && match.awayteamName != "To Be Decided" {
                    topMatches.append(match)
                    i += 1
                }
            }
        }
        
        if topMatches.count > 1 {
            let series = topMatches[1].seriesId
            var dummy = Match(matchId: 0, seriesId: series, status: .dummy_series)
            dummy.seriesName = topMatches[1].seriesName
            topMatches.insert(dummy, at: 2)
        }
        
        
        

        
        return (topMatches, liveMatches, completedMatches, upcomingMatches)
    }
    
    
    static func filterMatchesFromAPI(results: [AnyObject], internationalOnly: Bool) -> ([Match],[Match],[Match]) {
        var liveMatches = [Match]()
        var completedMatches = [Match]()
        var upcomingMatches = [Match]()
        let matches = self.matchesFromAPI(results: results)
        
        if internationalOnly {
            for match in matches {
                if (match.status == .completed && match.isInternational) {
                    completedMatches.append(match)
                } else if (match.status == .upcoming && match.isInternational) {
                    upcomingMatches.append(match)
                } else if ((match.status == .live) && match.isInternational) {
                    liveMatches.append(match)
                }
                
            }
        } else {
            for match in matches {
                switch match.status {
                case .completed :
                    completedMatches.append(match)
                case .live:
                    liveMatches.append(match)
                case .upcoming:
                    upcomingMatches.append(match)
                default:
                    break
                }
            }
        }
        

        return (self.sortMatches(matches: liveMatches), self.sortMatches(matches: completedMatches), self.sortMatches(matches: upcomingMatches))
    }
    
    static func sortMatches(matches: [Match]) -> [Match] {
        return matches.sorted { (item1, item2) -> Bool in
            if item1.startDateTimeUTCDateFormat.compare(item2.startDateTimeUTCDateFormat as Date) == ComparisonResult.orderedDescending {
                return true || item1.isInternational && !item2.isInternational
            } else {
                return false || item1.isInternational && !item2.isInternational
            }
        }
    }

    
    static func matchesFromAPI(results: [AnyObject]) -> [Match] {
        var matches = [Match]()
        
        
        if results.count > 0 {
            
            for result in results {
                
                if let matchId = result["id"] as? NSNumber, let matchTypeId = result["matchTypeId"] as? NSNumber, let series = result["series"] as? NSDictionary, let seriesId = series["id"] as? NSNumber, let seriesName = series["name"] as? String, let seriesSName = series["shortName"] as? String, let statusString = result["status"] as? String, let matchName = result["name"] as? String {
                    var newMatch = Match(matchId: matchId, seriesId: seriesId, status: MatchStatus.none)
                    
                    switch statusString {
                    case "COMPLETED" :
                        newMatch.status = .completed
                    case "INPROGRESS":
                        newMatch.status = .live
                    case "LIVE":
                        newMatch.status = .live
                    case "UPCOMING":
                        newMatch.status = .upcoming
                    default:
                        break
                    }
                    
                    newMatch.matchName = matchName
                    newMatch.matchTypeId = matchTypeId
                    newMatch.seriesName = seriesName
                    newMatch.seriesSName = seriesSName
                    
                    
                    //Series Shield URL
                    if let seriesshieldImageUrl = series["shieldImageUrl"] as? String {
                        newMatch.seriesshieldImageUrl = URL(string: seriesshieldImageUrl)
                    }
                    
                    //Venue
                    if let venue = result["venue"] as? NSDictionary {
                        if let venueName = venue["name"] as? String, let venueSName = venue["location"] as? String {
                            newMatch.venueName = venueName
                            newMatch.venueSName = venueSName
                        } else if let venueSName = venue["shortName"] as? String {
                            newMatch.venueSName = venueSName
                        } else {
                            newMatch.venueSName = newMatch.venueName
                        }
                    }
                    
                    //Match Type
                    
                    if let cmsMatchType = result["cmsMatchType"] as? String {
                        newMatch.cmsMatchType = cmsMatchType
                        if let cmsMatchAssociatedType = result["cmsMatchAssociatedType"] as? String {
                            newMatch.cmsMatchAssociatedType = cmsMatchAssociatedType
                            if newMatch.cmsMatchType == "Ireland" && newMatch.cmsMatchAssociatedType == "ODI" {
                                newMatch.cmsMatchType = "One-Day International"
                            }
                        }
                        if cmsMatchType == "One-Day International" || cmsMatchType == "T20 International" || cmsMatchType == "Test" {
                            newMatch.isInternational = true
                        }
                        
                    }  else {
                        continue
                    }

                    
                    //Home team
                    
                    if let homeTeam = result["homeTeam"] as? NSDictionary {
                        if let hometeamId = homeTeam["id"] as? NSNumber, let hometeamName = homeTeam["name"] as? String, let isBatting = homeTeam["isBatting"] as? Bool {
                            newMatch.hometeamId = hometeamId
                            newMatch.hometeamIsBatting = isBatting
                            
                            if let hometeamSName = homeTeam["shortName"] as? String, let hometeamLogoURL = homeTeam["logoUrl"] as? String, let hometeamColor = homeTeam["teamColour"] as? String {
                                newMatch.hometeamSName = hometeamSName
                                newMatch.hometeamColor = hometeamColor
                                newMatch.hometeamLogoURL = URL(string: hometeamLogoURL)
                            } else {
                                newMatch.hometeamSName = newMatch.hometeamName
                            }
                            
                            if hometeamName.hasSuffix("Men") {
                                newMatch.hometeamName = hometeamName.components(separatedBy: "Men")[0].trimmingCharacters(in: NSCharacterSet.whitespaces).uppercased()
                            } else if hometeamName.hasSuffix("WBBL") {
                                newMatch.hometeamName = hometeamName.replacingOccurrences(of: "WBBL", with: "Women").uppercased()
                            } else {
                                newMatch.hometeamName = hometeamName.uppercased()
                            }
                        }
                    }
                    
                    
                    //Away team
                    
                    if let awayTeam = result["awayTeam"] as? NSDictionary {
                        if let awayTeamId = awayTeam["id"] as? NSNumber, let awayTeamName = awayTeam["name"] as? String, let isBatting = awayTeam["isBatting"] as? Bool {
                            newMatch.awayteamId = awayTeamId
                            newMatch.awayteamIsBatting = isBatting
                            
                            if let awayTeamSName = awayTeam["shortName"] as? String, let awayTeamLogoURL = awayTeam["logoUrl"] as? String, let awayTeamColor = awayTeam["teamColour"] as? String {
                                newMatch.awayteamSName = awayTeamSName
                                newMatch.awayteamColor = awayTeamColor
                                newMatch.awayteamLogoURL = URL(string: awayTeamLogoURL)
                            } else {
                                newMatch.awayteamSName = newMatch.awayteamName
                            }
                            
                            if awayTeamName.hasSuffix("Men") {
                                newMatch.awayteamName = awayTeamName.components(separatedBy: "Men")[0].trimmingCharacters(in: NSCharacterSet.whitespaces).uppercased()
                            } else if awayTeamName.hasSuffix("WBBL") {
                                newMatch.awayteamName = awayTeamName.replacingOccurrences(of: "WBBL", with: "Women").uppercased()
                            } else {
                                newMatch.awayteamName = awayTeamName.uppercased()
                            }
                        }
                    }
                    
                    if let currentMatchState = result["currentMatchState"] as? String {
                        newMatch.currentMatchState = currentMatchState
                    }
                    
                    if let isMultiDay = result["isMultiDay"] as? Bool {
                        newMatch.isMultiDay = isMultiDay
                    }
                    
                    if let matchSummaryText = result["matchSummaryText"] as? String {
                        newMatch.matchSummaryText = matchSummaryText
                    }
                    
                    if let isMatchDrawn = result["isMatchDrawn"] as? Bool {
                        newMatch.isMatchDrawn = isMatchDrawn
                    }
                    
                    if let isMatchAbandoned = result["isMatchAbandoned"] as? Bool {
                        newMatch.isMatchAbandoned = isMatchAbandoned
                    }
                    
                    if let winningTeamId = result["winningTeamId"] as? NSNumber {
                        newMatch.winningTeamId = winningTeamId
                    }
                    
                    if let isWomensMatch = result["isWomensMatch"] as? Bool {
                        newMatch.isWomensMatch = isWomensMatch
                    }
                    
                    //score
                    
                    if let scores = result["scores"] as? NSDictionary {
                        newMatch.scores = scores
                        newMatch.miniscoreexists = true
                        if let homeScore = scores["homeScore"] as? String, let homeOvers = scores["homeOvers"] as? String {
                            newMatch.homeScore = homeScore
                            newMatch.homeOvers = homeOvers
                        }
                        
                        if let awayScore = scores["awayScore"] as? String, let awayOvers = scores["awayOvers"] as? String {
                            newMatch.awayScore = awayScore
                            newMatch.awayOvers = awayOvers
                        }
                        
                    }
                    
                    //start time
                    if let startTime = result["startDateTime"] as? String {
                        let startTimeArray = startTime.components(separatedBy: CharacterSet(charactersIn: "TZ"))
                        let startT = startTimeArray[0] + " " + startTimeArray[1]
                        let inFormat = DateFormatter()
                        inFormat.timeZone = TimeZone(abbreviation: "UTC")
                        inFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        
                        let startUTC = inFormat.date(from: startT)
                        
                        
                        
                        newMatch.startDateTimeUTCDateFormat = startUTC!
                        newMatch.startDateTimeUTC = startT
                        
                        let timzoneSeconds = NSTimeZone.local.secondsFromGMT()
                        
                        newMatch.startDateTimeLocalDateFormat = newMatch.startDateTimeUTCDateFormat.addingTimeInterval(Double(timzoneSeconds))
                        
                        
                        
                        newMatch.endDateTime  = result["endDateTime"] as! String
                        
                        
                        
                        let outFormat = DateFormatter()
                        outFormat.timeZone = TimeZone.autoupdatingCurrent
                        outFormat.dateFormat = "MMMM d, yyyy, hh:mm aaa"
                        newMatch.startDateTimeLocal = outFormat.string(from: startUTC!)
                        
                        
                        
                        let diffDateComponents = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second], from: Date() , to: newMatch.startDateTimeUTCDateFormat, options: NSCalendar.Options.init(rawValue: 0))
                        
                        let currentDateComponents = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second], from: Date() )
                        let matchStartDateComponents = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second], from: newMatch.startDateTimeUTCDateFormat)
                        
                        
                        
                        if diffDateComponents.year == 0 && diffDateComponents.month == 0 {
                            if diffDateComponents.day == 0 {
                                if currentDateComponents.day == matchStartDateComponents.day {
                                    if diffDateComponents.hour == 0 && diffDateComponents.minute! >= 0 {
                                        newMatch.hasRelDate = true
                                        newMatch.relStartDate = "Starts in \(diffDateComponents.minute) Minutes"
                                    } else {
                                        newMatch.hasRelDate = true
                                        outFormat.dateFormat = "hh:mm aaa"
                                        newMatch.relStartDate = "STARTS Today, \(outFormat.string(from: startUTC!))"
                                    }
                                } else if currentDateComponents.day! + 1 == matchStartDateComponents.day! {
                                    newMatch.hasRelDate = true
                                    outFormat.dateFormat = "MMM d hh:mm aaa"
                                    newMatch.relStartDate = "STARTS Tomorrow, \(outFormat.string(from: startUTC!))"
                                } else if currentDateComponents.day! - 1 == matchStartDateComponents.day! {
                                    newMatch.hasRelDate = true
                                    outFormat.dateFormat = "MMM d hh:mm aaa"
                                    newMatch.relStartDate = "STARTed YESterday, \(outFormat.string(from: startUTC!))"
                                }
                            } else if diffDateComponents.day == 1 {
                                if currentDateComponents.day! + 1 == matchStartDateComponents.day! {
                                    newMatch.hasRelDate = true
                                    outFormat.dateFormat = "MMM d hh:mm aaa"
                                    newMatch.relStartDate = "STARTS Tomorrow, \(outFormat.string(from: startUTC!))"
                                } else if currentDateComponents.day! + 1 == matchStartDateComponents.day! {
                                    newMatch.hasRelDate = true
                                    outFormat.dateFormat = "MMM d hh:mm aaa"
                                    newMatch.relStartDate = "STARTed YESterday, \(outFormat.string(from: startUTC!))"
                                }
                                
                            } else if newMatch.isMultiDay && diffDateComponents.day! >=  -10 {
                                newMatch.hasRelDate = true
                                outFormat.dateFormat = "MMM d hh:mm aaa"
                                newMatch.relStartDate = "\(outFormat.string(from: startUTC!))"
                            }
                        }
                    }
                    
                    //Local -- not used
                    if let localStartDate  = result["localStartDate"] as? String, let localStartTime  = result["localStartTime"] as? String{
                        newMatch.localStartDate = localStartDate
                        newMatch.localStartTime = localStartTime
                    }
                    
                    
                    matches.append(newMatch)
                }
            }
        }
        return matches
    }
}

func calculateRunRate(_ hscore: String, hovers: String) -> (String, String, Float) {
    
    var hrunrate: Float = 0.0
    var hruns = "0"
    var hwickets = "0"
    
    var hs1: [String]
    var hscorearray = [String]()
    
    hs1 = hscore.components(separatedBy: " ")
    
    
    
    if hs1.count >= 1 {
        hscorearray = hs1[0].components(separatedBy: "/")
       
        hruns = hscorearray[1]
        hwickets = hscorearray[0]
    }
    
    
    
    let hoversarray = hovers.components(separatedBy: ".")
    
    
    
    if hovers == "0.0" || hovers == "0" {
        hrunrate = 0.0
    } else {
        if hoversarray.count > 1 {
            hrunrate = Float(hruns)! * 6 / ((Float(hoversarray[0])! * 6) + Float(hoversarray[1])!)
        } else {
            hrunrate = Float(hruns)! * 6 / (Float(hoversarray[0])! * 6)
        }
        
        return (hruns, hwickets, roundf(100*hrunrate)/100)
    }
    return (hruns, hwickets, hrunrate)
}


func stringFromQueryParameters(_ queryParameters : Dictionary<String, String>) -> String {
    var parts: [String] = []
    for (name, value) in queryParameters {
        let part = NSString(format: "%@=%@",
            name.addingPercentEscapes(using: String.Encoding.utf8)!, value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        )
        parts.append(part as String)
    }
    return parts.joined(separator: "&")
}

/**
 Creates a new URL by adding the given query parameters.
 @param URL The input URL.
 @param queryParameters The query parameter dictionary to add.
 @return A new NSURL.
 */
func NSURLByAppendingQueryParameters(_ URL : Foundation.URL!, queryParameters : Dictionary<String, String>) -> Foundation.URL {
    let URLString : NSString = NSString(format: "%@?%@", URL.absoluteString, stringFromQueryParameters(queryParameters))
    return Foundation.URL(string: URLString as String)!
}
