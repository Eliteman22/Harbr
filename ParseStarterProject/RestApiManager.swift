//
//  RestApiManager.swift
//  Harbr
//
//  Created by Flavio Lici on 8/8/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation

var urlLocation: String!

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    
    static let apiKey = "AIzaSyB_2cbkTPb9LrPU2d9bPoC3ufLSiHFKBNk"
    static let radius = 100
    
    let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(urlLocation)&radius=\(radius)&key=\(apiKey)&sensor=true"
    
    func getRandomUser(onCompletion: (JSON) -> Void) {
        let route = baseURL
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let json:JSON = JSON(data: data)
            onCompletion(json, error)
        })
        task.resume()
    }
}