//
//  UIColorExtend.swift
//  LDCalendarSwift
//
//  Created by lidi on 11/18/15.
//  Copyright © 2015 lidi. All rights reserved.
//

import UIKit

class UIColorExtend: NSObject {

}

extension UIColor {
    convenience init(hexString: String) {
        let hexString = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let scanner   = NSScanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        
        if scanner.scanHexInt(&color) {
            self.init(hex: color)
        }
        else {
            self.init(hex: 0x000000)
        }
    }

    /**
     Creates a color from an hex integer.
     
     - parameter hex: A hexa-decimal UInt32 that represents a color.
     */
    convenience init(hex: UInt32) {
        let mask = 0x000000FF
        
        let r = Int(hex >> 16) & mask
        let g = Int(hex >> 8) & mask
        let b = Int(hex) & mask
        
        let red   = CGFloat(r) / 255
        let green = CGFloat(g) / 255
        let blue  = CGFloat(b) / 255
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
}

//extension UIColor {
//    public static func hex(hex: Int) -> UIColor {
//        let red   = CGFloat(((hex & 0xFF0000) >> 16)) / 255
//        let green = CGFloat(((hex & 0xFF00) >> 8)) / 255
//        let blue  = CGFloat((hex & 0xFF)) / 255
//
//        return UIColor(red: red, green: green, blue: blue, alpha: 1)
//    }
//}