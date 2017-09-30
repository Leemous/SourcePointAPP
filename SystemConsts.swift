//
//  SystemConsts.swift
//  
//  系统用到的所有常量
//
//  Created by 姬鹏 on 2017/3/20.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import Foundation
import UIKit

// 屏幕属性
public let screenWidth = UIScreen.main.bounds.size.width
public let screenHeight = UIScreen.main.bounds.size.height

// 主要颜色
public let systemTintColor = UIColor(red: 0, green: 177/255, blue: 112/255, alpha: 1)               // 系统使用的tint color，绿色
public let textInTintColor = UIColor.white                                                          // 在系统tint color中的文本颜色
public let mainTextColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)           // 主要的文本颜色
public let placeholderColor = UIColor(red: 192/255, green: 194/255, blue: 194/255, alpha: 1)        // 主要的文本颜色
public let placeholderDarkColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)    // 用在透明背景下的占位符文本颜色
public let placeholderDefaultColor = UIColor(red: 199/255, green: 199/255, blue: 205/255, alpha: 1) // 系统默认的占位符文本颜色
public let separatorLineColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)      // 分隔线颜色，浅灰
public let alertBackgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)       // 提示框的背景颜色
public let layerBackgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)       // 遮罩层的背景颜色
public let lightBackgroundColor = UIColor(red: 247/255, green: 249/255, blue: 248/255, alpha: 1)    // 浅背景色
public let heavyBackgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)    // 深背景色

// 主要字体
public let navigationFont = UIFont(name: "PingFang SC", size: 18)                                   // 系统中使用的navigation字体
public let systemFont = UIFont(name: "PingFang SC", size: 16)                                       // 系统使用的字体
public let systemSmallFont = UIFont(name: "PingFang SC", size: 14)                                  // 系统中使用的小型字体
public let textFont = UIFont(name: "PingFang SC", size: 14)                                         // 系统中使用的文本字体
public let systemTinyFont = UIFont(name: "PingFang SC", size: 13)                                   // 系统中使用的最小型字体

// 用于在user default中使用的key
public let userKey = "userNameKey"
public let deviceIdKey = "deviceIdKey"
public let defaultPlaceOfOriginIdKey = "defaultPlaceOfOriginIdKey"
public let defaultPlaceOfOriginKey = "defaultPlaceOfOriginKey"
public let defaultAddressKey = "defaultAddressKey"

// HTTP请求地址
public let baseUrl = "http://192.168.1.114:8180/api"
//public let baseUrl = "https://ios.tymaker.cn/api"
//public let baseUrl = "http://59.110.112.15:8100/api"

// 网络未连接的提示信息
public let msgNoConnection = "未检测到网络连接"
