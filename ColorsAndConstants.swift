//
//  ColorsAndConstants.swift
//  caughtnbowled
//
//  Created by Ezra Bathini on 22/10/15.
//  Copyright © 2015 Ezra Bathini. All rights reserved.
//

import Foundation


import UIKit


let kMatchListHeaderHeight: CGFloat = 90
var kTableHeaderHeight: CGFloat = 80
var kHeaderSubviewHeight: CGFloat = 280

let defaults = UserDefaults(suiteName: "group.com.ezrabathini.bowled")

let keysDictionary = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "keys", ofType: "plist")!)
let resoursesURLString = keysDictionary?.object(forKey: "resoursesURLString") as! String
var resoursesURL = URL(string: resoursesURLString)


let peterrock = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1.0)
let peterrock_2 = UIColor(red: 41.0/255.0, green: 128.0/255.0, blue: 185.0/255.0, alpha: 1.0)

let midnightblue = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0)
let midnightblue_2 = UIColor(red: 52.0/255.0, green: 73.0/255.0, blue: 94.0/255.0, alpha: 1.0)

let pomegranate = UIColor(red: 192.0/255.0, green: 57.0/255.0, blue: 43.0/255.0, alpha: 1.0)
let pomegranate_2 = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)


let belizehole = UIColor(red: 41.0/255.0, green: 128.0/255.0, blue: 185.0/255.0, alpha: 1.0)
let nephritis = UIColor(red: 39.0/255.0, green: 174.0/255.0, blue: 96.0/255.0, alpha: 1.0)

let greensea = UIColor(red: 22.0/255.0, green: 160.0/255.0, blue: 133.0/255.0, alpha: 1.0)
//rgba(22, 160, 133,1.0)
let silver = UIColor(red: 189.0/255.0, green: 195.0/255.0, blue: 199.0/255.0, alpha: 1.0)

var clearcolor = UIColor.clear //
var navBarColor = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1)
var txtColor = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1)
let whitecolor = UIColor.white


let favoriteTeamsList = ["INDIA", "AUSTRALIA", "Sri Lanka"]


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
    
    func secondaryColor() -> UIColor {
        switch self {
        case peterrock:
            return peterrock_2
        case midnightblue:
            return midnightblue_2
        case pomegranate:
            return pomegranate_2
        default:
            return self
        }
    }
    
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

extension String {
    /**
     Takes the current String struct and strips out HTML using regular expression. All tags get stripped out.
     
     :returns: String html text as plain text
     */
    func stripHTML() -> String {
        return self.replacingOccurrences(of: htmlReplaceString, with: "", options: NSString.CompareOptions.regularExpression, range: nil)
    }
}


public enum MenuType {
    
    
    case team
    case series
    case matchType
    case settings
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
        }
    }
    
    func to_Color() -> UIColor {
        switch self {
        case .all:
            return peterrock
        case .team:
            return peterrock
        case .series:
            return midnightblue
        case .matchType:
            return pomegranate
        case .settings:
            return greensea
            
        }
    }
    
}

public struct MenuItem {
    var id: NSNumber?
    var name: String?
    var logoUrl: URL?
    var type: MenuType
    var isInternational: Bool?
    
    init(id: NSNumber, name: String, type: MenuType, logoUrl: URL, isInternational: Bool) {
        self.id = id
        self.name = name
        self.type = type
        self.logoUrl = logoUrl
        self.isInternational = isInternational
    }
    

}

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

public enum AppSetting {
    case showOnlyInternational
    case favoriteTeamSelect
    case showOnlyFavorite
    
    func to_String() -> String {
        switch self {
        case .showOnlyInternational:
            return "Show International Matches Only"
        case .favoriteTeamSelect:
            return "Select Favorite Team"
        case .showOnlyFavorite:
            return "Show Only Selected"
        }
    }
    
    func defaultsKeyString() -> String {
        switch self {
        case .showOnlyInternational:
            return "InternationalMatchesOnly"
        case .favoriteTeamSelect:
            return "FavoriteTeam"
        case .showOnlyFavorite:
            return "ShowFavoriteOnly"
        }
    }
    
    func has_switch() -> Bool {
        switch self {
        case .showOnlyInternational:
            return true
        case .favoriteTeamSelect:
            return false
        case .showOnlyFavorite:
            return true
        }
    }
    
    func selectionList() -> [String] {
        switch self {
        case .favoriteTeamSelect:
            return favoriteTeamsList
        default:
            return [""]
        }
    }
    
}


public enum SideMenuItem {
    case allMatches
    case liveMatches
    case upcoming
    case calender
    case completed
    
    func to_String() -> String {
        switch self {
        case .allMatches:
            return "All Matches"
        case .liveMatches:
            return "Live Matches"
        case .upcoming:
            return "Upcoming Matches"
        case .completed:
            return "Completed Matches"
        case .calender:
            return "Calendar"
        }
    }
    
    
    
}

public enum SideMenuFilterItem {
    case teams
    case series
    
    
    func to_String() -> String {
        switch self {
        case .teams:
            return "TEAMS"
        case .series:
            return "SERIES"
            
        }
    }
    
}



