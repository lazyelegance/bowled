//
//  CricService.swift
//  CricService
//
//  Created by Ezra Bathini on 9/06/18.
//  Copyright © 2018 Ezra Bathini. All rights reserved.
//

import Foundation



public protocol CricServiceProtocol {
    //    func didReceiveResults(_ requestType: RequestType, results: NSObject)
    func didReceiveCricResults(_ requestType: CRRequestType, inningsId: NSNumber?, matchId: NSNumber?, results: NSObject)
}

public enum CRRequestType {
    case matches
    case oldMatches
    case matchDetail
    case scorecard
    case commentary
    case teamPlayers
    case matchPlayers
    case partnerships
    case imageResource
    case seriesStandings
    case battingWheel
}

open class CricService {
    var delegate: CricServiceProtocol
    
    public init(delegate: CricServiceProtocol) {
        self.delegate = delegate
    }
    
    
    let config = URLSessionConfiguration.default
    
    // MARK: - CALLS
    
    
    open func getMatches() {
        let cricApiKeys = getApiKeys()
        
        let httpHeaderValue = cricApiKeys.object(forKey: "apiKey") as! String
        let HTTPAdditionalHeaders = ["apikey" : httpHeaderValue ]
        config.httpAdditionalHeaders = HTTPAdditionalHeaders
        let liveURLString = cricApiKeys.object(forKey: "matches") as! String
        let liveMatchesURL = URL(string: liveURLString)
        let session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: liveMatchesURL!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                //TO DO
                print(error?.localizedDescription ?? "error getting session")
            }
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    if let results: NSArray = jsonResult["matches"] as? NSArray {
                        self.delegate.didReceiveCricResults(.matches, inningsId: nil, matchId: nil,  results: results)
                        
                        
                    }
                }
            } catch {
                print("error getting matches")
            }
        })
        task.resume()
    }
    
    open func getOldMatches() {
        let cricApiKeys = getApiKeys()
        
        let httpHeaderValue = cricApiKeys.object(forKey: "apiKey") as! String
        let HTTPAdditionalHeaders = ["apikey" : httpHeaderValue ]
        config.httpAdditionalHeaders = HTTPAdditionalHeaders
        
        let liveURLString = cricApiKeys.object(forKey: "oldMatches") as! String
        let liveMatchesURL = URL(string: liveURLString)
        let session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: liveMatchesURL!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                //TO DO
                print(error?.localizedDescription ?? "error getting session")
            }
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    if let results: NSArray = jsonResult["matches"] as? NSArray {
                        self.delegate.didReceiveCricResults(.oldMatches, inningsId: nil, matchId: nil,  results: results)
                    }
                }
            } catch {
                print("error getting matches")
            }
        })
        task.resume()
    }
    
    
    
    
    func getApiKeys() -> NSDictionary {
        let keysFile = Bundle.main.path(forResource: "keys", ofType: "plist")
        let keys = NSDictionary(contentsOfFile: keysFile!)
        
        return keys?.object(forKey: "cricapi") as! NSDictionary
    }
    
}

