//
//  Consign.swift
//  buycar.yuandian
//
//  Created by 李萌 on 2017/8/23.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Consign: CommonModel {
    var id: String!
    var carId: String!
    var carLicenseNo: String!
    var carFrameNo: String!
    var consignBySelf: Bool!
    var placeOfOriginId: String!
    var placeOfOrigin: String!
    var address: String!
    var destinationId: String!
    var destination: String!
    var consignorId: String!
    var consignor: String!
    var chargerId: String!
    var charger: String!
    var consignDate: String!
    var remark: String!
    
    func saveConsign(content: Consign!, completion: @escaping ((ReturnedStatus, String?) -> Void)) {
//        Alamofire.request(Router.addDaily(content)).responseJSON { response in
//            if (response.result.isSuccess) {
//                // 请求成功
//                if let jsonValue = response.result.value {
//                    let json = JSON(jsonValue)
//                    let code = json["code"].int
//                    let msg = json["msg"].string!
//                    if (code == 1) {
//                        completion(.normal, nil)
//                    } else if (code == 2) {
//                        completion(.warning, msg)
//                    } else if (code == 0) {
//                        completion(.noData, msg)
//                    }
//                } else {
//                    completion(.noData, "保存日报信息失败")
//                }
//            } else {
//                completion(.noConnection, nil)
//            }
//        }
    }
    
    /// 获取待托运列表
    ///
    /// - Parameter completion: 获取数据成功后的回调
    func getConsignPendingList(completion: @escaping ((ReturnedStatus, String?, [Consign]?) -> Void)) {
        Alamofire.request(Router.consignPendingList(1, 9999)).responseJSON { response in
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        var cpl = [Consign]()
                        let obj = json["obj"]["list"]
                        for i in 0..<obj.count {
                            let cp = Consign()
                            cp.carId = obj[i]["carId"].string!
                            cp.carLicenseNo = obj[i]["carNumber"].string!
                            cp.carFrameNo = obj[i]["carShelfNumber"].string!
                            cpl.append(cp)
                        }
                        completion(.normal, nil, cpl)
                    } else {
                        completion(.noData, msg, nil)
                    }
                } else {
                    completion(.noData, "获取待托运车辆信息失败", nil)
                }
            } else {
                completion(.noConnection, nil, nil)
            }
        }
    }
    
    
    /// 获取已托运列表
    ///
    /// - Parameter completion: 获取数据成功后的回调
    func getConsignHistoryList(completion: @escaping ((ReturnedStatus, String?, [Consign]?) -> Void)) {
        Alamofire.request(Router.consignHistoryList(1, 9999)).responseJSON { response in
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        var cpl = [Consign]()
                        let obj = json["obj"]["list"]
                        for i in 0..<obj.count {
                            let cp = Consign()
                            cp.id = obj[i]["id"].string!
                            cp.carLicenseNo = obj[i]["carNumber"].string!
                            cp.carFrameNo = obj[i]["carShelfNumber"].string!
                            cpl.append(cp)
                        }
                        completion(.normal, nil, cpl)
                    } else {
                        completion(.noData, msg, nil)
                    }
                } else {
                    completion(.noData, "获取已托运车辆信息失败", nil)
                }
            } else {
                completion(.noConnection, nil, nil)
            }
        }
    }
}
