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
    func toggleLeftPanel(matchList: [Match])
    //func toggleRightPanel(seriesList: [MenuItem], teamsList: [MenuItem], matchTypesList: [MenuItem])
    func collapseSidePanels()
}


class MainViewController: UIViewController, BowledServiceProtocol, UITableViewDelegate, UITableViewDataSource, MenuControllerDelegate {
    
    
    var bowledServiceAPI: BowledService!

    var liveMatches = [Match]()
    var completedMatches = [Match]()
    var upcomingMatches = [Match]()
    var matchList = [Match]()
    
    var isMainViewController = true
    
    var menuExpanded = false
    var delegate: MainViewControllerDelegate?
    
    
    var selectedSeriesStanding: Series?
    
    var topMatchCellheight = 150
    
    @IBOutlet weak var menuButton: FlatButton!
    
    

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
//        topMatchesTableView.indi
//        self.updateTableHeight()
        
        //get match list
        
        if isMainViewController {
            bowledServiceAPI = BowledService(delegate: self)
            bowledServiceAPI.getMatches()
        }
        
        
        //prepare menu
        
        menuButton.image = isMainViewController ? UIImage(named: "cm_arrow_downward_white") : UIImage(named: "ic_arrow_back_white")
        
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareView() {
        
        topMatchesTableView.backgroundColor = Color.clear
        
        
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
        showSelectedMatches(matchList: [liveMatches, completedMatches, upcomingMatches].flatMap { $0 }.filter { $0.seriesId == matchList.filter { $0.status == .dummy_series }[0].seriesId })
    }
    
    func showFavoriteTeamMatches() {
        if let fav_team = defaults?.value(forKey: "favoriteTeamName") as? String {
            showSelectedMatches(matchList: [liveMatches, completedMatches, upcomingMatches].flatMap { $0 }.filter { $0.hometeamName == fav_team || $0.awayteamName == fav_team })
        }
    }
    
    func showFixtures() {
        showSelectedMatches(matchList: self.upcomingMatches)
    }
    
    
    func showSelectedMatches(matchList: [Match]) {
        if let selectedMatchListVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
            selectedMatchListVC.isMainViewController = false
            selectedMatchListVC.matchList = matchList
            self.navigationController?.pushViewController(selectedMatchListVC, animated: true)
        }
    }

 
    @IBAction func menuButtonAction(_ sender: Any) {
        if !(isMainViewController) {
            self.navigationController?.popViewController(animated: true)
        } else if !menuExpanded {
            menuButton.image = UIImage(named: "cm_arrow_upward_white")
            menuExpanded = !menuExpanded
            delegate?.toggleLeftPanel(matchList: [liveMatches, completedMatches, upcomingMatches].flatMap { $0 })
        } else {
            menuButton.image = UIImage(named: "cm_arrow_downward_white")
            menuExpanded = !menuExpanded
            delegate?.collapseSidePanels()
        }
    }
    
    
    func menuItemSelected(item: String, type: MenuItemType) {
        print("..................")
        menuExpanded = !menuExpanded
        menuButton.image = menuExpanded ? UIImage(named: "cm_arrow_downward_white") : UIImage(named: "cm_arrow_upward_white")
        let allMatches = [liveMatches, completedMatches, upcomingMatches].flatMap { $0 }
        
        switch type {
        case .team:
            print(allMatches.filter { $0.hometeamName == item || $0.awayteamName == item }.count)
        case .series:
            print(allMatches.filter { $0.seriesName == item }.count) 
        default:
            break
        }
        delegate?.collapseSidePanels()
        
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let match = matchList[indexPath.row] as Match? {
            
            if match.status == .dummy_series {
                let dummyCell = topMatchesTableView.dequeueReusableCell(withIdentifier: "dummyMatchCell", for: indexPath) as! CellWithButtons

                dummyCell.btn1.setTitle(match.seriesName.uppercased(), for: .normal)
                dummyCell.btn1.addTarget(self, action: #selector(showSelectedSeries), for: .touchUpInside)
                
                if let fav_team_name = defaults?.value(forKey: "favoriteTeamName") as? String {
                    dummyCell.btn2.setTitle("⭐️ team: \(fav_team_name)".uppercased(), for: .normal)
                    dummyCell.btn2.addTarget(self, action: #selector(showFavoriteTeamMatches), for: .touchUpInside)
                }
                
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
    
    

    // MARK: - Bowled Service
    func didReceiveResults(_ requestType: RequestType, results: NSObject) {
        if requestType == .matches {
            if let resultsArray = results as? [AnyObject] {
                DispatchQueue.main.async(execute: {
                    (self.matchList, self.liveMatches, self.completedMatches, self.upcomingMatches) = Match.topMatchesFromAPI(results: resultsArray, internationalOnly: true)
//                    self.prepareTableViewData()
//                    self.prepareMenuData()
//                    print(self.liveMatches.count)
//                    self.updateTableHeight()
                    self.topMatchesTableView.reloadData()
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
