//
//  ShareViewController.swift
//  Antelope
//
//  Created by Adam Gluck on 9/9/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import Foundation


class ShareViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureShareButton()
    }
    
    
    func configureShareButton() {
        let content = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: "http://www.getantelope.com/")

        // TODO: add content.imageUrl for a nice shareable image
        
        let shareButton = FBSDKShareButton()
        shareButton.shareContent = content
        shareButton.center = self.view.center
        self.view.addSubview(shareButton)
    }
}