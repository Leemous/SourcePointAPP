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
    var isSelected: Bool?
}

class ConsignForm: CommonModel {
    var carIds: String!
    var consignBySelf: Bool!
    var placeOfOriginId: String?
    var address: String?
    var destinationId: String?
    var consignorId: String?
    var chargerId: String!
    var remark: String!
}

extension Consign {
    /// 获取待托运列表
    ///
    /// - Parameter completion: 获取数据成功后的回调
    func getConsignPendingList(pageNo: Int!, pageSize: Int!, lastRefreshDate: Date!, completion: @escaping ((ReturnedStatus, String?, Int?, [Consign]?) -> Void)) {
        Alamofire.request(Router.consignPendingList(pageNo, pageSize, Int64(lastRefreshDate.timeIntervalSince1970 * 1000))).responseJSON { response in
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        var cpl = [Consign]()
                        let total = json["obj"]["total"].int!
                        let list = json["obj"]["list"]
                        for i in 0..<list.count {
                            let cp = Consign()
                            cp.carId = list[i]["carId"].string!
                            cp.carLicenseNo = list[i]["carNumber"].string!
                            cp.carFrameNo = list[i]["carShelfNumber"].string!
                            cpl.append(cp)
                        }
                        completion(.normal, nil, total, cpl)
                    } else {
                        completion(.noData, msg, nil, nil)
                    }
                } else {
                    completion(.noData, "获取待托运车辆信息失败", nil, nil)
                }
            } else {
                completion(.noConnection, nil, nil, nil)
            }
        }
    }
    
    /// 获取已托运列表
    ///
    /// - Parameter completion: 获取数据成功后的回调
    func getConsignHistoryList(pageNo: Int!, pageSize: Int!, lastRefreshDate: Date!, completion: @escaping ((ReturnedStatus, String?, Int?, [Consign]?) -> Void)) {
        Alamofire.request(Router.consignHistoryList(pageNo, pageSize, Int64(lastRefreshDate.timeIntervalSince1970 * 1000))).responseJSON { response in
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        var cpl = [Consign]()
                        let total = json["obj"]["total"].int!
                        let list = json["obj"]["list"]
                        for i in 0..<list.count {
                            let cp = Consign()
                            cp.id = list[i]["id"].string!
                            cp.carLicenseNo = list[i]["carNumber"].string!
                            cp.carFrameNo = list[i]["carShelfNumber"].string!
                            cp.consignBySelf = list[i]["consignBySelf"].bool!
                            cpl.append(cp)
                        }
                        completion(.normal, nil, total, cpl)
                    } else {
                        completion(.noData, msg, nil, nil)
                    }
                } else {
                    completion(.noData, "获取已托运车辆信息失败", nil, nil)
                }
            } else {
                completion(.noConnection, nil, nil, nil)
            }
        }
    }
    
    /// 保存托运信息
    ///
    /// - Parameters:
    ///   - consignForm: 托运表单信息
    ///   - completion: 保存完成后的回调
    func saveConsign(consignForm: ConsignForm!, completion: @escaping ((ReturnedStatus, String?) -> Void)) {
        var paramDict: [String : Any] = [:]
        paramDict["carIds"] = consignForm.carIds
        paramDict["consignBySelf"] = consignForm.consignBySelf! ? "true" : "false"
        if !consignForm.consignBySelf {
            // 非自运
            paramDict["placeOfOriginId"] = consignForm.placeOfOriginId
            paramDict["address"] = consignForm.address
            paramDict["destinationId"] = consignForm.destinationId
            paramDict["consignorId"] = consignForm.consignorId
        }
        paramDict["chargerId"] = consignForm.chargerId
        paramDict["remark"] = consignForm.remark
        
        Alamofire.request(Router.saveConsign(paramDict)).responseJSON { response in
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        completion(.normal, nil)
                    } else if (code == 2) {
                        completion(.warning, msg)
                    } else if (code == 0) {
                        completion(.noData, msg)
                    }
                } else {
                    completion(.noData, "保存托运信息失败")
                }
            } else {
                completion(.noConnection, nil)
            }
        }
    }
    
    /// 获取托运单详情
    ///
    /// - Parameters:
    ///   - id: <#id description#>
    ///   - completion: <#completion description#>
    func getConsign(id: String!, completion: @escaping ((ReturnedStatus, String?, Consign?) -> Void)) {
        Alamofire.request(Router.getConsign(id)).responseJSON { response in
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        let c = Consign()
                        let obj = json["obj"]
                        c.id = obj["id"].string!
                        c.consignBySelf = obj["consignBySelf"].bool!
                        if !c.consignBySelf {
                            // 非自运
                            c.placeOfOrigin = obj["placeOfOrigin"].string!
                            c.address = obj["address"].string!
                            c.destination = obj["destination"].string!
                            c.consignor = obj["consignor"].string!
                        }
                        c.charger = obj["charger"].string!
                        c.consignDate = obj["consignDate"].string!
                        c.remark = obj["remark"].string!
                        completion(.normal, nil, c)
                    } else {
                        completion(.noData, msg, nil)
                    }
                } else {
                    completion(.noData, "获取托运单信息失败", nil)
                }
            } else {
                completion(.noConnection, nil, nil)
            }
        }
    }
}
