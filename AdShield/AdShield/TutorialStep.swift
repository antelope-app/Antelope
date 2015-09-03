//
//  TutorialStep.swift
//  AdShield
//
//  Created by Jae Lee on 9/2/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import UIKit

class TutorialStep: UIViewController
{
    var colorKit = AdShieldColors()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    func primaryButtonStyle(button: UIButton) -> UIButton {
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 2
        button.layer.borderColor = colorKit.teal.CGColor
        button.setTitleColor(colorKit.teal, forState: UIControlState.Normal)
        
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
    
    func delay(delay:Double, closure:()->())
    {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}
