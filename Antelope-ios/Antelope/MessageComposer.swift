//
//  MessageComposer.swift
//  Antelope
//
//  Created by Jae Lee on 10/18/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import Foundation
import FBSDKMessengerShareKit
import MessageUI

protocol MessageComposerDelegate {
    func didFinishWithSuccess()
}

class MessageComposer: NSObject, FBSDKSharingDelegate, MFMessageComposeViewControllerDelegate {
    
    var delegate: MessageComposerDelegate!
    
    // A wrapper function to indicate whether or not a text message can be sent from the user's device
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    func canOpenFbMessenger() -> Bool {
        let messengerUrl: NSURL = NSURL(string:"fb-messenger-api:/")!
        return UIApplication.sharedApplication().canOpenURL(messengerUrl)
    }
    
    // Configures and returns a MFMessageComposeViewController instance
    func configuredMessageComposeViewControllerWithData(message: String, videoData: NSData) -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        messageComposeVC.body = message
        messageComposeVC.addAttachmentData(videoData, typeIdentifier: "mp4", filename: "share-video.mp4")
        return messageComposeVC
    }
    
    func configuredFbMessageDialogWithContent(content: FBSDKShareLinkContent) -> FBSDKMessageDialog {
        let messageDialog = FBSDKMessageDialog()
        messageDialog.delegate = self
        messageDialog.shareContent = content
        
        return messageDialog
    }
    
    // MFMessageComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        print(result.rawValue)
        
        if (result.rawValue == 1) {
            delegate.didFinishWithSuccess()
        }
    }
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject: AnyObject]) {
        print("did share", results)
        
        delegate.didFinishWithSuccess()
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        print("sharer NSError")
        print(error.description)
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        print("sharerDidCancel")
    }
}
