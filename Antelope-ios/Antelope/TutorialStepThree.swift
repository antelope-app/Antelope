//
//  TutorialStepThree.swift
//  AdShield
//
//  Created by Jae Lee on 9/3/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class TutorialStepThree: TutorialStep {
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var header: UITextView!
    //@IBOutlet weak var switchImage: UIImageView!
    @IBOutlet weak var buttonLabel: UILabel!
    //@IBOutlet weak var waitNotification: UITextView!
    
    var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let grayColor: UIColor = UIColor(netHex: 0x4d4d4d)
        
        self.nextButton.backgroundColor = colorKit.white
        self.nextButton.setTitleColor(grayColor, forState: UIControlState.Normal)
        self.nextButton.layer.cornerRadius = 20.0
        self.view.backgroundColor = grayColor
        
        self.view.addSubview(nextButton)
        self.view.addSubview(header)
        
        self.constrainButton(nextButton)
        self.constrainHeader(header)
        
        print("setting video path")
        let path = NSBundle.mainBundle().pathForResource("iphone-settings", ofType:"mp4")
        let url = NSURL.fileURLWithPath(path!)
        
        print("setting player")
        player = AVPlayer(URL: url)
        let playerController = AVPlayerViewController()
        
        print("setting controller")
        playerController.player = player
        self.addChildViewController(playerController)
        self.view.addSubview(playerController.view)
        
        playerController.view.frame.size = CGSizeMake(250, 250)
        playerController.view.center.x = self.view.center.x
        playerController.view.center.y = self.view.center.y
        
        print("prepare to play")
        
        print(playerController.view.subviews.count)
        
        self.delay(1.0, closure: {
            self.player.play()
        })
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "restartVideo",
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object: player.currentItem)
        
        self.view.layoutSubviews()
        
        //self.waitNotification.frame.origin.y = self.nextButton.frame.origin.y + self.nextButton.frame.size.height + 10
    }
    
    func restartVideo() {
        //create a CMTime for zero seconds so we can go back to the beginning
        let seconds : Int64 = 0
        let preferredTimeScale : Int32 = 1
        let seekTime : CMTime = CMTimeMake(seconds, preferredTimeScale)
        
        player.seekToTime(seekTime)
        
        player.play()
    }
    
    @IBAction func nextStep(sender: UIButton) {
        delegate.finishTutorial()
    }
    
    func initialize() {
    }
}