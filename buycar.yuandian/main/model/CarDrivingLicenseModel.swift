//
//  CarDrivingLicenseModel.swift
//  buycar.yuandian
//
//  Created by 李萌 on 2019/3/5.
//  Copyright © 2019年 tymaker. All rights reserved.
//

import SwiftyJSON
import Alamofire

/// 车辆行驶证模型
class CarDrivingLicenseModel: CommonModel {
    
    var frontFileUrl: String
    var backFileUrl: String
    
    /// 车牌号:plate_num
    var license: String?
    /// 车架号:vin
    var frameNumber: String?
    /// 车辆类型名称:vehicle_type
    var carTypeName: String?
    /// 车主姓名:owner
    var carOwnerName: String?
    /// 车辆使用性质名称:use_character
    var carUseKindName: String?
    /// 车主地址:addr
    var carOwnerAddress: String?
    /// 车辆类型名称:carModel
    var carModelName: String?
    /// 车辆型号:pattern
    var carPattern: String?
    /// 车辆发动机号:engine_num
    var carEngineNumber: String?
    /// 车辆行驶证注册登记日期:register_date
    var registerDate: String?
    
    /// 车辆荷载人数:approved_passenger
    var approvedPassenger: String?
    /// 车辆总质量:total_weight
    var totalWeight: String?
    /// 车辆长度：c_length
    var carLength: String?
    /// 车辆燃油类型:energy_type
    var fuelType: String?
    
    override init() {
        self.frontFileUrl = ""
        self.backFileUrl = ""
    }
    
    /// 识别行驶证正面信息
    ///
    /// - Parameters:
    ///   - completion: 识别完成后的回调
    func recognizeFront(completion: @escaping ((ReturnedStatus, String?) -> Void)) {
        if self.frontFileUrl.isEmpty {
            completion(.noData, "没有上传行驶证正面照片")
            return
        }
        
        // 获取数据
        Alamofire.request(Router.recognizeDrivingLicenseFront(self.frontFileUrl)).responseJSON { response in
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        print(json["obj"].description)
                        let obj = json["obj"]
                        self.license = obj["plate_num"].stringValue
                        self.frameNumber = obj["vin"].stringValue
                        self.carTypeName = obj["vehicle_type"].stringValue
                        self.carOwnerName = obj["owner"].stringValue
                        self.carUseKindName = obj["use_character"].stringValue
                        self.carOwnerAddress = obj["addr"].stringValue
                        self.carModelName = obj["carModel"].stringValue
                        self.carPattern = obj["pattern"].stringValue
                        self.carEngineNumber = obj["engine_num"].stringValue
                        self.registerDate = obj["register_date"].stringValue
                        
                        completion(.normal, nil)
                    } else if (code == ReturnedStatus.needLogin.rawValue) {
                        completion(.needLogin, msg)
                    } else {
                        completion(.noData, msg)
                    }
                } else {
                    completion(.noData, "识别车辆行驶证正面失败")
                }
            } else {
                completion(.noConnection, nil)
            }
        }
    }
    
    /// 识别行驶证反面信息
    ///
    /// - Parameters:
    ///   - completion: 识别完成后的回调
    func recognizeBack(completion: @escaping ((ReturnedStatus, String?) -> Void)) {
        if self.backFileUrl.isEmpty {
            completion(.noData, "没有上传行驶证反面照片")
            return
        }
        
        // 获取数据
        Alamofire.request(Router.recognizeDrivingLicenseBack(self.backFileUrl)).responseJSON { response in
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        let obj = json["obj"]
                        print(json["obj"].stringValue)
                        
                        self.license = obj["plate_num"].stringValue
                        self.approvedPassenger = obj["approved_passenger"].stringValue
                        self.totalWeight = obj["total_weight"].stringValue
                        self.carLength = obj["c_length"].stringValue
                        self.fuelType = obj["energy_type"].stringValue
                        
                        completion(.normal, nil)
                    } else if (code == ReturnedStatus.needLogin.rawValue) {
                        completion(.needLogin, msg)
                    } else {
                        completion(.noData, msg)
                    }
                } else {
                    completion(.noData, "识别车辆行驶证反面失败")
                }
            } else {
                completion(.noConnection, nil)
            }
        }
    }
}
