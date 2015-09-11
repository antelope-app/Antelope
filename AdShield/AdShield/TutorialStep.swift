//
//  TutorialStep.swift
//  Antelope
//
//  Created by Jae Lee on 9/2/15.
//  Copyright © 2015 Antelope. All rights reserved.
//

import UIKit

protocol TutorialStepDelegate {
    func nextStep(index: NSInteger)
    func finishTutorial()
}

class TutorialStep: UIViewController {
    var colorKit = AntelopeColors()
    var delegate: TutorialStepDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func borderButtonStyle(button: UIButton, options: NSDictionary) -> UIButton {
        
        if options["color"] as? String == "teal" {
            button.layer.borderColor = colorKit.teal.CGColor
            button.setTitleColor(colorKit.teal, forState: UIControlState.Normal)
        }
        else if options["color"] as? String == "white" {
            button.layer.borderColor = colorKit.white.CGColor
            button.setTitleColor(colorKit.white, forState: UIControlState.Normal)
        }
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 2
        
        
        return button
    }
    
    func paragraphStyle(text: UITextView) -> UITextView {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        let attributes = [NSParagraphStyleAttributeName: style, NSFontAttributeName: UIFont.systemFontOfSize(16)]
        text.attributedText = NSAttributedString(string: text.text, attributes: attributes)
        text.textColor = UIColor.lightGrayColor()
        text.textAlignment = NSTextAlignment.Center
        
        return text
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}
