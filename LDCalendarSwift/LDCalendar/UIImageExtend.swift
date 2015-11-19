//
//  UIImageExtend.swift
//  LDCalendarSwift
//
//  Created by lidi on 11/19/15.
//  Copyright © 2015 lidi. All rights reserved.
//

import UIKit

class UIImageExtend: NSObject {

}

private let kImageWidth  = 1.0
private let kImageHeight = 1.0

extension UIImage {
    public static func imageWithColor(color:UIColor) -> UIImage {
        return self.imageWithColor(color, size: CGSizeMake(CGFloat(kImageWidth), CGFloat(kImageHeight)))
    }
    
    public static func imageWithColor(color:UIColor, size:CGSize) -> UIImage {
        let rect:CGRect          = CGRectMake(0, 0, size.width, size.height)

        UIGraphicsBeginImageContext(size)
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)

        let image:UIImage        = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}