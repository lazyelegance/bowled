//
//  MainViewController.swift
//  Bowled
//
//  Created by Ezra Bathini on 16/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import BowledService
import Material


protocol MainViewControllerDelegate {
    func toggleLeftPanel(matchList: [Match]?, showFullMenu: Bool)
    //func toggleRightPanel(seriesList: [MenuItem], teamsList: [MenuItem], matchTypesList: [MenuItem])
    func collapseSidePanels()
}

enum MainViewControllerType {
    case main
    case series
    case team
    case fixtures
    case favorite
}


class MainViewController: UIViewController, BowledServiceProtocol, UITableViewDelegate, UITableViewDataSource, MenuControllerDelegate {
    
    var timer = Timer()
    
    
    var bowledServiceAPI: BowledService!
    
    var liveMatches = [Match]()
    var completedMatches = [Match]()
    var upcomingMatches = [Match]()
    var topMatches = [Match]()
    var matchList = [Match]()
    var allMatches = [Match]()
    
    var mainViewControllerType = MainViewControllerType.main
    
    var menuExpanded = false
    var delegate: MainViewControllerDelegate?
    
    
    var selectedSeriesStanding: Series?
    
    var topMatchCellheight = 150
    
    var titleText = ""
    
    @IBOutlet weak var menuButton: FlatButton!
    
    @IBOutlet weak var editButton: FlatButton!
    
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var topMatchesView: View!
    
    @IBOutlet weak var topMatchesTableView: UITableView!
    
    
    @IBOutlet weak var topTableViewHeightConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = mainColor
        topMatchesView.backgroundColor = mainColor

        topMatchesTableView.backgroundColor = mainColor
        topMatchesTableView.estimatedRowHeight = 100
        topMatchesTableView.rowHeight = UITableViewAutomaticDimension

        //get match list
        bowledServiceAPI = BowledService(delegate: self)
        
        if mainViewControllerType == .main {
            swiftLoaderConfig.size = 100
            swiftLoaderConfig.spinnerColor = whitecolor
            swiftLoaderConfig.backgroundColor = clearcolor
            swiftLoaderConfig.titleTextColor = whitecolor
            swiftLoaderConfig.foregroundAlpha = 0
            SwiftLoader.setConfig(swiftLoaderConfig)
            SwiftLoader.show(true)
            getMatchData()
        } else if mainViewControllerType == .fixtures {
            prepareFixtures()
        }
        
        
        //prepare menu
        
        menuButton.image = mainViewControllerType == .main ? UIImage(named: "cm_arrow_downward_white") : UIImage(named: "ic_arrow_back_white")
        
        editButton.alpha = mainViewControllerType == .favorite ? 1 : 0
        
        //prepareTitle
        titleLabel.font = RobotoFont.regular
        titleLabel.textColor = secondaryColor
        titleLabel.text = titleText

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        topMatchesTableView.reloadData()
        
        if mainViewControllerType == .main {
            timer = Timer.scheduledTimer( timeInterval: 120, target: self, selector: #selector(getMatchData), userInfo: nil, repeats: true)
        } else if mainViewControllerType == .favorite {
            updateFavoriteTeam()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        timer.invalidate()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getMatchData() {

        switch Reach().connectionStatus() {
        case .online :
            bowledServiceAPI.getMatches()
        default:
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            swiftLoaderConfig.spinnerColor = whitecolor
            swiftLoaderConfig.backgroundColor = clearcolor
            swiftLoaderConfig.titleTextColor = whitecolor
            swiftLoaderConfig.size = 300
            SwiftLoader.setConfig(swiftLoaderConfig)
            SwiftLoader.show("No Network Connectivity. Please Try Again Later", animated: true)
        }
    }
    
    func prepareView() {
        
        topMatchesTableView.backgroundColor = Color.clear
        
    }
    
    func prepareFixtures() {
        
    }

    // MARK: - Navigation
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let match = matchList[indexPath.row] as Match? {
            if let matchDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "MatchDetailController") as? MatchDetailController {
                matchDetailViewController.match = match
                self.navigationController?.pushViewController(matchDetailViewController, animated: true)
            }
        }
    }
    
