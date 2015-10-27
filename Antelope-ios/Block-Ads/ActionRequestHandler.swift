//
//  ActionRequestHandler.swift
//  Block Ads
//
//  Created by Adam Gluck on 8/30/15.
//  Copyright © 2015 Antelope. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {
    var preferences: NSUserDefaults!

    func beginRequestWithExtensionContext(context: NSExtensionContext) {
        if let preferences = NSUserDefaults.init(suiteName: Constants.APP_GROUP_ID) {
            
            let blockerFileString: String!
            if !preferences.boolForKey(Constants.BLOCKER_PERMISSION_KEY) {
                blockerFileString = "noopList"
            } else {
                blockerFileString = "blockerList"
            }
            
            let attachment = NSItemProvider(contentsOfURL: NSBundle.mainBundle().URLForResource(blockerFileString, withExtension: "json"))!
            
            let item = NSExtensionItem()
            item.attachments = [attachment]
            
            print("begin")
            context.completeRequestReturningItems([item]) { (expired) -> Void in
                if expired == true {
                    print("expired")
                } else {
                    print("not expired")
                }
            }
        }
        
    }
    
}
