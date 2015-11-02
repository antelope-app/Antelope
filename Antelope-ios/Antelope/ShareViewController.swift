//
//  ShareViewController.swift
//  Antelope
//
//  Created by Adam Gluck on 9/9/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import Foundation
import FBSDKMessengerShareKit
import MessageUI

protocol ShareFlowDelegate {
    func didShareWithSuccess()
}

class ShareViewController : UIViewController, MessageComposerDelegate {
    var colorKit: AntelopeColors = AntelopeColors()
    var tutorialStep = TutorialStep()
    var delegate: ShareFlowDelegate!
    
    var imageURL: NSURL = NSURL(string: "https://i.imgur.com/v8HFwYG.png")!
    var fbShareDescription: String = "Antelope blocks ads and trackers in Safari, making sites load up to 50% faster. It's a free app for your iPhone or iPad, and it's open-source."
    var fbShareTitle: String = "Antelope - free adblocker."
    var fbShareImage: UIImageView!
    
    var sendButton: UIButton!
    
    var fbMessageDialog: FBSDKMessageDialog!
    var textMessageDialog: MFMessageComposeViewController!
    
    var messageComposer: MessageComposer!
    
    var visible: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("share view controller view did load")
        
        self.view.backgroundColor = colorKit.white
        
        handleLayout()
        
        present()
        
