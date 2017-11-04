//
//  ColorsAndConstants.swift
//  caughtnbowled
//
//  Created by Ezra Bathini on 22/10/15.
//  Copyright © 2015 Ezra Bathini. All rights reserved.
//

import Foundation


import UIKit
import Material

// MARK: - Constants

let kMatchListHeaderHeight: CGFloat = 90
var kTableHeaderHeight: CGFloat = 80
var kHeaderSubviewHeight: CGFloat = 280
let kCenterPanelExpandedOffset = 60

let defaults = UserDefaults(suiteName: "group.com.ezrabathini.bowled")

let keysDictionary = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "keys", ofType: "plist")!)
let resoursesURLString = keysDictionary?.object(forKey: "resoursesURLString") as! String
var resoursesURL = URL(string: resoursesURLString)

// MARK: - Colors

let clearcolor = Color.clear
let whitecolor = Color.white
let mainColor = UIColor.white
// UIColor(red: 68.0/255.0, green: 108.0/255.0, blue: 179.0/255.0, alpha: 1.0) //UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0) //Color.indigo.base
let secondaryColor = Color.white //UIColor(red: 52.0/255.0, green: 73.0/255.0, blue: 94.0/255.0, alpha: 1.0)//rgba(52, 73, 94,1.0)// Color.darkGray
let txtColor = UIColor(red: 68.0/255.0, green: 108.0/255.0, blue: 179.0/255.0, alpha: 1.0)

// MARK: - Swift Loader

var swiftLoaderConfig : SwiftLoader.Config = SwiftLoader.Config()


extension UserDefaults {
    
    func colorForKey(_ key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
    
    func setColor(_ color: UIColor?, forKey key: String) {
        var colorData: Data?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color)
        }
        set(colorData, forKey: key)
    }
    

    
}

extension UIColor {
    
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.characters.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

/**
 The html replacement regular expression
 */
let     htmlReplaceString   :   String  =   "<[^>]+>"

extension NSString {
    /**
     Takes the current NSString object and strips out HTML using regular expression. All tags get stripped out.
     
     :returns: NSString html text as plain text
     */
    func stripHTML() -> NSString {
        return self.replacingOccurrences(of: htmlReplaceString, with: "", options: NSString.CompareOptions.regularExpression, range: NSRange(location: 0,length: self.length)) as NSString
    }
}



public enum MenuItemType {
    
    
    case team
    case series
    case matchType
    case settings
    case favoriteTeam
    case all
    
    func to_String() -> String {
        switch self {
        case .all:
            return "ALL"
        case .team:
            return "TEAMS"
        case .series:
            return "SERIES"
        case .matchType:
            return "MATCH TYPE"
        case .settings:
            return "SETTINGS"
        case .favoriteTeam:
            return "FAVORITE TEAM"
        }
    }
    
    func to_Index() -> Int {
        switch self {
            
        case .team:
            return 0
        case .series:
            return 1
        case .matchType:
            return 2
        case .settings:
            return 3
        case .all:
            return 4
        case .favoriteTeam:
            return 5
        }
    }
}

//public struct MenuItem {
//    var id: NSNumber?
//    var name: String?
//    var logoUrl: URL?
//    var type: MenuType
//    var isInternational: Bool?
//    
//    init(id: NSNumber, name: String, type: MenuType, logoUrl: URL, isInternational: Bool) {
//        self.id = id
//        self.name = name
//        self.type = type
//        self.logoUrl = logoUrl
//        self.isInternational = isInternational
//    }
//    
//
//}

public enum MatchStatus {
    case live
    case completed
    case upcoming
    case dummy_series
    case dummy_completed
    case dummy_upcoming
    case dummy_selected
    case none
    
