//
//  SystemTools.swift
//  
//  系统应用的函数集
//
//  Created by 姬鹏 on 2017/3/21.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import Foundation

// 导致closure中的代码延迟到主线程完成后再执行
func delay(_ delay: Double, closure: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

// 获取时间戳
func getTimeStamp() -> Int {
    let now = Date()
    let timeStamp = now.timeIntervalSince1970
    return Int(timeStamp)
}

// 取得随机数
func getRandomSuffix(length: UInt?) -> UInt32 {
    if let len = length {
        var maxVal:UInt32 = 10
        for _ in 0..<len {
            maxVal *= 10
        }
        return arc4random_uniform(maxVal)
    }
    return arc4random_uniform(1000)
}
