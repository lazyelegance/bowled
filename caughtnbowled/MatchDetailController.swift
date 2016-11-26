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
    
    @IBOutlet weak var motmTitle: UILabel!
    
    @IBOutlet weak var motmName: UILabel!
    
    @IBOutlet weak var motmStats: UILabel!
    
    
    @IBOutlet weak var backButton: FlatButton!
    
    @IBAction func backToMain(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBOutlet weak var awardsView: PulseView!
    @IBOutlet weak var battingView: PulseView!
    
    
    @IBOutlet weak var awardsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var battingViewHeight: NSLayoutConstraint!
    
    
    var match: Match!
    var scorecard: Scorecard!
    var commentary: Commentary!
    
    var partnerships = [NSNumber: [Partnership]]()
    
    var matchId: NSNumber!
    var seriesId: NSNumber!
    var homeTeamId: NSNumber!
    var awayTeamId: NSNumber!
    
    var kTableHeaderHeight: CGFloat = 240
    let kHeaderHeight: CGFloat = 350
    
    var mainMenu: HMSegmentedControl!
    var subMenu: HMSegmentedControl!
    
    var hasSubMenu = false

    override func viewDidLoad() {
        super.viewDidLoad()

        headerView = tableView.tableHeaderView
        headerView.frame.size.height = kHeaderHeight
        headerView.backgroundColor = mainColor
        
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        prepareHeaderView()
        prepareMainMenu()
        tableView.contentInset = UIEdgeInsets(top: kHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kHeaderHeight)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = mainColor

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

        
        series.textColor = mainColor
//        series.font = RobotoFont.bold
        matchStatus.textColor = mainColor
//        matchStatus.font = RobotoFont
        
        teamOneName.textColor = mainColor
        teamOneName.font = RobotoFont.bold
        
        teamOneScore.textColor = mainColor
        teamOneScore.font = RobotoFont.light
        
        teamTwoName.textColor = mainColor
        teamTwoName.font = RobotoFont.bold
        
        teamTwoScore.textColor = mainColor
        teamTwoScore.font = RobotoFont.light
        
        self.awardsViewHeight.constant = 0
        self.battingViewHeight.constant = 0 
        
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
        mainMenu.frame.origin.y = headerRect.size.height - 70
        
        if self.subMenu != nil {
            self.subMenu.frame.origin.y = headerRect.size.height - 30
        }

    }
    
    
    func updateSecondaryViews() {
        if match.status == .completed && scorecard.hasMotM {
            self.awardsViewHeight.constant = 100
            
            
            
            motmTitle.text = "Player Of The Match"
            motmName.text = scorecard.motm.name.uppercased()
            
            if scorecard.motm.hasBatting && scorecard.motm.hasBowling {
                motmStats.text = scorecard.motm.batting + " " + scorecard.motm.bowling
            } else if scorecard.motm.hasBatting {
                motmStats.text = scorecard.motm.batting
            } else if scorecard.motm.hasBowling {
                motmStats.text = scorecard.motm.bowling
            } else {
                motmStats.text = ""
            }
            
            motmTitle.textColor = Color.white
            motmTitle.font = RobotoFont.light
            
            motmName.textColor = Color.white
            motmName.font = RobotoFont.bold
            
            motmStats.textColor = Color.white
            motmStats.font = RobotoFont.medium
            
            motmTitle.alpha = 1
            motmName.alpha = 1
            motmStats.alpha = 1
            
            awardsView.backgroundColor = mainColor
            
        }
        
    
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    func prepareMainMenu() {
        mainMenu = HMSegmentedControl(sectionTitles: ["SCORECARD", "COMMENTARY", "PARTNERSHIPS", "HIGHLIGHTS"])
        
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
        if self.subMenu != nil && self.mainMenu.selectedSegmentIndex == 0 {
            return 2
        } else if self.subMenu != nil {
            return 1
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.subMenu != nil && self.mainMenu.selectedSegmentIndex == 0 {
            switch section {
            case 0:
                return self.scorecard.innings[self.subMenu.selectedSegmentIndex].batsmen.count + 1
            case 1:
                return self.scorecard.innings[self.subMenu.selectedSegmentIndex].bowlers.count + 1
            default:
                break
            }
        } else if self.subMenu != nil && self.mainMenu.selectedSegmentIndex == 1 {
            
            return self.commentary.commentaryInnings[self.subMenu.selectedSegmentIndex].commentaryOvers.map { $0.deliveries }.flatMap { $0 }.map { $0.comments }.flatMap { $0 }.count
        } else if self.subMenu != nil && self.mainMenu.selectedSegmentIndex == 2 {
            
            
            if self.partnerships[NSNumber(integerLiteral: (self.subMenu.sectionTitles.count - self.subMenu.selectedSegmentIndex))] != nil {
                return self.partnerships[NSNumber(integerLiteral: (self.subMenu.sectionTitles.count - self.subMenu.selectedSegmentIndex))]!.count
            } else {
                return 0
            }
        } else if self.subMenu != nil && self.mainMenu.selectedSegmentIndex == 3 {
            return self.commentary.commentaryInnings[self.subMenu.selectedSegmentIndex].commentaryOvers.map { $0.deliveries }.flatMap { $0 }.map { $0.comments }.flatMap { $0 }.filter { $0.isHighlight }.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.subMenu != nil && self.mainMenu.selectedSegmentIndex == 0 {
            switch indexPath.section {
            case 0:
                let batsmanRecordCell = tableView.dequeueReusableCell(withIdentifier: "batsmanRecordCell", for: indexPath) as! BatsmanRecordCell
                if indexPath.row == 0 {
                    var dummybatsman = Batsman(id: 0, name: "", runsScored: "Rs", ballsFaced: "Bs")
                    dummybatsman.sixesHit = "6s"
                    dummybatsman.foursHit = "4s"
                    dummybatsman.strikeRate = "S/R"
                    dummybatsman.howOut = ""
                    batsmanRecordCell.batsman = dummybatsman
                    
                    batsmanRecordCell.strikeRate.font = RobotoFont.bold(with: 15)
                    batsmanRecordCell.ballsFaced.font = RobotoFont.bold(with: 15)
                    batsmanRecordCell.fours.font = RobotoFont.bold(with: 15)
                    batsmanRecordCell.sixes.font = RobotoFont.bold(with: 15)
                    batsmanRecordCell.contentView.backgroundColor = mainColor
                } else if let batsman = self.scorecard.innings[self.subMenu.selectedSegmentIndex].batsmen[indexPath.row - 1] as Batsman? {
                    batsmanRecordCell.batsman = batsman
                    batsmanRecordCell.contentView.backgroundColor = indexPath.row % 2 == 0 ? mainColor : Color.indigo.darken1
                }
                return batsmanRecordCell
            case 1:
                let bowlerRecordCell = tableView.dequeueReusableCell(withIdentifier: "bolwerRecordCell", for: indexPath) as! BowlerRecordCell
                if indexPath.row == 0 {
                    bowlerRecordCell.bowler = Bowler(id: 0, name: "", overs: "O", maidens: "M", runsConceded: "R", wickets: "W", economy: "econ.")
                    bowlerRecordCell.overs.font = RobotoFont.bold(with: 15)
                    bowlerRecordCell.maidens.font = RobotoFont.bold(with: 15)
                    bowlerRecordCell.runsConceded.font = RobotoFont.bold(with: 15)
                    bowlerRecordCell.ecomony.font = RobotoFont.bold(with: 15)
                    bowlerRecordCell.contentView.backgroundColor = mainColor
                } else if let bowler = self.scorecard.innings[self.subMenu.selectedSegmentIndex].bowlers[indexPath.row - 1] as Bowler? {
                    bowlerRecordCell.bowler = bowler
                    bowlerRecordCell.contentView.backgroundColor = indexPath.row % 2 == 0 ? mainColor : Color.indigo.darken1
                }
                
                return bowlerRecordCell
            default:
                break
            }
        } else if self.subMenu != nil && self.mainMenu.selectedSegmentIndex == 1 {
            let commentaryCell = tableView.dequeueReusableCell(withIdentifier: "commentaryCell", for: indexPath) as! CommentaryCell
            let comments = self.commentary.commentaryInnings[self.subMenu.selectedSegmentIndex].commentaryOvers.map { $0.deliveries }.flatMap { $0 }.map { $0.comments }.flatMap { $0 }
            
            commentaryCell.comment = comments[indexPath.row]
            return commentaryCell
        } else if self.subMenu != nil && self.mainMenu.selectedSegmentIndex == 2 {
            let partnershipCell = tableView.dequeueReusableCell(withIdentifier: "partnershipCell", for: indexPath) as! PartnershipCell
            
            partnershipCell.partnership = self.partnerships[NSNumber(integerLiteral: (self.subMenu.sectionTitles.count - self.subMenu.selectedSegmentIndex))]?[indexPath.row]
            
            return partnershipCell
        } else if self.subMenu != nil && self.mainMenu.selectedSegmentIndex == 3 {
            let commentaryCell = tableView.dequeueReusableCell(withIdentifier: "commentaryCell", for: indexPath) as! CommentaryCell
            let comments = self.commentary.commentaryInnings[self.subMenu.selectedSegmentIndex].commentaryOvers.map { $0.deliveries }.flatMap { $0 }.map { $0.comments }.flatMap { $0 }.filter { $0.isHighlight }
            
            commentaryCell.comment = comments[indexPath.row]
            return commentaryCell
        }
        
        //WHY?
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentaryCell", for: indexPath)
        return cell
        
    }
 

    
    //MARK: - segemented views
    
    func mainMenuChangedValue(_ mainMenu: HMSegmentedControl) {
        print("main menu value chnaged")
        switch mainMenu.selectedSegmentIndex {
        case 0:
            self.subMenu.sectionTitles = self.scorecard?.innings.map { $0.name }
        case 1,3:
            self.subMenu.sectionTitles = self.commentary?.commentaryInnings.map { $0.name }
        case 2:
            self.subMenu.sectionTitles = self.scorecard?.innings.map { $0.name }
        default:
            self.subMenu.sectionTitles = ["three", "four"]
        }
        
        self.subMenu.setSelectedSegmentIndex(0, animated: true)
        self.subMenu.reloadInputViews()
        self.tableView.reloadData()
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
                            
                            self.subMenu = HMSegmentedControl(sectionTitles: self.scorecard?.innings.map{ $0.name })
                            
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
                            self.subMenu.backgroundColor = self.headerView.backgroundColor
                            self.subMenu.titleTextAttributes = [NSForegroundColorAttributeName: whitecolor , NSFontAttributeName: UIFont.systemFont(ofSize: 10)]
                            self.headerView.addSubview(self.subMenu)
                            self.hasSubMenu = true
                            
                            for inningsId in (self.scorecard?.innings.map{ $0.id })! {
                                self.bowledServiceAPI.getPartnerships(self.match.matchId, seriesid: self.match.seriesId, inniid: inningsId)
                            }
                            
                            self.updateSecondaryViews()
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
                    print("HEEEEEEREEEEE")
//                    print(self.commentary.commentaryInnings[self.subMenu.selectedSegmentIndex].commentaryOvers.map { $0.deliveries }.flatMap { $0 })
                    //self.activityIndicator.stopAnimation()
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
                    let partnershipsfromresults = Partnerships.partnershipsFromAPI(results: resultsDictionary)
                    self.partnerships[partnershipsfromresults.inningsid] = partnershipsfromresults.partnerships
                    print(self.partnerships)
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
