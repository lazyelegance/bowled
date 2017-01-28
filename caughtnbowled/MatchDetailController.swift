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

class MatchDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource, BowledServiceProtocol {
    
    var timer = Timer()
    var bowledServiceAPI: BowledService!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var pulseView: PulseView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var series: UILabel!
    @IBOutlet weak var teamOneName: UILabel!
    @IBOutlet weak var teamOneScore: UILabel!
    @IBOutlet weak var teamTwoName: UILabel!
    @IBOutlet weak var teamTwoScore: UILabel!
    @IBOutlet weak var matchStatus: UILabel!
    
    @IBOutlet weak var motmTitle: UILabel!
    
    @IBOutlet weak var motmName: UILabel!
    
    @IBOutlet weak var motmNameBtn: FlatButton!
    
    @IBOutlet weak var motmStats: UILabel!
    
    
    @IBOutlet weak var backButton: FlatButton!
    
    
    @IBAction func backToMain(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var awardsView: PulseView!
    @IBOutlet weak var battingView: PulseView!
    
    @IBOutlet weak var menuPlaceholder: UIView!
    
    @IBOutlet weak var awardsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var battingViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var headerViewWidth: NSLayoutConstraint!
    @IBOutlet weak var strikerName: UILabel!
    @IBOutlet weak var strikerRunsScored: UILabel!
    @IBOutlet weak var strikerBallsFaced: UILabel!
    @IBOutlet weak var strikerFours: UILabel!
    @IBOutlet weak var strikerSixes: UILabel!
    @IBOutlet weak var strikerSR: UILabel!
    
    @IBOutlet weak var nonstrikerName: UILabel!
    @IBOutlet weak var nonstrikerRunsScored: UILabel!
    @IBOutlet weak var nonstrikerBallsFaced: UILabel!
    @IBOutlet weak var nonstrikerFours: UILabel!
    @IBOutlet weak var nonstrikerSixes: UILabel!
    @IBOutlet weak var nonstrikerSR: UILabel!
    
    @IBOutlet weak var bowlerName: UILabel!
    @IBOutlet weak var bowlerOvers: UILabel!
    @IBOutlet weak var bowlerMaidens: UILabel!
    @IBOutlet weak var bowlerRunsConceded: UILabel!
    @IBOutlet weak var bowlerWickets: UILabel!
    @IBOutlet weak var bowlerEcomony: UILabel!
    
    
    
    
    
    
    var match: Match!
    var scorecard: Scorecard!
    var commentary: Commentary!
    var players = [NSNumber: Player]()
    var motmPlayer = Player(id: -1, name: "--")
    var battingWheel = [NSNumber: BattingWheel]()
    
    var partnerships = [NSNumber: [Partnership]]()
    
    var matchId: NSNumber!
    var seriesId: NSNumber!
    var homeTeamId: NSNumber!
    var awayTeamId: NSNumber!
    
    var kTableHeaderHeight: CGFloat = 240
    var kHeaderHeight: CGFloat = 350
    
    var mainMenu: HMSegmentedControl!
    var subMenu: HMSegmentedControl!
    
    var hasSubMenu = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        kHeaderHeight = match.status == .completed ? 350 : 250
        
        
        headerViewWidth.constant = view.bounds.width

//        headerView = tableView.tableHeaderView
//        headerView.frame.size.height = kHeaderHeight
        menuPlaceholder.backgroundColor = mainColor
        headerView.backgroundColor = mainColor
        pulseView.backgroundColor = secondaryColor
        
//        tableView.tableHeaderView = nil
//        tableView.addSubview(headerView)
        prepareHeaderView()
        prepareMainMenu()
        
        
        
//        tableView.contentInset = UIEdgeInsets(top: kHeaderHeight, left: 0, bottom: 0, right: 0)
//        tableView.contentOffset = CGPoint(x: 0, y: -kHeaderHeight)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = mainColor
        
        view.backgroundColor = mainColor
        
        swiftLoaderConfig.size = 100
        swiftLoaderConfig.spinnerColor = whitecolor
        swiftLoaderConfig.backgroundColor = clearcolor
        
        swiftLoaderConfig.foregroundAlpha = 0
        SwiftLoader.setConfig(swiftLoaderConfig)
        
        SwiftLoader.show(true)

    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        timer.invalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if match.status == .live {
            timer = Timer.scheduledTimer( timeInterval: 30, target: self, selector: #selector(refreshLiveMatchData), userInfo: nil, repeats: true)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Header View
    
    func prepareHeaderView() {
        
        
        
        series.text = match.seriesName.uppercased() + "\n" + match.matchName.uppercased()
        series.font = RobotoFont.regular
        series.textColor = secondaryColor
        
    
        if match.status == .live {
            if match.hometeamIsBatting {
                teamOneName.text = match.hometeamName
                teamOneScore.text = match.homeScore
                teamTwoName.text = match.awayteamName
                teamTwoScore.text = match.awayScore == "0/0 (0)" ? " " : match.awayScore
            } else {
                teamOneName.text = match.awayteamName
                teamOneScore.text = match.awayScore
                teamTwoName.text = match.hometeamName
                teamTwoScore.text = match.homeScore == "0/0 (0)" ? " " : match.homeScore
            }
        } else {
            
            //what happens if no one team wins?
            
            if match.hometeamId == match.winningTeamId {
                teamOneName.text = match.hometeamName
                teamOneScore.text = match.homeScore
                teamTwoName.text = match.awayteamName
                teamTwoScore.text = match.awayScore == "0/0 (0)" ? " " : match.awayScore
            } else {
                teamOneName.text = match.awayteamName
                teamOneScore.text = match.awayScore
                teamTwoName.text = match.hometeamName
                teamTwoScore.text = match.homeScore == "0/0 (0)" ? " " : match.homeScore
            }
        }
        
        matchStatus.text = match.matchSummaryText.uppercased()
        
        matchStatus.font = RobotoFont.regular
        
        teamOneName.textColor = mainColor
        teamOneName.font = RobotoFont.regular(with: 20)
        
        teamOneScore.textColor = mainColor
        teamOneScore.font = RobotoFont.regular(with: 30)
        
        teamTwoName.textColor = mainColor
        teamTwoName.font = RobotoFont.regular
        
        teamTwoScore.textColor = mainColor
        teamTwoScore.font = RobotoFont.regular
        
        awardsViewHeight.constant = 0
        
        battingView.backgroundColor = mainColor
        matchStatus.textColor = secondaryColor
        
        // MOVE FROM HERE
        bowledServiceAPI = BowledService(delegate: self)
        bowledServiceAPI.getScoreCard(match.matchId, seriesid: match.seriesId)
        bowledServiceAPI.getCommentary(match.matchId, seriesid: match.seriesId)
        bowledServiceAPI.getMatchPlayers(match.matchId, seriesid: match.seriesId)
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
            
            motmNameBtn.setTitle(scorecard.motm.name.uppercased(), for: .normal)
//            motmName.text = scorecard.motm.name.uppercased()
            
            if let player = players[scorecard.motm.id] {
//                motmName.text = player.scorecardName.uppercased()
                motmPlayer = player
                motmNameBtn.setTitle(player.scorecardName.uppercased(), for: .normal)
                motmNameBtn.addTarget(self, action: #selector(showMotMPlayerProfileView), for: .touchUpInside)
            }
            
            
            if scorecard.motm.hasBatting && scorecard.motm.hasBowling {
                motmStats.text = scorecard.motm.batting + " " + scorecard.motm.bowling
            } else if scorecard.motm.hasBatting {
                motmStats.text = scorecard.motm.batting
            } else if scorecard.motm.hasBowling {
                motmStats.text = scorecard.motm.bowling
            } else {
                motmStats.text = ""
            }
            
            motmTitle.textColor = secondaryColor
            motmTitle.font = RobotoFont.light
 
            motmNameBtn.titleLabel?.textColor = secondaryColor
            motmNameBtn.titleColor = secondaryColor
            motmNameBtn.titleLabel?.font = RobotoFont.bold
            
            motmStats.textColor = secondaryColor
            motmStats.font = RobotoFont.medium
            
            motmTitle.alpha = 1
//            motmName.alpha = 1
            motmNameBtn.alpha = 1
            motmStats.alpha = 1
            
            awardsView.backgroundColor = mainColor
            
        } else if match.status == .live && scorecard != nil && commentary != nil {
            self.awardsViewHeight.constant = 0
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
        mainMenu.frame.size.width = menuPlaceholder.frame.size.width - 20
        mainMenu.frame.origin.y = 10
        
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
        menuPlaceholder.addSubview(mainMenu)
        
        mainMenu.alpha = 0
        mainMenu.isUserInteractionEnabled = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        updateHeaderView()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        if self.subMenu != nil && self.mainMenu.selectedSegmentIndex == 0 {
            return 2
        } else if self.subMenu != nil {
            return 1
        }
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
                    batsmanRecordCell.isUserInteractionEnabled = false
                } else if let batsman = self.scorecard.innings[self.subMenu.selectedSegmentIndex].batsmen[indexPath.row - 1] as Batsman? {
                    batsmanRecordCell.batsman = batsman
                    batsmanRecordCell.contentView.backgroundColor = mainColor
                    if let player = players[batsman.id] {
                        batsmanRecordCell.name.text = player.scorecardName
                    }
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
                    bowlerRecordCell.isUserInteractionEnabled = false
                } else if let bowler = self.scorecard.innings[self.subMenu.selectedSegmentIndex].bowlers[indexPath.row - 1] as Bowler? {
                    bowlerRecordCell.bowler = bowler
                    bowlerRecordCell.contentView.backgroundColor = mainColor
                    if let player = players[bowler.id] {
                        bowlerRecordCell.name.text = player.scorecardName
                    }
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
    
    
    //MARK: - navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        if self.subMenu != nil && self.mainMenu.selectedSegmentIndex == 0 {
            if indexPath.section == 0 && indexPath.row != 0 {
                if let batsman = self.scorecard.innings[self.subMenu.selectedSegmentIndex].batsmen[indexPath.row - 1] as Batsman? {
                    
                    if let player = players[batsman.id] {
                        showPlayerProfileView(player: player)
                    }

                }
            } else if indexPath.section == 1 && indexPath.row != 0 {
                if let bowler = self.scorecard.innings[self.subMenu.selectedSegmentIndex].bowlers[indexPath.row - 1] as Bowler? {
                    if let player = players[bowler.id] {
                        showPlayerProfileView(player: player)
                    }
                }
            }
        }
    }
    
    func showMotMPlayerProfileView() {
        if motmPlayer.id != -1 && match.status == .completed {
            self.showPlayerProfileView(player: self.motmPlayer)
        }
    }
    
  func showPlayerProfileView(player: Player) {
        if let ppvc = self.storyboard?.instantiateViewController(withIdentifier: "PlayerProfileController") as? PlayerProfileController {
            ppvc.player = player
            self.navigationController?.pushViewController(ppvc, animated: true)
            
        }
    }
 

    
    //MARK: - segemented views
    
    func mainMenuChangedValue(_ mainMenu: HMSegmentedControl) {
        
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
        switch Reach().connectionStatus() {
        case .online :
            bowledServiceAPI.getMatches()
            bowledServiceAPI.getScoreCard(match.matchId, seriesid: match.seriesId)
            bowledServiceAPI.getCommentary(match.matchId, seriesid: match.seriesId)
            //bowledServiceAPI.getMatchPlayers(match.matchId, seriesid: match.seriesId)
        default:
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    

    func updateLiveMatchData(matches: [Match]) {
        for m in matches {
            if match.matchId == m.matchId {
                self.match = m
                self.prepareHeaderView()
            }
        }
    }
    
    // MARK: - Bowled Service
    func didReceiveResults(_ requestType: RequestType, inningsId: NSNumber?, matchId: NSNumber?, results: NSObject) {
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
                            self.subMenu.frame.size.width = self.menuPlaceholder.frame.size.width - 20
                            self.subMenu.frame.origin.y = self.menuPlaceholder.frame.size.height - 30
                            self.subMenu.autoresizingMask =  [.flexibleRightMargin, .flexibleWidth]
                            self.subMenu.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe
                            self.subMenu.borderType = HMSegmentedControlBorderType.bottom
                            self.subMenu.borderColor = whitecolor
                            
                            
                            self.subMenu.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
                            
                            self.subMenu.selectionIndicatorColor = whitecolor                            
                            self.subMenu.backgroundColor = self.headerView.backgroundColor
                            self.subMenu.titleTextAttributes = [NSForegroundColorAttributeName: whitecolor , NSFontAttributeName: UIFont.systemFont(ofSize: 10)]
                            self.menuPlaceholder.addSubview(self.subMenu)
                            self.hasSubMenu = true
                            
                            for inningsId in (self.scorecard?.innings.map{ $0.id })! {
                                self.bowledServiceAPI.getPartnerships(self.match.matchId, seriesid: self.match.seriesId, inniid: inningsId)
//                                self.bowledServiceAPI.getBattingWheel(self.match.matchId, seriesid: self.match.seriesId, inniid: inningsId)
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
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
                if let resultsDictionary = results as? [String: AnyObject] {
                    self.players = Player.playersFromResults(results: resultsDictionary)
                    
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    DispatchQueue.main.async(execute: {
                        
                        
                        self.tableView.reloadData()
                        
                  })
                }
                
                
            })
            
        } else if requestType == .commentary {
            let commentaryQueue = DispatchQueue(label: "commentaryQueue", attributes: [])
            
            
            
            commentaryQueue.async { () -> Void in
                
                if let resultsDictionary = results as? NSDictionary {
                    let commentaryfromresults = Commentary.commentaryFromAPI(resultsDictionary)
                    
                    self.commentary = commentaryfromresults
                    self.mainMenu.isUserInteractionEnabled = true
                    //self.activityIndicator.stopAnimation()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    DispatchQueue.main.async(execute: {
                        self.updateSecondaryViews()
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
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    DispatchQueue.main.async(execute: {
//                        self.updateMatchDetails()
                        //Loading.stop()
                    })
                }
            }
        } else if requestType == .matches {
            if let resultsArray = results as? [AnyObject] {
                DispatchQueue.main.async(execute: {
                    let matches = Match.matchesFromAPI(results: resultsArray)
                    self.updateLiveMatchData(matches: matches)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                })
            }
        } else if requestType == .battingWheel {
            let battingWheelQueue = DispatchQueue(label: "battingWheelQueue", attributes: [])
            
            battingWheelQueue.async { () -> Void in
                
                if results is NSDictionary {
//                    var battingWheel = BattingWheel.battingWheelFromResults
                    let bw = BattingWheel.battingWheelFromResults(matchId: matchId!, inningsId: inningsId!, results: results as! NSDictionary)
                    self.battingWheel[bw.inningsId] = bw
                    DispatchQueue.main.async(execute: {
                        //                        self.updateMatchDetails()
                        //Loading.stop()
                    })
                }
            }
            
        }
    }
    
    func didReceiveImageResults(_ data: Data) {
        
    }

}
