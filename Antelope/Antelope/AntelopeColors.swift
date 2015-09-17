//
//  AntelopeColors.swift
//  Antelope
//
//  Created by Jae Lee on 9/2/15.
//  Copyright © 2015 Antelope. All rights reserved.
//

import UIKit

class AntelopeColors {
    var red: UIColor = UIColor.redColor()
    var white: UIColor = UIColor.whiteColor()
    var veryLightGrey: UIColor = UIColor(netHex: 0xcccccc)
    var charcoal: UIColor = UIColor(netHex: 0x525252)
    var teal: UIColor = UIColor(netHex: 0x75bfa4)
    var yellow: UIColor = UIColor(netHex: 0x4d4d4d)
    var magenta: UIColor = UIColor(netHex: 0xef6586)
    var orange: UIColor = UIColor(netHex: 0xe08648)
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}