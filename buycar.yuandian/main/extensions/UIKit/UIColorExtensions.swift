//
//  UIColorExtensions.swift
//  buycar.yuandian
//
//  Created by 李萌 on 2019/2/28.
//  Copyright © 2019年 tymaker. All rights reserved.
//

import UIKit

extension UIColor {
    
    public class func mi_rgb(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a);
    }
    
    public class func mi_hex(_ hexString: String, alpha: CGFloat = 1.0) -> UIColor? {
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
            let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
            return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            return nil
        }
    }
    
}
