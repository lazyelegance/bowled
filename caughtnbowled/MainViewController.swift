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
    func toggleLeftPanel(_ seriesList: [MenuItem], teamsList: [MenuItem], matchTypesList: [MenuItem])
    //func toggleRightPanel(seriesList: [MenuItem], teamsList: [MenuItem], matchTypesList: [MenuItem])
    func collapseSidePanels()
}


class MainViewController: UIViewController, BowledServiceProtocol, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: MainViewControllerDelegate?
    var bowledServiceAPI: BowledService!

    var liveMatches = [Match]()
    var completedMatches = [Match]()
    var upcomingMatches = [Match]()
    var topMatches = [Match]()
    
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
        bowledServiceAPI = BowledService(delegate: self)
        bowledServiceAPI.getMatches()
        
        //prepare menu
        

        
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
        if let match = topMatches[indexPath.row] as Match? {
            if let matchDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "MatchDetailController") as? MatchDetailController {
                matchDetailViewController.match = match
                self.navigationController?.pushViewController(matchDetailViewController, animated: true)
            }
        }
    }
    
    @IBAction func unwindToMainController(_ segue: UIStoryboardSegue) {
    }

 
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topMatches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let match = topMatches[indexPath.row] as Match? {
            
            if match.status == .dummy_series {
                let dummyCell = topMatchesTableView.dequeueReusableCell(withIdentifier: "dummyMatchCell", for: indexPath) as! CellWithButtons

                dummyCell.btn1.setTitle(match.seriesName.uppercased(), for: .normal)
                dummyCell.btn2.setTitle("More Matches".uppercased(), for: .normal)
                dummyCell.btn3.setTitle("Fixtures".uppercased(), for: .normal)
                dummyCell.contentView.backgroundColor = mainColor
                
                return dummyCell
            } else if match.status == .upcoming {
                let cell = topMatchesTableView.dequeueReusableCell(withIdentifier: "upcomingMatchCell", for: indexPath) as! TopMatchCell
                cell.match = match
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
    
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let sectionHeader = View(frame: CGRect(x: 0, y: 0, width: topMatchesTableView.bounds.width, height: 40))
//        sectionHeader.backgroundColor = mainColor
//        
//        let sectionTitle = UILabel(frame: CGRect(x: 10, y: 5, width: sectionHeader.bounds.width, height: 30))
//        sectionTitle.text = "TOP MATCHES"
//        sectionTitle.font = RobotoFont.bold
//        sectionTitle.textColor = secondaryColor
//        
//        sectionHeader.addSubview(sectionTitle)
//        
//        return sectionHeader
//    }
//    
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
    
    

    // MARK: - Bowled Service
    func didReceiveResults(_ requestType: RequestType, results: NSObject) {
        if requestType == .matches {
            if let resultsArray = results as? [AnyObject] {
                DispatchQueue.main.async(execute: {
                    (self.topMatches, self.liveMatches, self.completedMatches, self.upcomingMatches) = Match.topMatchesFromAPI(results: resultsArray, internationalOnly: true)
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
        self.topTableViewHeightConstraint.constant = CGFloat(topMatchCellheight * topMatches.count + 50)
    }
    
    
}
