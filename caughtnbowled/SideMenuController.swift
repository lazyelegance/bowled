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
    
    var teamTypes = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = mainColor
        
        teamTypes = Array(Set(teams.map { $0.teamType }.flatMap { $0 })).sorted(by: { (a, b) -> Bool in
            return (a == "INTERNATIONAL")
        })
        
        let menuTitles = isFullmenu ? ["TEAMS", "SERIES'", "MATCH TYPES", "SETTINGS"] : teamTypes //Array(Set(teams.map { $0.teamType }.flatMap { $0 }))
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
        
        
        //teamsList = Array(Set([matches.map{ $0.hometeamName }, matches.map{ $0.awayteamName }].flatMap { $0 }))
        // fixed teams
        for type in teamTypes {
            teamsList = [teamsList, teams.filter { $0.teamType == type }.map { $0.name }].flatMap { $0 }
        }
        
        seriesList = Array(Set(matches.map{ $0.seriesName }))
        
        matchTypeList = [ "Test", "One-Day International", "T20 International", "BBL","WBBL","First-Class"] //Array(Set(matches.map{ $0.cmsMatchType }))
        
    
        let ref = FIRDatabase.database().reference()
        
        print(ref)
        
        ref.child("matchTypes").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if let matchTypes = value?.allValues as? [String] {
                self.matchTypeList = matchTypes
                self.tableView.reloadData()
            }
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
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
            menuCell.menuItem = teams.filter({ $0.teamType == teamTypes[mainMenu.selectedSegmentIndex]})[indexPath.row].name
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
