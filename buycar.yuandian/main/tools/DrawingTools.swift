//
//  DrawingTools.swift
//
//  与绘制相关的工具函数集
//
//  Created by 姬鹏 on 2017/3/21.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import Foundation
import UIKit

// 为传入的UIView或其子类绘制一个圆形边框
func drawRoundBorderForView(_ view: AnyObject!, borderRadius radius: CGFloat = 14.5, borderWidth width: CGFloat = 1, borderColor color: UIColor) -> AnyObject? {
    // 如果传入的对象不是UIView，则返回nil
    guard let v = view as? UIView else {
        return nil
    }
    
    // 无论View是否存在边框，均设置其边框
    v.layer.cornerRadius = radius
    v.layer.borderColor = color.cgColor
    v.layer.borderWidth = width
    v.layer.masksToBounds = true
    
    return v
}
