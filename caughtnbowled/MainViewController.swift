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
    

    @IBOutlet weak var topMatchesView: View!
    
    @IBOutlet weak var topMatchesTableView: UITableView!
    
    
    @IBOutlet weak var topTableViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = mainColor

//        self.updateTableHeight()
        
        //get match list
        bowledServiceAPI = BowledService(delegate: self)
        bowledServiceAPI.getMatches()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareView() {
        topMatchesView.backgroundColor = Color.clear
        topMatchesTableView.backgroundColor = Color.clear
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedMatches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = topMatchesTableView.dequeueReusableCell(withIdentifier: "topMatchCell", for: indexPath) as! TopMatchCell
        
        if let match = completedMatches[indexPath.row] as Match? {
            cell.match = match
        }
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(topMatchCellheight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let match = completedMatches[indexPath.row] as Match? {
            if let matchDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "MatchDetailController") as? MatchDetailController {
                matchDetailViewController.match = match
                self.navigationController?.pushViewController(matchDetailViewController, animated: true)
            }
        }
    }

    // MARK: - Bowled Service
    func didReceiveResults(_ requestType: RequestType, results: NSObject) {
        if requestType == .matches {
            if let resultsArray = results as? [AnyObject] {
                DispatchQueue.main.async(execute: {
                    print(results)
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
        self.topTableViewHeightConstraint.constant = CGFloat(topMatchCellheight * liveMatches.count + 50)
    }
    
    
}
