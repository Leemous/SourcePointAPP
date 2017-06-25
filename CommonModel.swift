//
//  CommonModel.swift
//
//  能够获得已登录验证信息的公共实体模型
//
//  Created by 姬鹏 on 2017/3/21.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import Foundation

class CommonModel {
    func getDefaultHeader() -> [String: String] {
        return ["app": "buycar.yuandian"]
    }
    
    func getHeaderWithDeviceId() -> [String: String] {
        let deviceId = UserDefaults.standard.value(forKey: deviceIdKey) as? String
        if deviceId == "" || deviceId == nil {
            return getDefaultHeader()
        } else {
            return ["app": "buycar.yuandian", "Sinone-DeviceId": deviceId!]
        }
    }
}
