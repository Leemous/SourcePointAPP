//
//  Daily.swift
//  
//  日报的实体模型
//
//  Created by 姬鹏 on 2017/3/22.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Daily: CommonModel {
    var id: String!
    var dailyTime: String!
    var dailyDetail: String!
    var dailyPerson: String!
    
    override init() {
        
    }
    
    init(id: String) {
        self.id = id
    }
    
    func getDailyList(pageNo: Int!, pageSize: Int!, lastRefreshDate: Date!, completion: @escaping ((ReturnedStatus, String?, [Daily]?) -> Void)) {
        // 此处添加请求代码
        Alamofire.request(Router.dailyList(pageNo, pageSize, Int64(lastRefreshDate.timeIntervalSince1970 * 1000))).responseJSON { response in
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        var ds = [Daily]()
                        let obj = json["obj"]
                        for i in 0..<obj.count {
                            let d = Daily()
                            d.id = obj[i]["id"].string!
                            d.dailyTime = obj[i]["time"].string!
                            d.dailyDetail = obj[i]["content"].string!
                            d.dailyPerson = obj[i]["person"].string!
                            ds.append(d)
                        }
                        completion(.normal, nil, ds)
                    } else {
                        completion(.noData, msg, nil)
                    }
                } else {
                    completion(.noData, "获取日报信息失败", nil)
                }
            } else {
                completion(.noConnection, nil, nil)
            }
        }
    }
    
    func saveDaily(content: String!, completion: @escaping ((ReturnedStatus, String?) -> Void)) {
        // 此处添加请求代码
        Alamofire.request(Router.addDaily(content)).responseJSON { response in
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
                    completion(.noData, "保存日报信息失败")
                }
            } else {
                completion(.noConnection, nil)
            }
        }
    }
}
























