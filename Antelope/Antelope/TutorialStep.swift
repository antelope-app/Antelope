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
    
    var topBuffer: CGFloat = 0.0
    var bottomBuffer: CGFloat = 0.0
    
    var bottomLayoutConstraint: NSLayoutConstraint!
    var topLayoutConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewHeight = self.view.frame.size.height
        if viewHeight >= 667.0 {
            topBuffer = 100.0
            bottomBuffer = 100.0
        } else {
            topBuffer = 70.0
            bottomBuffer = 50.0
        }
    }
    
    func constrainHeader(header: UITextView) {
        topLayoutConstraint = NSLayoutConstraint(item: header, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: topBuffer)
        
        view.addConstraint(topLayoutConstraint)
    }
    
    func constrainButton(button: UIButton) {
        bottomLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -bottomBuffer)
        
        view.addConstraint(bottomLayoutConstraint)
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
        
        button.frame.size = CGSizeMake(200.0, 40.0)
        
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