    @IBAction func unwindToMainController(_ segue: UIStoryboardSegue) {
    }
    
    
    func showSelectedSeries() {
        showSelectedMatches(selectionTitle: matchList.filter { $0.status == .dummy_series }[0].seriesName, matchList: [liveMatches, completedMatches, upcomingMatches].flatMap { $0 }.filter { $0.seriesId == matchList.filter { $0.status == .dummy_series }[0].seriesId }, selectionType: .series)
    }
    

    
    func showFixtures() {
        showSelectedMatches(selectionTitle: "FIXTURES", matchList: self.upcomingMatches, selectionType: .fixtures)
    }
    
    
    func showSelectedMatches(selectionTitle: String, matchList: [Match], selectionType: MainViewControllerType) {
        if let selectedMatchListVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
            selectedMatchListVC.mainViewControllerType = selectionType
            selectedMatchListVC.matchList = matchList
            selectedMatchListVC.titleText = selectionTitle
            self.navigationController?.pushViewController(selectedMatchListVC, animated: true)
        }
    }
    
    func toSelectFavoriteTeam() {
        
    }

 
    @IBAction func menuButtonAction(_ sender: Any) {
        if mainViewControllerType == .main {
            if !menuExpanded {
                menuButton.image = UIImage(named: "cm_arrow_upward_white")
                menuExpanded = !menuExpanded
                delegate?.toggleLeftPanel(matchList: [liveMatches, completedMatches, upcomingMatches].flatMap { $0 }, showFullMenu: true)
            } else {
                menuButton.image = UIImage(named: "cm_arrow_downward_white")
                menuExpanded = !menuExpanded
                delegate?.collapseSidePanels()
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    func menuItemSelected(item: String, type: MenuItemType) {

        menuExpanded = !menuExpanded
        menuButton.image = !menuExpanded ? UIImage(named: "cm_arrow_downward_white") : UIImage(named: "cm_arrow_upward_white")
        let allMatches = [liveMatches, completedMatches, upcomingMatches].flatMap { $0 }
        
        switch type {
        case .team:
            showSelectedMatches(selectionTitle: item.uppercased(), matchList: allMatches.filter { $0.hometeamName == item || $0.awayteamName == item }, selectionType: .team)
        case .series:
            showSelectedMatches(selectionTitle: item.uppercased(), matchList: allMatches.filter { $0.seriesName == item }, selectionType: .series)
        case .matchType:
            showSelectedMatches(selectionTitle: item.uppercased(), matchList: allMatches.filter { $0.cmsMatchType == item }, selectionType: .team)
        case .favoriteTeam:
            showFavoriteTeamMatches()
        default:
            break
        }
        delegate?.collapseSidePanels()
    }
    
    // MARK: - Handle Favorite Team
    
    func showFavoriteTeamMatches() {
        if let fav_team = defaults?.value(forKey: "favoriteTeamName") as? String {
            if let selectedMatchListVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
                selectedMatchListVC.mainViewControllerType = .favorite
                selectedMatchListVC.matchList = [liveMatches, completedMatches, upcomingMatches].flatMap { $0 }.filter { $0.hometeamName == fav_team || $0.awayteamName == fav_team }
                selectedMatchListVC.titleText = fav_team
                selectedMatchListVC.allMatches = [liveMatches, completedMatches, upcomingMatches].flatMap { $0 }
                self.navigationController?.pushViewController(selectedMatchListVC, animated: true)
            }
        } else if let favortiteTeamMenu = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController {
            favortiteTeamMenu.isFullmenu = false
            self.navigationController?.pushViewController(favortiteTeamMenu, animated: true)
//            delegate?.toggleLeftPanel(matchList: [liveMatches, completedMatches, upcomingMatches].flatMap { $0 }, showFullMenu: false)
        }
    }
    
    func updateFavoriteTeam() {
        
        if let fav_team = defaults?.value(forKey: "favoriteTeamName") as? String {
            matchList = allMatches.filter { $0.hometeamName == fav_team || $0.awayteamName == fav_team }
            titleText = fav_team
            titleLabel.text = titleText
            topMatchesTableView.reloadData()
        }
    }
    
    @IBAction func editFavorite(_ sender: Any) {
        if let favortiteTeamMenu = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController {
            favortiteTeamMenu.isFullmenu = false
            self.navigationController?.pushViewController(favortiteTeamMenu, animated: true)
        }
        
    }
    
    // MARK: - TableView

    func numberOfSections(in tableView: UITableView) -> Int {
        
        print(mainViewControllerType)
        
        if mainViewControllerType == .main {
            return 1
        } else if mainViewControllerType == .fixtures {
            return 1 //Array(Set((matchList.map { $0.startDateMonth }))).count // 2.0.1 😬
        } else {
            if Array(Set((matchList.map { $0.seriesName }))).count == 0 {
                return 1
            } else {
                return Array(Set((matchList.map { $0.seriesName }))).count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mainViewControllerType == .main {
            return matchList.count
        } else if mainViewControllerType == .fixtures {
            return matchList.count //matchList.filter{ $0.startDateMonth == Array(Set((matchList.map { $0.startDateMonth })))[section] }.count // 2.0.1 😬
        } else if matchList.count == 0 {
            return 1
        } else {
            return matchList.filter{ $0.seriesName == Array(Set((matchList.map { $0.seriesName })))[section] }.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if matchList.count == 0 && mainViewControllerType != .main {
            let dummyCell = topMatchesTableView.dequeueReusableCell(withIdentifier: "dummyCell", for: indexPath) as! CellWithText
            dummyCell.dummyTextLabel.text =  "no recent matches".uppercased() //
            dummyCell.dummyTextLabel.textColor = secondaryColor
            dummyCell.dummyTextLabel.font = RobotoFont.regular
            return dummyCell
        }
        
        
        
        var newMatchList = mainViewControllerType == .main || mainViewControllerType == .fixtures ? matchList :  matchList.filter{ $0.seriesName == Array(Set((matchList.map { $0.seriesName })))[indexPath.section] } //mainViewControllerType == .fixtures ? matchList.filter{ $0.startDateMonth == Array(Set((matchList.map { $0.startDateMonth })))[indexPath.section] } : // 2.0.1 😬
        
        
        if let match = newMatchList[indexPath.row] as Match? {
            
            print("\(match.matchId)----\(match.startDate)----\(match.hometeamName)----\(match.awayteamName)----\(match.isInternational)----\(match.startDateMonth)")
            if match.status == .dummy_series {
                let dummyCell = topMatchesTableView.dequeueReusableCell(withIdentifier: "dummyMatchCell", for: indexPath) as! CellWithButtons

                dummyCell.btn1.setTitle(match.seriesName.uppercased(), for: .normal)
                dummyCell.btn1.addTarget(self, action: #selector(showSelectedSeries), for: .touchUpInside)
                
                if let fav_team_name = defaults?.value(forKey: "favoriteTeamName") as? String {
                    dummyCell.btn2.setTitle("⭐️ team: \(fav_team_name)".uppercased(), for: .normal)
                } else {
                    dummyCell.btn2.setTitle("pick favorite team".uppercased(), for: .normal)
                }
                dummyCell.btn2.addTarget(self, action: #selector(showFavoriteTeamMatches), for: .touchUpInside)
                
                dummyCell.btn3.setTitle("Fixtures".uppercased(), for: .normal)
                dummyCell.btn3.addTarget(self, action: #selector(showFixtures), for: .touchUpInside)
                dummyCell.contentView.backgroundColor = mainColor
                
                return dummyCell
            } else if match.status == .upcoming {
                let cell = topMatchesTableView.dequeueReusableCell(withIdentifier: "upcomingMatchCell", for: indexPath) as! TopMatchCell
                cell.match = match
                cell.isUserInteractionEnabled = false
                return cell
            } else {
                let cell = topMatchesTableView.dequeueReusableCell(withIdentifier: "topMatchCell", for: indexPath) as! TopMatchCell
                cell.match = match
                return cell
            }
        }
        
        // :o
        return topMatchesTableView.dequeueReusableCell(withIdentifier: "topMatchCell", for: indexPath)
    }
    
//    may be it's better without section header 😮
//    may be it is not 🙄
//    nope 😕
//    2.0.1 😬
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if mainViewControllerType != .main && Array(Set((matchList.map { $0.seriesName }))).count != 0 {
//            return mainViewControllerType == .fixtures ? Array(Set((matchList.map { $0.startDateMonth })))[section] : Array(Set((matchList.map { $0.seriesName })))[section]
//        }
//        return nil
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if mainViewControllerType != .main && Array(Set((matchList.map { $0.seriesName }))).count != 0 {
//            var sectionTitle = UILabel()
//            sectionTitle.text = mainViewControllerType == .fixtures ? Array(Set((matchList.map { $0.startDateMonth })))[section] : Array(Set((matchList.map { $0.seriesName })))[section]
//            sectionTitle.textColor = secondaryColor
//            sectionTitle.font = RobotoFont.light
//            
//            return sectionTitle
//        }
//        return nil
//    }

    // MARK: - Bowled Service
    
    
    func didReceiveResults(_ requestType: RequestType, inningsId: NSNumber?, matchId: NSNumber?,  results: NSObject) {
        if requestType == .matches {
            if let resultsArray = results as? [AnyObject] {
                DispatchQueue.main.async(execute: {
                    (self.topMatches, self.liveMatches, self.completedMatches, self.upcomingMatches) = Match.topMatchesFromAPI(results: resultsArray, internationalOnly: false)
                    self.matchList = self.topMatches
                    self.topMatchesTableView.reloadData()
                    SwiftLoader.hide()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                })
            }
        } else if requestType == .seriesStandings {
            if let resultsArray = results as? NSDictionary {
                DispatchQueue.main.async(execute: {
                    
                    self.selectedSeriesStanding = Series.seriesStandingsFromResults(results: resultsArray)
//                    self.prepareTableViewData()
                })
            }
        }
    }
    
    func didReceiveImageResults(_ data: Data) {
        
    }
    
    func updateTableHeight() {
        self.topTableViewHeightConstraint.constant = CGFloat(topMatchCellheight * matchList.count + 50)
    }
    
    
}
