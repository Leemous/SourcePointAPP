//
//  Option.swift
//  buycar.yuandian
//
//  Created by 李萌 on 2017/8/24.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Option {
    var key: String!
    var text: String!
}

extension Option {
    /// 获取起运地点
    ///
    /// - Parameter completion: <#completion description#>
    func getPlaceOfOrigins(completion: @escaping ((ReturnedStatus, String?, [Option]?) -> Void)) {
        Alamofire.request(Router.consignPlaceOfOrigins()).responseJSON { response in
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        var ol = [Option]()
                        let obj = json["obj"]
                        for i in 0..<obj.count {
                            let o = Option()
                            o.key = obj[i]["id"].string!
                            o.text = obj[i]["name"].string!
                            ol.append(o)
                        }
                        completion(.normal, nil, ol)
                    } else {
                        completion(.noData, msg, nil)
                    }
                } else {
                    completion(.noData, "获取起运地点信息失败", nil)
                }
            } else {
                completion(.noConnection, nil, nil)
            }
        }
    }
    
    /// 获取托运终点
    ///
    /// - Parameter completion: <#completion description#>
    func getDestinations(completion: @escaping ((ReturnedStatus, String?, [Option]?) -> Void)) {
        Alamofire.request(Router.consignDestinations()).responseJSON { response in
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        var ol = [Option]()
                        let obj = json["obj"]
                        for i in 0..<obj.count {
                            let o = Option()
                            o.key = obj[i]["id"].string!
                            o.text = obj[i]["name"].string!
                            ol.append(o)
                        }
                        completion(.normal, nil, ol)
                    } else {
                        completion(.noData, msg, nil)
                    }
                } else {
                    completion(.noData, "获取托运终点信息失败", nil)
                }
            } else {
                completion(.noConnection, nil, nil)
            }
        }
    }
    
    /// 获取托运人
    ///
    /// - Parameter completion: <#completion description#>
    func getConsignors(completion: @escaping ((ReturnedStatus, String?, [Option]?) -> Void)) {
        Alamofire.request(Router.consignors()).responseJSON { response in
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        var ol = [Option]()
                        let obj = json["obj"]
                        for i in 0..<obj.count {
                            let o = Option()
                            o.key = obj[i]["id"].string!
                            o.text = obj[i]["name"].string!
                            ol.append(o)
                        }
                        completion(.normal, nil, ol)
                    } else {
                        completion(.noData, msg, nil)
                    }
                } else {
                    completion(.noData, "获取托运人信息失败", nil)
                }
            } else {
                completion(.noConnection, nil, nil)
            }
        }
    }
    
    /// 获取托运负责人
    ///
    /// - Parameter completion: <#completion description#>
    func getConsignChargers(completion: @escaping ((ReturnedStatus, String?, [Option]?) -> Void)) {
        Alamofire.request(Router.consignChargers()).responseJSON { response in
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        var ol = [Option]()
                        let obj = json["obj"]
                        for i in 0..<obj.count {
                            let o = Option()
                            o.key = obj[i]["id"].string!
                            o.text = obj[i]["name"].string!
                            ol.append(o)
                        }
                        completion(.normal, nil, ol)
                    } else {
                        completion(.noData, msg, nil)
                    }
                } else {
                    completion(.noData, "获取托运负责人信息失败", nil)
                }
            } else {
                completion(.noConnection, nil, nil)
            }
        }
    }
}