        let content = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: "http://www.getantelope.com/")
        content.contentTitle = self.fbShareTitle
        content.contentDescription = self.fbShareDescription
        content.imageURL = self.imageURL
        
        setupSharing(content)
    }
    
    func present() {
        if self.visible == nil || self.visible == false {
            self.view.frame.origin.y = self.view.frame.size.height
            UIView.animateWithDuration(0.3, animations: {
                self.view.frame.origin.y = 0
                }, completion: { (value: Bool) in
                    self.visible = true
            })
        }
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleLayout() {
        
        // TODO: add content.imageUrl for a nice shareable image
        
        let topFrame = UIView()
        topFrame.frame = CGRectMake(0, 0, self.view.frame.size.width, 0)
        topFrame.backgroundColor = colorKit.teal
        self.view.addSubview(topFrame)
        
        var redoButton: UIButton = UIButton()
        redoButton.setTitle("SEE STEPS AGAIN", forState: UIControlState.Normal)
        redoButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        redoButton = tutorialStep.borderButtonStyle(redoButton, options: [ "color" : "white" ])
        
        redoButton.frame.size = CGSizeMake(200, 40)
        redoButton.center.x = self.view.center.x
        redoButton.center.y = (topFrame.frame.size.height / 2)
        //self.view.addSubview(redoButton)
        
        //redoButton.addTarget(self, action: "restartTutorial", forControlEvents: UIControlEvents.TouchUpInside)
        
        fbShareImage = UIImageView()
        fbShareImage.frame.size = CGSizeMake(100, 100)
        fbShareImage.center.y = topFrame.frame.size.height + (self.view.frame.size.height - topFrame.frame.size.height) / 2
        fbShareImage.frame.origin.x = self.view.center.x - fbShareImage.frame.size.width - 45
        fbShareImage.contentMode = UIViewContentMode.ScaleAspectFill
        let image = UIImage(named: "antelope-green-large.png")
        fbShareImage.image = image
        self.view.addSubview(fbShareImage)
        
        let shareHeader: UITextView = UITextView()
        shareHeader.frame.size = CGSizeMake(280, 120)
        shareHeader.center.x = self.view.center.x
        shareHeader.center.y = fbShareImage.frame.origin.y - (fbShareImage.frame.origin.y - topFrame.frame.size.height) / 2
        
        shareHeader.textColor = colorKit.charcoal
        shareHeader.text = "Your trial is over. Please share this video with 1 friend to keep using Antelope."
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 12
        let headerAttributes = [NSParagraphStyleAttributeName: style, NSFontAttributeName: UIFont.systemFontOfSize(18.0)]
        shareHeader.attributedText = NSAttributedString(string: shareHeader.text, attributes: headerAttributes)
        shareHeader.textColor = colorKit.charcoal
        shareHeader.textAlignment = NSTextAlignment.Center
        shareHeader.userInteractionEnabled = false
        self.view.addSubview(shareHeader)
        
        let fbShareTitle = UITextView()
        fbShareTitle.frame.size = CGSizeMake(self.view.frame.size.width - (fbShareImage.frame.origin.x * 2) - fbShareImage.frame.size.width - 10, 35)
        fbShareTitle.frame.origin.x = self.view.center.x - 35
        fbShareTitle.frame.origin.y = fbShareImage.frame.origin.y - 10
        fbShareTitle.text = self.fbShareTitle
        let titleAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(14.0)]
        fbShareTitle.attributedText = NSAttributedString(string: fbShareTitle.text, attributes: titleAttributes)
        fbShareTitle.textColor = colorKit.charcoal
        fbShareTitle.userInteractionEnabled = false
        self.view.addSubview(fbShareTitle)
        
        let fbShareText = UITextView()
        fbShareText.frame.size = CGSizeMake(self.view.frame.size.width - (fbShareImage.frame.origin.x * 2) - fbShareImage.frame.size.width - 10, 150)
        fbShareText.frame.origin.x = self.view.center.x - 35
        fbShareText.frame.origin.y = fbShareImage.frame.origin.y + fbShareTitle.frame.size.height - 15
        fbShareText.text = self.fbShareDescription
        let textStyle = NSMutableParagraphStyle()
        textStyle.lineSpacing = 3
        let attributes = [NSParagraphStyleAttributeName: textStyle, NSFontAttributeName: UIFont.systemFontOfSize(11.0)]
        fbShareText.attributedText = NSAttributedString(string: fbShareText.text, attributes: attributes)
        fbShareText.textColor = colorKit.charcoal
        fbShareText.userInteractionEnabled = false
        self.view.addSubview(fbShareText)
        
    }
    
    func setupSharing(content: FBSDKShareLinkContent) {
        sendButton = UIButton()
        sendButton.frame.size = CGSizeMake(240, 45)
        sendButton.titleLabel?.textAlignment = NSTextAlignment.Center
        sendButton.titleLabel?.font = UIFont.systemFontOfSize(16.0)
        
        //let messengerImage = UIImage(named: "fb-messenger.png")
        //sendButton.setImage(messengerImage, forState: UIControlState.Normal)
        sendButton.backgroundColor = UIColor.whiteColor()
        
        sendButton.layer.borderColor = colorKit.teal.CGColor
        sendButton.layer.borderWidth = 2
        sendButton.layer.cornerRadius = 3
        
        sendButton.setTitleColor(colorKit.teal, forState: UIControlState.Normal)
        sendButton.center.x = self.view.center.x
        sendButton.center.y = self.view.frame.size.height - (self.view.frame.size.height - (fbShareImage.frame.origin.y + fbShareImage.frame.size.height)) / 2
        sendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        
        messageComposer = MessageComposer()
        messageComposer.delegate = self
        
        if (messageComposer.canOpenFbMessenger()) && false {
            
            fbMessageDialog = messageComposer.configuredFbMessageDialogWithContent(content)
            
            sendButton.setTitle("Send via Messenger", forState: UIControlState.Normal)
            sendButton.addTarget(self, action: "openMessenger", forControlEvents: .TouchUpInside)
            
        } else if (messageComposer.canSendText()) {
            print("NO MESSENGER")
            
            self.textMessageDialog = messageComposer.configuredMessageComposeViewControllerWithMessage(self.fbShareDescription)
            
            sendButton.setTitle("Send via iMessage", forState: UIControlState.Normal)
            sendButton.addTarget(self, action: "openMessages", forControlEvents: .TouchUpInside)
        } else {
            print("can do neither")
            let errorAlertController = UIAlertController(title: "Cannot send text message", message: "Your device is not able to send text messages at the moment", preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            errorAlertController.addAction(defaultAction)
            self.presentViewController(errorAlertController, animated: true, completion: nil)
        }
        
        self.view.addSubview(sendButton)
    }
    
    func openMessenger() {
        fbMessageDialog.show()
    }
    
    func openMessages() {
        print("opening messages")
        self.presentViewController(textMessageDialog, animated: true, completion: nil)
    }
    
    func didFinishWithSuccess() {
        print("did send message")
        
        delegate.didShareWithSuccess()
        
        self.dismiss()
    }
    
    func restartTutorial() {
        //delegate.restartTutorial()
    }
}