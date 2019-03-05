//
//  CarPurchase.swift
//
//  收车实体模型
//
//  Created by 姬鹏 on 2017/3/22.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class CarPurchase: CommonModel {
    var carLicenseNo: String!
    var carFrameNo: String!
    var id: String!
    var scrapValue: Double!
    var checkItems: [CheckItem]!
    
    private var memo: String?
    private var carImages: [UIImage]?
    
    override init() {
        
    }
    
    init(carLicenseNo: String, carFrameNo: String, id: String) {
        self.carLicenseNo = carLicenseNo
        self.carFrameNo = carFrameNo
        self.id = id
    }
    
    // 得到当天所有收到的车辆的基本信息
    func getAllCarPurchaseToday(completion: @escaping ((ReturnedStatus, String?, [CarPurchase]?) -> Void)) {
        Alamofire.request(Router.todayPurchase()).responseJSON { response in
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        var cps = [CarPurchase]()
                        let obj = json["obj"]
                        for i in 0..<obj.count {
                            let cp = CarPurchase()
                            cp.id = obj[i]["inputNo"].stringValue
                            cp.carLicenseNo = obj[i]["carNumber"].stringValue
                            cp.carFrameNo = obj[i]["carShelfNumber"].stringValue
                            cps.append(cp)
                        }
                        
                        completion(.normal, nil, cps)
                    } else if code == ReturnedStatus.needLogin.rawValue {
                        completion(.needLogin, nil, nil)
                    } else {
                        completion(.noData, msg, nil)
                    }
                } else {
                    completion(.noData, "获取今日收车信息失败", nil)
                }
            } else {
                completion(.noConnection, nil, nil)
            }
        }
    }
    
    func getCarPurchaseByCar(carFrameNo: String, completion: @escaping ((ReturnedStatus, String?, [CarPurchase]?) -> Void)) {
        
    }
}



























