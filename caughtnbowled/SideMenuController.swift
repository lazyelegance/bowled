//
//  SideMenuController.swift
//  Bowled
//
//  Created by Ezra Bathini on 16/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material

protocol MenuControllerDelegate {
    func menuItemSelected(item: String, type: MenuItemType)
}

class SideMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var mainMenu: HMSegmentedControl!
    
    @IBOutlet weak var headerView: View!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var intOnlyLabel: UILabel!

    @IBOutlet weak var intOnlyView: View!
    
    var delegate: MenuControllerDelegate?
    
    var matches = [Match]()
    var teamsList = [String]()
    var seriesList = [String]()
    var matchTypeList = [String]()
    
    var isFullmenu = true // as opposed to false when selecting favorite team
    
    //temp
    
    
   
    var teams = [Team(name: "ADELAIDE STRIKERS", shortName: "STR", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/BBL/Adelaide-Strikers.ashx", teamColor: "#00b0de", isInternational: false, isWomensTeam :false, teamType: "BBL"),
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
    Team(name: "SYDNEY THUNDER WOMEN", shortName: "THU", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/BBL/Sydney-Thunder.ashx", teamColor: "#9fc000", isInternational: false, isWomensTeam :true, teamType: "WBBL"),
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
    Team(name: "ZIMBABWE WOMEN", shortName: "ZIM", logoString: "http://www.cricket.com.au/-/media/Logos/Teams/International/Zimbabwe.ashx", teamColor: "#00503c", isInternational: true, isWomensTeam :true, teamType: "INTERNATIONAL WOMEN")]
    
    
    var teamNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = mainColor
        
        teamNames = Array(Set(teams.map { $0.teamType }.flatMap { $0 })).sorted(by: { (a, b) -> Bool in
            return (a == "INTERNATIONAL")
        })
        // Do any additional setup after loading the view.
        
        let menuTitles = isFullmenu ? ["TEAMS", "SERIES'", "MATCH TYPES", "SETTINGS"] : teamNames //Array(Set(teams.map { $0.teamType }.flatMap { $0 }))
        mainMenu = HMSegmentedControl(sectionTitles: menuTitles)
        
        mainMenu.addTarget(self, action: #selector(SideMenuController.mainMenuChangedValue(_:)), for: UIControlEvents.valueChanged)
        mainMenu.frame = CGRect(x: 10, y: 0, width: headerView.frame.width - 20, height: 30)
        mainMenu.autoresizingMask =  UIViewAutoresizing()
        
        mainMenu.selectionIndicatorColor = txtColor
        mainMenu.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic
        mainMenu.layer.cornerRadius = 2
        
        
        mainMenu.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe
        mainMenu.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        
        mainMenu.backgroundColor = mainColor
       
        mainMenu.titleTextAttributes = [NSForegroundColorAttributeName: txtColor, NSFontAttributeName: RobotoFont.regular]
        mainMenu.selectedTitleTextAttributes = [NSForegroundColorAttributeName: txtColor, NSFontAttributeName: RobotoFont.regular]
        mainMenu.selectedSegmentIndex = 0
        
        headerView.backgroundColor = mainColor

        headerView.addSubview(mainMenu)
        
        
        intOnlyLabel.text = "Show International Matches Only?"
        intOnlyLabel.textColor = mainColor
        intOnlyLabel.font = RobotoFont.medium
        
        let intOnlySwitch = Switch(state: .on, style: .dark, size: .medium)
        intOnlySwitch.buttonOnColor = mainColor
        
        intOnlyView.layout.center(intOnlySwitch)
        
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = Color.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        if isFullmenu { prepareTableViewData() }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func prepareTableViewData() {
        
        
        teamsList = Array(Set([matches.map{ $0.hometeamName }, matches.map{ $0.awayteamName }].flatMap { $0 }))
        
        seriesList = Array(Set(matches.map{ $0.seriesName }))
        
        matchTypeList = Array(Set(matches.map{ $0.cmsMatchType }))
        
        tableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func mainMenuChangedValue(_ mainMenu: HMSegmentedControl) {
        
//        if let selectedMenuTypeIndex = menuTypes[mainMenu.selectedSegmentIndex].to_Index() as? Int {
//            defaults?.set(selectedMenuTypeIndex, forKey: "selectedMenuTypeIndex")
//        }
        
        
        tableView.reloadData()
    }
    
 

    
    // MARK: - tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFullmenu {
            switch mainMenu.selectedSegmentIndex {
            case 0:
                return teamsList.count
            case 1:
                return seriesList.count
            case 2:
                return matchTypeList.count
            default:
                return 0
            }
        } else {
            return teams.filter({ $0.teamType == teamNames[mainMenu.selectedSegmentIndex]}).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let menuCell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuCell
        
        if isFullmenu {
            switch mainMenu.selectedSegmentIndex {
            case 0:
                menuCell.menuItem = teamsList[indexPath.row]
            case 1:
                menuCell.menuItem = seriesList[indexPath.row]
            case 2:
                menuCell.menuItem = matchTypeList[indexPath.row]
            default:
                break
            }
        } else {
            menuCell.menuItem = teams.filter({ $0.teamType == teamNames[mainMenu.selectedSegmentIndex]})[indexPath.row].name
        }
        
        return menuCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFullmenu {
            switch mainMenu.selectedSegmentIndex {
            case 0:
                delegate?.menuItemSelected(item: teamsList[indexPath.row], type: .team)
            case 1:
                delegate?.menuItemSelected(item: seriesList[indexPath.row], type: .series)
            case 2:
                delegate?.menuItemSelected(item: matchTypeList[indexPath.row], type: .matchType)
            default:
                break
            }
        } else {
            
            
            defaults?.set(teams.filter({ $0.teamType == teamNames[mainMenu.selectedSegmentIndex]})[indexPath.row].name.uppercased(), forKey: "favoriteTeamName")
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
}
