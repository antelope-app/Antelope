//
//  ShareViewController.swift
//  Antelope
//
//  Created by Adam Gluck on 9/9/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import Foundation

protocol ShareViewDelegate {
    func restartTutorial()
}

class ShareViewController : UIViewController {
    var colorKit: AntelopeColors = AntelopeColors()
    var tutorialStep = TutorialStep()
    var delegate: ShareViewDelegate!
    
    var imageURL: NSURL = NSURL(string: "https://i.imgur.com/v8HFwYG.png")!
    var fbShareDescription: String = "Antelope tells Safari on your iPhone or iPad not to download ads and trackers, making sites load up to 50% faster. The app is open-source and free."
    var fbShareTitle: String = "Antelope -- make Safari faster."
    var fbShareImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = colorKit.white
        
        handleLayout()
    }
    
    func handleLayout() {
        
        // TODO: add content.imageUrl for a nice shareable image
        
        let topFrame = UIView()
        topFrame.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 3)
        topFrame.backgroundColor = colorKit.teal
        self.view.addSubview(topFrame)
        
        var redoButton: UIButton = UIButton()
        redoButton.setTitle("SEE STEPS AGAIN", forState: UIControlState.Normal)
        redoButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        redoButton = tutorialStep.borderButtonStyle(redoButton, options: [ "color" : "white" ])
        
        redoButton.frame.size = CGSizeMake(200, 40)
        redoButton.center.x = self.view.center.x
        redoButton.center.y = (topFrame.frame.size.height / 2)
        self.view.addSubview(redoButton)
        
        redoButton.addTarget(self, action: "restartTutorial", forControlEvents: UIControlEvents.TouchUpInside)
        
        let fbShareImage = UIImageView()
        fbShareImage.frame.size = CGSizeMake(100, 100)
        fbShareImage.center.y = topFrame.frame.size.height + (self.view.frame.size.height - topFrame.frame.size.height) / 2
        fbShareImage.frame.origin.x = self.view.center.x - fbShareImage.frame.size.width - 30
        fbShareImage.contentMode = UIViewContentMode.ScaleAspectFill
        let image = UIImage(named: "antelope-green-large.png")
        fbShareImage.image = image
        self.view.addSubview(fbShareImage)
        
        let shareHeader: UITextView = UITextView()
        shareHeader.frame.size = CGSizeMake(240, 40)
        shareHeader.center.x = self.view.center.x
        shareHeader.center.y = fbShareImage.frame.origin.y - (fbShareImage.frame.origin.y - topFrame.frame.size.height) / 2
        shareHeader.textAlignment = NSTextAlignment.Center
        shareHeader.textColor = colorKit.charcoal
        shareHeader.font = UIFont.systemFontOfSize(22.0)
        shareHeader.text = "Or, share with friends."
        shareHeader.userInteractionEnabled = false
        self.view.addSubview(shareHeader)
        
        let fbShareText = UITextView()
        fbShareText.frame.size = CGSizeMake(self.view.frame.size.width - (fbShareImage.frame.origin.x * 2) - fbShareImage.frame.size.width - 10, 150)
        fbShareText.frame.origin.x = self.view.center.x - 25
        fbShareText.frame.origin.y = fbShareImage.frame.origin.y - 10
        fbShareText.text = self.fbShareDescription
        let textStyle = NSMutableParagraphStyle()
        textStyle.lineSpacing = 3
        let attributes = [NSParagraphStyleAttributeName: textStyle, NSFontAttributeName: UIFont.systemFontOfSize(11.0)]
        fbShareText.attributedText = NSAttributedString(string: fbShareText.text, attributes: attributes)
        fbShareText.textColor = colorKit.charcoal
        fbShareText.userInteractionEnabled = false
        self.view.addSubview(fbShareText)
        
        let content = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: "http://www.getantelope.com/")
        content.contentTitle = self.fbShareTitle
        content.contentDescription = self.fbShareDescription
        content.imageURL = self.imageURL
        
        let shareButton = FBSDKShareButton()
        shareButton.shareContent = content
        shareButton.center.x = self.view.center.x
        shareButton.center.y = self.view.frame.size.height - (self.view.frame.size.height - (fbShareImage.frame.origin.y + fbShareImage.frame.size.height)) / 2
        shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        self.view.addSubview(shareButton)
        
    }

    
    func restartTutorial() {
        delegate.restartTutorial()
    }
}