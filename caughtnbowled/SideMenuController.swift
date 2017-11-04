//
//  SideMenuController.swift
//  Bowled
//
//  Created by Ezra Bathini on 16/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material
import Firebase
import FirebaseDatabase

protocol MenuControllerDelegate {
    func menuItemSelected(item: String, type: MenuItemType)
    func updateFavoriteTeam()
}

struct MatchType {
    let name: String
    let isInternational: Bool
    
    init(name: String, isInternational: Bool) {
        self.name = name
        self.isInternational = isInternational
    }
}

class SideMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var mainMenu: HMSegmentedControl!
    
    @IBOutlet weak var headerView: View!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var intOnlyLabel: UILabel!

    @IBOutlet weak var intOnlyView: View!
    
    var intOnlySwitch: Switch!
    
    var delegate: MenuControllerDelegate?
    
    var matchTypes = [MatchType]()
    var matches = [Match]()
    var teamsList = [String]()
    var seriesList = [String]()
    var matchTypeList = [String]()
    
    var isFullmenu = true // as opposed to false when selecting favorite team
    
    var teamTypes = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = mainColor
        
        teamTypes = Array(Set(teams.map { $0.teamType }.flatMap { $0 })).sorted(by: { (a, b) -> Bool in
            return (a == "INTERNATIONAL")
        })
        
        let menuTitles = isFullmenu ? ["TEAMS", "SERIES'", "MATCH TYPES"] : teamTypes //Array(Set(teams.map { $0.teamType }.flatMap { $0 }))
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
       
        mainMenu.titleTextAttributes = [NSAttributedStringKey.foregroundColor: txtColor, NSAttributedStringKey.font: RobotoFont.regular]
        mainMenu.selectedTitleTextAttributes = [NSAttributedStringKey.foregroundColor: txtColor, NSAttributedStringKey.font: RobotoFont.regular]
        mainMenu.selectedSegmentIndex = 0
        
        headerView.backgroundColor = mainColor

        headerView.addSubview(mainMenu)
        
        
        intOnlyView.alpha = isFullmenu ? 1 : 0
        intOnlyLabel.text = isFullmenu ? "Show International Matches Only?" : "Select Favorite Team"
        
        intOnlyLabel.textColor = txtColor
        intOnlyLabel.font = RobotoFont.medium
        
        intOnlySwitch = Switch(state: .off, style: .dark, size: .medium)
        
        if let showInternationalOnly = defaults?.bool(forKey: "showInternationalOnly") {
            intOnlySwitch.setOn(on: showInternationalOnly, animated: false)
        }
        
        
        intOnlySwitch.buttonOnColor = mainColor
        
        intOnlySwitch.addTarget(self, action: #selector(switchStateChanged), for: .valueChanged)
        
        intOnlyView.layout.center(intOnlySwitch)
        
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = Color.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        if isFullmenu {
            getMatchTypes()
            prepareTableViewData()
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func prepareTableViewData() {
        
        
        //teamsList = Array(Set([matches.map{ $0.hometeamName }, matches.map{ $0.awayteamName }].flatMap { $0 }))
        // fixed teams
        teamsList.removeAll()
        for type in teamTypes {
            if intOnlySwitch.on {
                teamsList = [teamsList, teams.filter { $0.teamType == type && $0.isInternational == true }.map { $0.name }].flatMap { $0 }
            } else {
                teamsList = [teamsList, teams.filter { $0.teamType == type }.map { $0.name }].flatMap { $0 }
            }
            
        }
        
        //Series
        if intOnlySwitch.on {
            seriesList = Array(Set(matches.filter { $0.isInternational == true }.map{ $0.seriesName }))
        } else {
            seriesList = Array(Set(matches.map{ $0.seriesName }))
        }
        
        
        //match types
        matchTypeList.removeAll()
    
        if intOnlySwitch.on {
            matchTypeList = matchTypes.filter { $0.isInternational == true }.map{$0.name}.flatMap { $0 }
        } else {
            matchTypeList = matchTypes.map{$0.name}.flatMap { $0 }
        }
        
        if matchTypeList.count == 0 {
            matchTypeList = intOnlySwitch.on ? [ "Test", "One-Day International", "T20 International"] : [ "Test", "One-Day International", "T20 International", "BBL","WBBL","First-Class"]
        }
        
        tableView.reloadData()
    }
    
    func getMatchTypes() {
        let ref = Database.database().reference()
        
        ref.child("matchTypes").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if let types = value?.allValues as? [[String: AnyObject]] {
                for type in types {
                    self.matchTypes.append(MatchType(name: type["name"] as! String, isInternational: type["isInternational"] as! Bool))
                }
                self.prepareTableViewData()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    @objc func mainMenuChangedValue(_ mainMenu: HMSegmentedControl) {
        tableView.reloadData()
    }
    
    @objc func switchStateChanged() {
        
        defaults?.set(intOnlySwitch.on, forKey: "showInternationalOnly")
        
        prepareTableViewData()
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
            return teams.filter({ $0.teamType == teamTypes[mainMenu.selectedSegmentIndex]}).count
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
            
            let favTeam = teams.filter({ $0.teamType == teamTypes[mainMenu.selectedSegmentIndex]})[indexPath.row].name
            menuCell.menuItem = favTeam
            if let defaultsFavTeam = defaults?.value(forKey: "favoriteTeamName") as? String {
                if favTeam == defaultsFavTeam {
                    menuCell.menuLabel.font = RobotoFont.bold
                }
            }
            
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
            defaults?.set(teams.filter({ $0.teamType == teamTypes[mainMenu.selectedSegmentIndex]})[indexPath.row].name.uppercased(), forKey: "favoriteTeamName")
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
}