    func loadMoreString() -> String {
        switch self {
        case .dummy_completed:
            return "more completed".uppercased()
        case .dummy_upcoming:
            return "more upcoming".uppercased()
        case .dummy_series:
            return "Series Standings".uppercased()
        case .dummy_selected:
            return "show all".uppercased()
        default:
            return "load more".uppercased()
        }
    }
    
}




var teams = [
             Team(name: "AUSTRALIA", shortName: "AUS", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/Australia.ashx", teamColor: "#00503c", isInternational: true, isWomensTeam :false, teamType: "INTERNATIONAL"),
             Team(name: "BANGLADESH", shortName: "BAN", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/Bangladesh.ashx", teamColor: "#00794f", isInternational: true, isWomensTeam :false, teamType: "INTERNATIONAL"),
             Team(name: "ENGLAND", shortName: "ENG", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/England.ashx", teamColor: "#dc210a", isInternational: true, isWomensTeam :false, teamType: "INTERNATIONAL"),
             Team(name: "INDIA", shortName: "IND", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/India.ashx", teamColor: "#0099cc", isInternational: true, isWomensTeam :false, teamType: "INTERNATIONAL"),
             Team(name: "IRELAND", shortName: "IRE", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/Ireland.ashx", teamColor: "#00503c", isInternational: true, isWomensTeam :false, teamType: "INTERNATIONAL"),
             Team(name: "NEW ZEALAND", shortName: "NZ", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/New-Zealand.ashx", teamColor: "#363636", isInternational: true, isWomensTeam :false, teamType: "INTERNATIONAL"),
             Team(name: "PAKISTAN", shortName: "PAK", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/Pakistan.ashx", teamColor: "#084118", isInternational: true, isWomensTeam :false, teamType: "INTERNATIONAL"),
             Team(name: "SOUTH AFRICA", shortName: "SA", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/South-Africa.ashx", teamColor: "#007a4d", isInternational: true, isWomensTeam :false, teamType: "INTERNATIONAL"),
             Team(name: "SRI LANKA", shortName: "SL", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/Sri-Lanka.ashx", teamColor: "#403fa8", isInternational: true, isWomensTeam :false, teamType: "INTERNATIONAL"),
             Team(name: "WEST INDIES", shortName: "WI", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/West-Indies.ashx", teamColor: "#00503c", isInternational: true, isWomensTeam :false, teamType: "INTERNATIONAL"),
             Team(name: "ZIMBABWE", shortName: "ZIM", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/Zimbabwe.ashx", teamColor: "#00503c", isInternational: true, isWomensTeam :false, teamType: "INTERNATIONAL"),
             Team(name: "AUSTRALIA WOMEN", shortName: "AUS", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/Australia.ashx", teamColor: "#c8a000", isInternational: true, isWomensTeam :true, teamType: "INTERNATIONAL WOMEN"),
             Team(name: "BANGLADESH WOMEN", shortName: "BAN", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/Bangladesh.ashx", teamColor: "#00794f", isInternational: true, isWomensTeam :true, teamType: "INTERNATIONAL WOMEN"),
             Team(name: "ENGLAND WOMEN", shortName: "ENG", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/England.ashx", teamColor: "#dc210a", isInternational: true, isWomensTeam :true, teamType: "INTERNATIONAL WOMEN"),
             Team(name: "INDIA WOMEN", shortName: "IND", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/India.ashx", teamColor: "#0099cc", isInternational: true, isWomensTeam :true, teamType: "INTERNATIONAL WOMEN"),
             Team(name: "IRELAND WOMEN", shortName: "IRE", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/Ireland.ashx", teamColor: "#dc210a", isInternational: true, isWomensTeam :true, teamType: "INTERNATIONAL WOMEN"),
             Team(name: "NEW ZEALAND WOMEN", shortName: "NZ", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/New-Zealand.ashx", teamColor: "#363636", isInternational: true, isWomensTeam :true, teamType: "INTERNATIONAL WOMEN"),
             Team(name: "PAKISTAN WOMEN", shortName: "PAK", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/Pakistan.ashx", teamColor: "#084118", isInternational: true, isWomensTeam :true, teamType: "INTERNATIONAL WOMEN"),
             Team(name: "SOUTH AFRICA WOMEN", shortName: "SA", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/South-Africa.ashx", teamColor: "#007a4d", isInternational: true, isWomensTeam :true, teamType: "INTERNATIONAL WOMEN"),
             Team(name: "SRI LANKA WOMEN", shortName: "SL", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/Sri-Lanka.ashx", teamColor: "#403fa8", isInternational: true, isWomensTeam :true, teamType: "INTERNATIONAL WOMEN"),
             Team(name: "WEST INDIES WOMEN", shortName: "WI", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/West-Indies.ashx", teamColor: "#00794f", isInternational: true, isWomensTeam :true, teamType: "INTERNATIONAL WOMEN"),
             Team(name: "ZIMBABWE WOMEN", shortName: "ZIM", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/Zimbabwe.ashx", teamColor: "#00503c", isInternational: true, isWomensTeam :true, teamType: "INTERNATIONAL WOMEN"),
             Team(name: "DELHI DAREDEVILS", shortName: "DEL", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/Other/Team-Delhi-Daredevils.ashx", teamColor: "#da2625", isInternational: false, isWomensTeam :false, teamType: "INDIAN PREMIER LEAGUE"),
             Team(name: "GUJARAT LIONS", shortName: "GUJ", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/Other/team-gujarat.ashx", teamColor: "#ffa500", isInternational: false, isWomensTeam :false, teamType: "INDIAN PREMIER LEAGUE"),
             Team(name: "KINGS XI PUNJAB", shortName: "KXI", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/Other/Team-Kings-XI-Punjab.ashx", teamColor: "#d10000", isInternational: false, isWomensTeam :false, teamType: "INDIAN PREMIER LEAGUE"),
             Team(name: "KOLKATA KNIGHT RIDERS", shortName: "KKR", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/Other/Team-Kolkata-Knight-Riders.ashx", teamColor: "#481363", isInternational: false, isWomensTeam :false, teamType: "INDIAN PREMIER LEAGUE"),
             Team(name: "MUMBAI INDIANS", shortName: "MI", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/Other/Team-Mumbai-Indians.ashx", teamColor: "#b7900f", isInternational: false, isWomensTeam :false, teamType: "INDIAN PREMIER LEAGUE"),
             Team(name: "RISING PUNE SUPERGIANTS", shortName: "RPS", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/Other/team-pune.ashx", teamColor: "#df01d7", isInternational: false, isWomensTeam :false, teamType: "INDIAN PREMIER LEAGUE"),
             Team(name: "ROYAL CHALLENGERS BANGALORE", shortName: "RCB", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/Other/Team-Royal-Challengers-Bangalore.ashx", teamColor: "#ae181d", isInternational: false, isWomensTeam :false, teamType: "INDIAN PREMIER LEAGUE"),
             Team(name: "SUNRISERS HYDERABAD", shortName: "SUN", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/Other/Team-Sunrisers-Hyderabad.ashx", teamColor: "#ff8a4a", isInternational: false, isWomensTeam :false, teamType: "INDIAN PREMIER LEAGUE")]
/*
 Team(name: "ADELAIDE STRIKERS", shortName: "STR", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/BBL/Adelaide-Strikers.ashx", teamColor: "#00b0de", isInternational: false, isWomensTeam :false, teamType: "BBL"),
 Team(name: "BRISBANE HEAT", shortName: "HEA", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/BBL/Brisbane-Heat.ashx", teamColor: "#00b3bc", isInternational: false, isWomensTeam :false, teamType: "BBL"),
 Team(name: "HOBART HURRICANES", shortName: "HUR", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/BBL/Hobart-Hurricanes.ashx", teamColor: "#773cb0", isInternational: false, isWomensTeam :false, teamType: "BBL"),
 Team(name: "MELBOURNE RENEGADES", shortName: "REN", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/BBL/Melbourne-Renegades.ashx", teamColor: "#df0048", isInternational: false, isWomensTeam :false, teamType: "BBL"),
 Team(name: "MELBOURNE STARS", shortName: "STA", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/BBL/Melbourne-Stars.ashx", teamColor: "#339e00", isInternational: false, isWomensTeam :false, teamType: "BBL"),
 Team(name: "PERTH SCORCHERS", shortName: "SCO", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/BBL/Perth-Scorchers.ashx", teamColor: "#f58400", isInternational: false, isWomensTeam :false, teamType: "BBL"),
 Team(name: "SYDNEY SIXERS", shortName: "SIX", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/BBL/Sydney-Sixers.ashx", teamColor: "#dd1b9d", isInternational: false, isWomensTeam :false, teamType: "BBL"),
 Team(name: "SYDNEY THUNDER", shortName: "THU", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/BBL/Sydney-Thunder.ashx", teamColor: "#9fc000", isInternational: false, isWomensTeam :false, teamType: "BBL"),
 Team(name: "ADELAIDE STRIKERS WOMEN", shortName: "STR", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/BBL/Adelaide-Strikers.ashx", teamColor: "#00b0de", isInternational: false, isWomensTeam :true, teamType: "WBBL"),
 Team(name: "BRISBANE HEAT WOMEN", shortName: "HEA", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/BBL/Brisbane-Heat.ashx", teamColor: "#00b3bc", isInternational: false, isWomensTeam :true, teamType: "WBBL"),
 Team(name: "HOBART HURRICANES WOMEN", shortName: "HUR", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/BBL/Hobart-Hurricanes.ashx", teamColor: "#773cb0", isInternational: false, isWomensTeam :true, teamType: "WBBL"),
 Team(name: "MELBOURNE RENEGADES WOMEN", shortName: "REN", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/BBL/Melbourne-Renegades.ashx", teamColor: "#df0048", isInternational: false, isWomensTeam :true, teamType: "WBBL"),
 Team(name: "MELBOURNE STARS WOMEN", shortName: "STA", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/BBL/Melbourne-Stars.ashx", teamColor: "#339e00", isInternational: false, isWomensTeam :true, teamType: "WBBL"),
 Team(name: "PERTH SCORCHERS WOMEN", shortName: "SCO", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/BBL/Perth-Scorchers.ashx", teamColor: "#f58400", isInternational: false, isWomensTeam :true, teamType: "WBBL"),
 Team(name: "SYDNEY SIXERS WOMEN", shortName: "SIX", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/BBL/Sydney-Sixers.ashx", teamColor: "#dd1b9d", isInternational: false, isWomensTeam :true, teamType: "WBBL"),
 Team(name: "SYDNEY THUNDER WOMEN", shortName: "THU", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/BBL/Sydney-Thunder.ashx", teamColor: "#9fc000", isInternational: false, isWomensTeam :true, teamType: "WBBL")
*/





