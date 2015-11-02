//
//  User.swift
//  Antelope
//
//  Created by Jae Lee on 10/31/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import Foundation

class User: NSObject {
    var id: Int!
    var device_id: String!
    var created_at: String!
    var device_apn_token: String!
    var trial_period: Bool!
    var aborting: Bool = false
    
    func initFromData(data: NSData) -> User {
        do {
            if let results: NSDictionary! = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary {
                
                if let id = results["id"] as? Int {
                    self.id = id
                }
                
                if let device_id = results["device_id"] as? String {
                    self.device_id = device_id
                }
                
                if let created_at = results["created_at"] as? String {
                    self.created_at = created_at
                }
                
                if let device_apn_token = results["device_apn_token"] as? String {
                    self.device_apn_token = device_apn_token
                }
                
                if let trial_period = results["trial_period"] {
                    self.trial_period = trial_period.boolValue
                }
            }
        } catch {
            print("failed")
        }
        
        return self
    }
    
    func getByDeviceId(completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> User {
        let device_id: String! = UIDevice().identifierForVendor?.UUIDString
        print("User: getting by device id", device_id)
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Constants.SERVER_DOMAIN)/users/trial_status/\(device_id)")!)
        request.HTTPMethod = "GET"
        
        let urlSession = NSURLSession.sharedSession()
        let sessionTask = urlSession.dataTaskWithRequest(request, completionHandler: completionHandler)
        
        sessionTask.resume()
        
        return self
    }
}