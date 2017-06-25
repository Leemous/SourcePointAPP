//
//  WebTools.swift
//
//  与Web请求相关的工具函数集
//
//  Created by 姬鹏 on 2017/3/22.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

// 用于获取数据时，为回调闭包标识状态的枚举
public enum ReturnedStatus: Int {
    case normal = 0         // 返回数据正常
    case noData             // 请求正常返回，但没有数据
    case noConnection       // 未连接网络
    case wrongParam         // 参数错误
    case invalidFlag        // 无法识别的数据标识或结构
    case needLogin = 4300   // 该操作需要登录
    case warning            // 服务器返回的警告
    case unknown            // 未知错误，绝大多数是500错误
}

enum Router: URLRequestConvertible {
    case login(String, String)
    case logout()
    case userinfo()
    case dailyList()
    case addDaily(String)
    case todayPurchase()
    case missingParts()
    case qiniu()
    case addPurchase([String : Any])
    case seekCollectPhoto(String, String)
    case seekSupervisedPhoto(String, String)
    case addCollectPhoto(String, [String])
    case addSupervisedPhoto(String, [String])
    
    func asURLRequest() throws -> URLRequest {
        var method = "GET"
        let result: (path: String, parameters: Parameters?) = {
            switch self {
            case .login(let userName, let password):
                method = "POST"
                // 获取设备的系统名称及版本号，如:iPhone OS 10.3.2
                let systemVersion = UIDevice.current.systemName + UIDevice.current.systemVersion
                let params = ["username":"\(userName)", "password":"\(password)", "deviceType": "\(systemVersion)"]
                return ("/login", params)
            case .logout():
                method = "POST"
                return ("/logout", nil)
            case .userinfo():
                return ("/user/info", nil)
            case .dailyList():
                return ("/oa/dailylog", nil)
            case .addDaily(let content):
                method = "POST"
                let params = ["content" : "\(content)"]
                return ("/oa/dailylog/add", params)
            case .missingParts:
                return ("/car/basic/missingParts", nil)
            case .todayPurchase():
                return ("/car/todayCollect", nil)
            case .qiniu():
                return ("/thirdpartyparam/qiniu", nil)
            case .addPurchase(let paramDic):
                method = "POST"
                return ("/car/add", paramDic)
            case .seekCollectPhoto(let carNumber, let carShelfNumber):
                let params = ["carNumber":"\(carNumber)", "carShelfNumber":"\(carShelfNumber)"]
                return ("/car/collectPhotos", params)
            case .seekSupervisedPhoto(let carNumber, let carShelfNumber):
                let params = ["carNumber":"\(carNumber)", "carShelfNumber":"\(carShelfNumber)"]
                return ("/car/inspectDestoryPhotos", params)
            case .addCollectPhoto(let carId, let urls):
                method = "POST"
                let urlsJSON = JSON(urls)
                let params = ["carId":"\(carId)", "urls" : urlsJSON] as [String : Any]
                return ("/car/collectPhoto/add", params)
            case .addSupervisedPhoto(let carId, let urls):
                method = "POST"
                let urlsJSON = JSON(urls)
                let params = ["carId":"\(carId)", "urls" : urlsJSON] as [String : Any]
                return ("/car/inspectDestoryPhoto/add", params)
            }
        }()
        let url = try baseUrl.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        urlRequest.httpMethod = method
        
        let commonModel = CommonModel()
        let headers = commonModel.getHeaderWithDeviceId()
        for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
}
