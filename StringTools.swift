//
//  StringTools.swift
//  
//  字符串处理的函数集
//
//  Created by 姬鹏 on 2017/3/20.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import Foundation
import UIKit

// 得到准备在某个指定的尺寸下显示的一个字符串，实际需要的行数
func getLinesForString(_ string: String, fontFamily font: UIFont, currentWidth width: CGFloat, singleHeight height: CGFloat) -> Int {
    let c = NSMutableAttributedString(string: string, attributes: [NSFontAttributeName: font])
    
    let s = CGSize(width: width, height: CGFloat(MAXFLOAT))
    let r = c.boundingRect(with: s, options: .usesLineFragmentOrigin, context: nil)
    
    if r.size.height <= height {
        return 1
    } else {
        return Int(r.size.height / height)
    }
}

// 为字符串得到指定字体、颜色的attributed string
func getAttributedString(_ string: String, fontFamily font: UIFont, fontColor color: UIColor) -> NSMutableAttributedString {
    let c = NSMutableAttributedString(string: string, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: color])
    
    return c
}

/// 将指定特定时间的整型数字转换成“yyyy/MM/dd”格式
/// deprecated
/// - Parameter date: 日期
/// - Returns: 格式化后的字符串
func convertDateToCNDateFormat(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    formatter.dateFormat = "yyyy/MM/dd"
    let dateString = formatter.string(from: date)
    
    return dateString
}


/// 格式化时间
///
/// - Parameters:
///   - date: 时间
///   - pattern: 格式化模式
/// - Returns: 格式化后的字符串
func convertDateToString(_ date: Date, pattern: String!) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = pattern
    let dateString = formatter.string(from: date)
    
    return dateString
}


/// 字符串转换成时间
///
/// - Parameters:
///   - dateString: 时间字符串
///   - pattern: 转换模式
/// - Returns: 转换后的日期
func convertStringToDate(_ dateString: String, pattern: String!) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = pattern
    let date = formatter.date(from: dateString)
    
    return date
}


























