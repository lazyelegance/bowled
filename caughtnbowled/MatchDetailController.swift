//
//  MatchDetailController.swift
//  Bowled
//
//  Created by Ezra Bathini on 20/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import BowledService
import Material

class MatchDetailController: UITableViewController, BowledServiceProtocol {
    
    var bowledServiceAPI: BowledService!
    
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var series: UILabel!
    @IBOutlet weak var teamOneName: UILabel!
    @IBOutlet weak var teamOneScore: UILabel!
    @IBOutlet weak var teamTwoName: UILabel!
    @IBOutlet weak var teamTwoScore: UILabel!
    @IBOutlet weak var matchStatus: UILabel!
    
    var match: Match!
    var scorecard: Scorecard!
    var commentary: Commentary!
    var partnerships = [NSNumber: NSArray]()
    
    var matchId: NSNumber!
    var seriesId: NSNumber!
    var homeTeamId: NSNumber!
    var awayTeamId: NSNumber!
    
    var kTableHeaderHeight: CGFloat = 240
    let kHeaderHeight: CGFloat = 300
    
    var mainMenu: HMSegmentedControl!
    var subMenu: HMSegmentedControl!
    
    var hasSubMenu = false

    override func viewDidLoad() {
        super.viewDidLoad()

        headerView = tableView.tableHeaderView
        headerView.frame.size.height = kHeaderHeight
        
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        tableView.contentInset = UIEdgeInsets(top: kHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kHeaderHeight)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        prepareHeaderView()
        prepareMainMenu()
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Header View
    
    func prepareHeaderView() {
        series.text = match.seriesName
        teamOneName.text = match.hometeamName
        teamOneScore.text = match.homeScore
        teamTwoName.text = match.awayteamName
        teamTwoScore.text = match.awayScore
        matchStatus.text = match.matchSummaryText
        matchId = match.matchId
        seriesId = match.seriesId
        
        // MOVE FROM HERE
        bowledServiceAPI = BowledService(delegate: self)
        bowledServiceAPI.getScoreCard(match.matchId, seriesid: match.seriesId)
        bowledServiceAPI.getCommentary(match.matchId, seriesid: match.seriesId)
        //refreshLiveMatchData()
        
    }
    
    func updateHeaderView() {

        var headerRect = CGRect(x: 0, y: -kHeaderHeight, width: tableView.bounds.width, height: (kHeaderHeight) )
        if tableView.contentOffset.y < -kHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -(tableView.contentOffset.y)
            
        }
        
        headerView.frame = headerRect
////        mainMenu.frame.origin.y = headerRect.size.height - 70
//        
//        if self.subMenu != nil {
//            self.subMenu.frame.origin.y = headerRect.size.height - 30
//        }

    }
    
    
    func prepareMainMenu() {
        mainMenu = HMSegmentedControl(sectionTitles: ["SCORECARD", "COMMENTARY", "PARTNERSHIPS"])
        
        mainMenu.addTarget(self, action: #selector(mainMenuChangedValue(_:)), for: UIControlEvents.valueChanged)
        mainMenu.frame.size.height = 40
        mainMenu.frame.origin.x = 10
        mainMenu.frame.size.width = headerView.frame.size.width - 20
        mainMenu.frame.origin.y = headerView.frame.size.height - 70
        
        mainMenu.autoresizingMask =  [.flexibleRightMargin, .flexibleWidth]
        
        mainMenu.layer.cornerRadius = 2
        mainMenu.layer.masksToBounds = true
        mainMenu.layer.borderWidth = 1
        mainMenu.layer.borderColor = whitecolor.cgColor
        
        mainMenu.selectionIndicatorColor = whitecolor
        
        mainMenu.borderType = HMSegmentedControlBorderType.right
        mainMenu.selectionStyle = HMSegmentedControlSelectionStyleBox
        mainMenu.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        
        
        
        mainMenu.borderColor = whitecolor
        
        mainMenu.backgroundColor = headerView.backgroundColor
        mainMenu.titleTextAttributes = [NSForegroundColorAttributeName: whitecolor , NSFontAttributeName: UIFont.systemFont(ofSize: 10)]
        mainMenu.selectedTitleTextAttributes = [NSForegroundColorAttributeName: headerView.backgroundColor , NSFontAttributeName: UIFont.systemFont(ofSize: 10)]
        
        
        headerView.addSubview(mainMenu)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = "one"

        return cell
    }
 
    
    //MARK: - segemented views
    
    func mainMenuChangedValue(_ mainMenu: HMSegmentedControl) {
        print("main menu value chnaged")
//        switch mainMenu.selectedSegmentIndex {
//        case 0:
//            self.subMenu.sectionTitles = self.scorecard?.inningsNamesArray
//        case 1:
//            self.subMenu.sectionTitles = self.commentary?.inningsNamesArray
//        case 2:
//            self.subMenu.sectionTitles = self.scorecard?.inningsNamesArray.reversed()
//        default:
//            self.subMenu.sectionTitles = ["three", "four"]
//        }
//        
//        self.subMenu.setSelectedSegmentIndex(0, animated: true)
//        self.subMenu.reloadInputViews()
//        self.tableView.reloadData()
    }
    
    func subMenuChangedValue(_ subMenu: HMSegmentedControl) {
        
        self.tableView.reloadData()
        
        
    }
    
    //MARK: - Refresh/get Scorecard
    
    func refreshLiveMatchData() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            print("Not connected")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        case .online(.wwan), .online(.wiFi):
            print(match)
//            bowledServiceAPI.getScoreCard(match.matchId, seriesid: match.seriesId)
//            bowledServiceAPI.getCommentary(match.matchId, seriesid: match.seriesId)
        }
    }
    
    // MARK: - Bowled Service
    func didReceiveResults(_ requestType: RequestType, results: NSObject) {
        if requestType == .scorecard {
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
                
                if let resultsDictionary = results as? NSDictionary {
                    let scorecardfromresults = Scorecard.scorecardFromAPI(resultsDictionary)
                    self.scorecard = scorecardfromresults
                    DispatchQueue.main.async(execute: {
                        
                        if self.scorecard.status != "no results" {
                            
                            if self.hasSubMenu {
                                self.subMenu.removeFromSuperview()
                            }
                            
                            self.subMenu = HMSegmentedControl(sectionTitles: self.scorecard?.inningsNamesArray)
                            
                            self.subMenu.addTarget(self, action: #selector(MatchDetailController.subMenuChangedValue(_:)), for: UIControlEvents.valueChanged)
                            self.subMenu.frame.size.height = 30
                            
                            self.subMenu.frame.origin.x = 10
                            self.subMenu.frame.size.width = self.headerView.frame.size.width - 20
                            self.subMenu.frame.origin.y = self.headerView.frame.size.height - 30
                            self.subMenu.autoresizingMask =  [.flexibleRightMargin, .flexibleWidth]
                            self.subMenu.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe
                            self.subMenu.borderType = HMSegmentedControlBorderType.bottom
                            self.subMenu.borderColor = whitecolor
                            
                            
                            self.subMenu.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
                            
                            self.subMenu.selectionIndicatorColor = whitecolor
                            //                self.subMenu.layer.cornerRadius = 5
                            //                self.subMenu.layer.masksToBounds = true
                            
                            self.subMenu.backgroundColor = self.headerView.backgroundColor
                            self.subMenu.titleTextAttributes = [NSForegroundColorAttributeName: whitecolor , NSFontAttributeName: UIFont.systemFont(ofSize: 10)]
                            self.headerView.addSubview(self.subMenu)
                            self.hasSubMenu = true
                            
                            
                            for i in 1..<(self.scorecard?.inningsNamesArray.count)! {
//                                self.bowledServiceAPI.getPartnerships(self.matchId, seriesid: self.seriesId, inniid: i)
                            }
                        }
                        self.mainMenu.alpha = 1
                        SwiftLoader.hide()
                        self.tableView.reloadData()
                        
                    })
                    
                }
            })
        } else if requestType == .matchPlayers {
//            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
//                if let resultsDictionary = results as? NSDictionary {
//                    
//                    
//                    self.matchPlayers.removeAll()
//                    
//                    //self.matchPlayers = CBPlayer.matchPlayersFromResults(resultsDictionary)
//                    
//                    if let homeTeam = resultsDictionary["homeTeam"] as? NSDictionary {
//                        if let team = homeTeam["team"] as? NSDictionary {
//                            if let teamId = team["id"] as? NSNumber {
//                                if let players = homeTeam["players"] as? NSArray {
//                                    for i in 0 ..< players.count += 1 {
//                                        if let playerDict = players[i] as? NSDictionary {
//                                            if let playerId = playerDict["playerId"] as? NSNumber {
//                                                self.matchPlayers[playerId] = CBPlayer.playerFromResults(team, results: playerDict)
//                                            }
//                                            
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    
//                    if let awayTeam = resultsDictionary["awayTeam"] as? NSDictionary {
//                        if let team = awayTeam["team"] as? NSDictionary {
//                            if let teamId = team["id"] as? NSNumber {
//                                if let players = awayTeam["players"] as? NSArray {
//                                    for i in 0 ..< players.count += 1 {
//                                        if let playerDict = players[i] as? NSDictionary {
//                                            if let playerId = playerDict["playerId"] as? NSNumber {
//                                                self.matchPlayers[playerId] = CBPlayer.playerFromResults(team, results: playerDict)
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    
//                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                    
//                    DispatchQueue.main.async(execute: {
//                        
//                        
//                        self.tableView.reloadData()
//                        
//                    })
//                }
//                
//                
//            })
            
        } else if requestType == .commentary {
            let commentaryQueue = DispatchQueue(label: "commentaryQueue", attributes: [])
            
            
            
            commentaryQueue.async { () -> Void in
                
                if let resultsDictionary = results as? NSDictionary {
                    let commentaryfromresults = Commentary.commentaryFromAPI(resultsDictionary)
                    //let scorecardkeyfromresult = ScorecardKey(matchid: matchid, seriesid: seriesid)
                    
                    self.commentary = commentaryfromresults
                    //self.activityIndicator.stopAnimation()
                    
                    print(self.commentary)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    DispatchQueue.main.async(execute: {
                        //self.updateMatchDetails()
                        //Loading.stop()
                    })
                }
                
                
            }
        } else if requestType == .partnerships {
            let partnershipsQueue = DispatchQueue(label: "partnershipsQueue", attributes: [])
            
            partnershipsQueue.async { () -> Void in
                
                if let resultsDictionary = results as? NSDictionary {
                    let partnershipsfromresults = Partnerships.partnershipsFromAPI(resultsDictionary)
                    //let scorecardkeyfromresult = ScorecardKey(matchid: matchid, seriesid: seriesid)
                    
                    self.partnerships[partnershipsfromresults.inningsid] = partnershipsfromresults.partners
                    
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    DispatchQueue.main.async(execute: {
//                        self.updateMatchDetails()
                        //Loading.stop()
                    })
                }
                
                
            }
        } else if requestType == .matchDetail {
//            let partnershipsQueue = DispatchQueue(label: "matchDetailQueue", attributes: [])
//            
//            
//            
//            partnershipsQueue.async { () -> Void in
//                
//                if let resultsDictionary = results as? NSDictionary {
//                    //
//                }
//                
//            }
        }
    }
    
    func didReceiveImageResults(_ data: Data) {
        
    }

}
