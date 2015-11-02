//
//  Constants.swift
//  Antelope
//
//  Created by Jae Lee on 10/27/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import Foundation

public struct Constants {
    static let REVERSE_DOMAIN_NAME = "com.antelope.Antelope-Ad-Blocker"
    static let APP_GROUP_ID = "group.\(REVERSE_DOMAIN_NAME)"
    static let DEFAULT_PREFERENCES_FILENAME = "Defaults"
    static let PREFERENCES_FILE_EXTENSION = "plist"
    static let DEVELOPMENT_SERVER_DOMAIN = "http://10.0.0.14:4000"
    static let PRODUCTION_SERVER_DOMAIN = "http://antelope-app.elasticbeanstalk.com"
    static let SERVER_DOMAIN = PRODUCTION_SERVER_DOMAIN
    
    static let TRIAL_ACTIVE_KEY = "TrialPeriodActive"
    static let BLOCKER_PERMISSION_KEY = "BlockerAllowed"
    static let DID_SHARE_KEY = "DidShare"
}
