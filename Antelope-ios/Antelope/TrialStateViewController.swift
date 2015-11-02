//
//  TrialStateViewController.swift
//  Antelope
//
//  Created by Jae Lee on 10/29/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import Foundation

protocol TrialStateViewControllerDelegate {
    func restartTutorial()
}

class TrialStateViewController : UIViewController {
    var colorKit: AntelopeColors = AntelopeColors()
    var tutorialStep = TutorialStep()
    var app: UIApplication = UIApplication.sharedApplication()
    
    var delegate: TrialStateViewControllerDelegate!
    
    var imageURL: NSURL = NSURL(string: "https://i.imgur.com/v8HFwYG.png")!
    
    var sendButton: UIButton!
    
    var countDown: UITextView!
    var countDownSubheader: UITextView!
    
    var visible: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("share view controller view did load")
        
        self.view.backgroundColor = colorKit.white
        self.view.frame = super.view.frame
        
        handleLayout()
        
        let appDelegate = app.delegate as! AppDelegate
        if !appDelegate.user.aborting {
            getTrialStatus()
        } else {
            self.updateCounter(0)
        }
        
        //present()
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
        if (self.visible != nil && self.visible == true) {
            self.view.frame.origin.y = 0
            UIView.animateWithDuration(0.3, animations: {
                self.view.frame.origin.y = self.view.frame.size.height
                }, completion: { (value: Bool) in
                    self.visible = false
            })
        }
    }
    
    func getTrialStatus() {
        let device_id: String! = UIDevice().identifierForVendor?.UUIDString
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Constants.SERVER_DOMAIN)/users/trial_status/\(device_id)")!)
        request.HTTPMethod = "GET"
        
        let urlSession = NSURLSession.sharedSession()
        let sessionTask = urlSession.dataTaskWithRequest(request, completionHandler: {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            else if data == nil {
                print("do something please")
                
                let standardDefaults = NSUserDefaults.standardUserDefaults()
                if let sharedDefaults = NSUserDefaults.init(suiteName: Constants.APP_GROUP_ID) {
                    
                    sharedDefaults.setBool(true, forKey: Constants.BLOCKER_PERMISSION_KEY)
                    standardDefaults.setBool(false, forKey: "TrialPeriodActive")
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.updateCounter(0)
                    })
                }
                return
            }
            else {
                do {
                    let results: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
                    
                    if let creationDate = dateFormatter.dateFromString(String(results["created_at"]!)) {
                        print(creationDate)
                        //let differenceInMinutes = self.getDifferenceInMinutesSince(creationDate)
                        let differenceInHours = self.getDifferenceInHoursSince(creationDate)
                        
                        print(differenceInHours)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.updateCounter(48 - differenceInHours)
                        })
                    }
                }
                catch {
                    print("failed")
                }
            }
        })
        
        sessionTask.resume()
    }
    
    func updateCounter(hoursLeft: Int) {
        print("updating counter")
        
        let appDelegate = app.delegate as! AppDelegate
        
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        if let preferences = NSUserDefaults.init(suiteName: Constants.APP_GROUP_ID) {
            if standardDefaults.boolForKey(Constants.DID_SHARE_KEY) || appDelegate.user.aborting {
                countDown.text = "Thanks for using Antelope!"
                
                if countDownSubheader != nil {
                    countDownSubheader.removeFromSuperview()
                }
            } else {
                countDown.text = "You have \(hoursLeft) hours left of the trial."
            }
        }
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 12
        let headerAttributes = [NSParagraphStyleAttributeName: style, NSFontAttributeName: UIFont.systemFontOfSize(20.0)]
        countDown.attributedText = NSAttributedString(string: countDown.text, attributes: headerAttributes)
        countDown.textAlignment = NSTextAlignment.Center
        countDown.userInteractionEnabled = false
        countDown.textColor = colorKit.charcoal
    }
    
    func handleLayout() {
        
        // TODO: add content.imageUrl for a nice shareable image
        
        let topFrame = UIView()
        topFrame.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 3)
        topFrame.backgroundColor = colorKit.teal
        self.view.addSubview(topFrame)
        
        var redoButton: UIButton = UIButton()
        redoButton.setTitle("REPLAY VIDEO", forState: UIControlState.Normal)
        redoButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        redoButton = tutorialStep.borderButtonStyle(redoButton, options: [ "color" : "white" ])
        
        redoButton.frame.size = CGSizeMake(200, 40)
        redoButton.center.x = self.view.center.x
        redoButton.center.y = (topFrame.frame.size.height / 2)
        self.view.addSubview(redoButton)
        
        let topFrameMargin = topFrame.frame.size.height
        let bottomFrameHeight = self.view.frame.size.height - topFrameMargin
        
        redoButton.addTarget(self, action: "restartTutorial", forControlEvents: UIControlEvents.TouchUpInside)
        
        countDown = UITextView()
        countDown.frame.size = CGSizeMake(280, 80)
        countDown.center.x = self.view.center.x
        countDown.frame.origin.y = topFrameMargin + (bottomFrameHeight / 3) - (countDown.frame.size.height / 2)
        
        countDown.text = ""
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 12
        let headerAttributes = [NSParagraphStyleAttributeName: style, NSFontAttributeName: UIFont.systemFontOfSize(20.0)]
        countDown.attributedText = NSAttributedString(string: countDown.text, attributes: headerAttributes)
        countDown.textColor = colorKit.charcoal
        countDown.textAlignment = NSTextAlignment.Center
        countDown.userInteractionEnabled = false
        self.view.addSubview(countDown)
        
        countDownSubheader = UITextView()
        countDownSubheader.frame.size = CGSizeMake(280, 80)
        countDownSubheader.center.x = self.view.center.x
        countDownSubheader.frame.origin.y = countDown.frame.origin.y + countDown.frame.size.height + 10
        
        countDownSubheader.text = "After that, we'll ask you to share with one friend via text"
        let styleSubheader = NSMutableParagraphStyle()
        styleSubheader.lineSpacing = 12
        let headerAttributesSubheader = [NSParagraphStyleAttributeName: styleSubheader, NSFontAttributeName: UIFont.systemFontOfSize(14.0)]
        countDownSubheader.attributedText = NSAttributedString(string: countDownSubheader.text, attributes: headerAttributesSubheader)
        countDownSubheader.textColor = colorKit.charcoal
        countDownSubheader.textAlignment = NSTextAlignment.Center
        countDownSubheader.userInteractionEnabled = false
        self.view.addSubview(countDownSubheader)
        
    }
    
    func restartTutorial() {
        delegate.restartTutorial()
    }
    
    func getDifferenceInMinutesSince(date: NSDate) -> Int {
        let currentDate = NSDate()
        let elapsedTime = NSCalendar.currentCalendar().components(NSCalendarUnit.Minute, fromDate: date, toDate: currentDate, options: []).minute
        
        return elapsedTime
    }
    
    func getDifferenceInHoursSince(date: NSDate) -> Int {
        let currentDate = NSDate()
        let elapsedTime = NSCalendar.currentCalendar().components(NSCalendarUnit.Hour, fromDate: date, toDate: currentDate, options: []).hour
        
        return elapsedTime
    }
}