//
//  CBService.swift
//  caughtnbowled
//
//  Created by Ezra Bathini on 16/10/15.
//  Copyright © 2015 Ezra Bathini. All rights reserved.
//

import Foundation
public protocol BowledServiceProtocol {
    func didReceiveResults(_ requestType: RequestType, results: NSObject)
    func didReceiveImageResults(_ data: Data)
}


public enum RequestType {
    case matches
    case matchDetail
    case scorecard
    case commentary
    case teamPlayers
    case matchPlayers
    case partnerships
    case imageResource
    case seriesStandings
}

open class BowledService {
    var delegate: BowledServiceProtocol
    
    
    public init(delegate: BowledServiceProtocol) {
        self.delegate = delegate
    }
    
    let dictionary = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "keys", ofType: "plist")!)
    let config = URLSessionConfiguration.default
    
    
    open func getMatches() {

        let httpHeaderValue = dictionary?.object(forKey: "X-Mashape-Key") as! String
        let HTTPAdditionalHeaders = ["X-Mashape-Key" : httpHeaderValue ]
        config.httpAdditionalHeaders = HTTPAdditionalHeaders
        let liveURLString = dictionary?.object(forKey: "allMatchesURLString") as! String
        let liveMatchesURL = URL(string: liveURLString)
        let session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: liveMatchesURL!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                //TO DO
                print(error?.localizedDescription)
            }
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    if let matchList: NSDictionary = jsonResult["matchList"] as? NSDictionary {
                        if let results: NSArray = matchList["matches"] as? NSArray {
                            self.delegate.didReceiveResults(.matches, results: results)
                        }
                    }
                }
            } catch {
                print("error getting matches")
            }
        })
        
        task.resume()
        
        
    }
    
    open func getTeamPlayers(_ teamid: NSNumber ) {

        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let httpHeaderValue = dictionary?.object(forKey: "X-Mashape-Key") as! String
        let teamPlayersURLString = dictionary?.object(forKey: "teamPlayersURLString") as! String
        var URL = Foundation.URL(string: teamPlayersURLString)
        let URLParams = [
            "teamid": "\(teamid)",
        ]
        URL = self.NSURLByAppendingQueryParameters(URL, queryParameters: URLParams)
        var request = URLRequest(url: URL!)
        request.httpMethod = "GET"
        request.addValue(httpHeaderValue, forHTTPHeaderField: "X-Mashape-Key")
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error ) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                do {
                    
                    
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        
                        if let teamPlayers: NSDictionary = jsonResult["teamPlayers"] as? NSDictionary {
                            
                            if let results: NSArray = teamPlayers["players"] as? NSArray {
                                self.delegate.didReceiveResults(.teamPlayers, results: results)
                            }
                        }
                        
                    }
                } catch {
//                    print("error")
                }
            }
            else {
                // Failure
//                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        
        
        task.resume()
        
        
    }
    
    open func getMatchPlayers(_ matchid: NSNumber, seriesid: NSNumber ) {
        
        print("..getting match players... 1 ..")
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let httpHeaderValue = dictionary?.object(forKey: "X-Mashape-Key") as! String
        let teamPlayersURLString = dictionary?.object(forKey: "matchPlayersURLString") as! String
        
        var URL = Foundation.URL(string: teamPlayersURLString)
        let URLParams = [
            "matchid": "\(matchid)",
            "seriesid": "\(seriesid)",
        ]
        URL = self.NSURLByAppendingQueryParameters(URL, queryParameters: URLParams)
        var request = URLRequest(url: URL!)
        request.httpMethod = "GET"
        request.addValue(httpHeaderValue, forHTTPHeaderField: "X-Mashape-Key")
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error ) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        
                       
                        if let matchPlayers = jsonResult["playersInMatch"] as? NSDictionary {
                            self.delegate.didReceiveResults(.matchPlayers, results: matchPlayers)
                            
                           
                        }
                        
                    }
                } catch {
//                    print("error")
                }
            }
            else {
                // Failure
//                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        
        
        task.resume()
        
        
    }
    
    open func getScoreCard(_ matchid: NSNumber, seriesid: NSNumber ) {

        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let httpHeaderValue = dictionary?.object(forKey: "X-Mashape-Key") as! String
        let scorecardURLString = dictionary?.object(forKey: "scorecardURLString") as! String
        
        var URL = Foundation.URL(string: scorecardURLString)
        let URLParams = [
            "matchid": "\(matchid)",
            "seriesid": "\(seriesid)",
        ]
        URL = self.NSURLByAppendingQueryParameters(URL, queryParameters: URLParams)
        var request = URLRequest(url: URL!)
        request.httpMethod = "GET"
        request.addValue(httpHeaderValue, forHTTPHeaderField: "X-Mashape-Key")
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error ) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        
                        if let results: NSDictionary = jsonResult {
                            
                            self.delegate.didReceiveResults(.scorecard, results: results)
                        }
                    }
                } catch {
//                    print("error")
                }
            }
            else {
                // Failure
//                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        
        
        task.resume()
        
        
    }
    
    
    open func getSeriesStandings(_ seriesid: NSNumber ) {
        /* Configure session, choose between:
        * defaultSessionConfiguration
        * ephemeralSessionConfiguration
        * backgroundSessionConfigurationWithIdentifier:
        And set session-wide properties, such as: HTTPAdditionalHeaders,
        HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
        */
        let sessionConfig = URLSessionConfiguration.default
        
        /* Create session, and optionally set a NSURLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        let httpHeaderValue = dictionary?.object(forKey: "X-Mashape-Key") as! String
        
        let seriesStandingsURLString = dictionary?.object(forKey: "seriesStandingsURLString") as! String
        
        var URL = Foundation.URL(string: seriesStandingsURLString)
        let URLParams = [
            "seriesid": "\(seriesid)",
        ]
        URL = self.NSURLByAppendingQueryParameters(URL, queryParameters: URLParams)
        var request = URLRequest(url: URL!)
        request.httpMethod = "GET"
        
        // Headers
        
        request.addValue(httpHeaderValue, forHTTPHeaderField: "X-Mashape-Key")
        
        /* Start a new Task */
        
        
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error ) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                do {
                    
                    
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        
                        if let results: NSDictionary = jsonResult {
                            
                            self.delegate.didReceiveResults(.seriesStandings, results: results)
                        }
                    }
                } catch {
//                    print("error")
                }
            }
            else {
                // Failure
//                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        
        
        task.resume()
        
        
    }
    
    
    open func getMatchDetail(_ seriesid: NSNumber, matchid: NSNumber ) {
        /* Configure session, choose between:
        * defaultSessionConfiguration
        * ephemeralSessionConfiguration
        * backgroundSessionConfigurationWithIdentifier:
        And set session-wide properties, such as: HTTPAdditionalHeaders,
        HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
        */
        let sessionConfig = URLSessionConfiguration.default
        
        /* Create session, and optionally set a NSURLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        let httpHeaderValue = dictionary?.object(forKey: "X-Mashape-Key") as! String
        
        let matchDetailURLString = dictionary?.object(forKey: "matchDetailURLString") as! String
        
        var URL = Foundation.URL(string: matchDetailURLString)
        let URLParams = [
            "matchid": "\(matchid)",
            "seriesid": "\(seriesid)",
        ]
        URL = self.NSURLByAppendingQueryParameters(URL, queryParameters: URLParams)
        var request = URLRequest(url: URL!)
        request.httpMethod = "GET"
        
        // Headers
        
        request.addValue(httpHeaderValue, forHTTPHeaderField: "X-Mashape-Key")
        
        /* Start a new Task */
        
        
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error ) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode

                do {
                    
                    
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        
                        if let results: NSDictionary = jsonResult {
                            
                            self.delegate.didReceiveResults(.matchDetail, results: results)
                        }
                    }
                } catch {
//                    print("error")
                }
            }
            else {
                // Failure
//                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        
        
        task.resume()
        
        
    }
    
    open func getCommentary(_ matchid: NSNumber, seriesid: NSNumber) {
        
        let sessionConfig = URLSessionConfiguration.default
        
        /* Create session, and optionally set a NSURLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        let httpHeaderValue = dictionary?.object(forKey: "X-Mashape-Key") as! String
        
        let commentaryURLString = dictionary?.object(forKey: "commentaryURLString") as! String
        
        var URL = Foundation.URL(string: commentaryURLString)
        let URLParams = [
            "matchid": "\(matchid)",
            "seriesid": "\(seriesid)",
        ]
        
        
        URL = self.NSURLByAppendingQueryParameters(URL, queryParameters: URLParams)
        var request = URLRequest(url: URL!)
        request.httpMethod = "GET"
        

        
        request.addValue(httpHeaderValue, forHTTPHeaderField: "X-Mashape-Key")
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error ) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode

                do {
                    
                    
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        
                        if let results: NSDictionary = jsonResult {
                            
                            self.delegate.didReceiveResults(.commentary, results: results)
                        }
                    }
                } catch {
//                    print("error")
                }
            }
            else {
                // Failure
//                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
    }
    
    
    open func getPartnerships(_ matchid: NSNumber, seriesid: NSNumber, inniid: NSNumber ) {

        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        let httpHeaderValue = dictionary?.object(forKey: "X-Mashape-Key") as! String
        
        let scorecardURLString = dictionary?.object(forKey: "partnershipsURLString") as! String
        
        var URL = Foundation.URL(string: scorecardURLString)
        let URLParams = [
            "matchid": "\(matchid)",
            "seriesid": "\(seriesid)",
            "innid": "\(inniid)"
        ]
        URL = self.NSURLByAppendingQueryParameters(URL, queryParameters: URLParams)
        var request = URLRequest(url: URL!)
        request.httpMethod = "GET"
        
        // Headers
        
        request.addValue(httpHeaderValue, forHTTPHeaderField: "X-Mashape-Key")
        
        /* Start a new Task */
        
        
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error ) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                do {
                    
                    
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        
                        if let results: NSDictionary = jsonResult {
                            
                            self.delegate.didReceiveResults(.partnerships, results: results)
                        }
                    }
                } catch {
//                    print("error")
                }
            }
            else {
                // Failure
//                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        
        
        task.resume()
        
        
    }
    
    open func getImageResource(_ imageUrl: String) {
        

        
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        let httpHeaderValue = dictionary?.object(forKey: "X-Mashape-Key") as! String
        
        let resoursesURLString = dictionary?.object(forKey: "resoursesURLString") as! String
        
        var URL = Foundation.URL(string: resoursesURLString)
        let URLParams = [
            "imageUrl": "\(imageUrl)"
        ]
        URL = self.NSURLByAppendingQueryParameters(URL, queryParameters: URLParams)
        var request = URLRequest(url: URL!)
        request.httpMethod = "GET"
        
        // Headers
        
        request.addValue(httpHeaderValue, forHTTPHeaderField: "X-Mashape-Key")
        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        
        /* Start a new Task */
        
//        print(URL)
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: NSError?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
//                print("URL Session Task Succeeded: HTTP \(statusCode)")
                if let img = UIImage(data: data!) {
//                    print("image....")
                }
//                print(data!)
                self.delegate.didReceiveResults(.imageResource, results: data! as NSObject)
            }
            else {
                // Failure
//                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        } as! (Data?, URLResponse?, Error?) -> Void)
        task.resume()
        
        
    }
    

    
    
    
    /**
    This creates a new query parameters string from the given NSDictionary. For
    example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
    string will be @"day=Tuesday&month=January".
    @param queryParameters The input dictionary.
    @return The created parameters string.
    */
    func stringFromQueryParameters(_ queryParameters : Dictionary<String, String>) -> String {
        var parts: [String] = []
        for (name, value) in queryParameters {
            let part = NSString(format: "%@=%@",
                name.addingPercentEscapes(using: String.Encoding.utf8)!,
                value.addingPercentEscapes(using: String.Encoding.utf8)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
    /**
    Creates a new URL by adding the given query parameters.
    @param URL The input URL.
    @param queryParameters The query parameter dictionary to add.
    @return A new NSURL.
    */
    func NSURLByAppendingQueryParameters(_ URL : Foundation.URL!, queryParameters : Dictionary<String, String>) -> Foundation.URL {
        let URLString : NSString = NSString(format: "%@?%@", URL.absoluteString, self.stringFromQueryParameters(queryParameters))
        
        return Foundation.URL(string: URLString as String)!
    }
    


}
