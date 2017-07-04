//
//  CheckOption.swift
//
//  收车检查项实体模型
//
//  Created by 姬鹏 on 2017/3/22.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class CheckItem: CommonModel {
    var itemKey: String!
    var itemName: String!
    var itemOptions: [CheckItemOption]!
    var optionAnswer: Int!
    
    override init() {
        
    }
    
    // 得到带有缺省选项的所有检查数据
    func getAllCheckItems(completion: @escaping ((ReturnedStatus, String?, [CheckItem]?) -> Void)) {
        var cis = [CheckItem]()
        
        // 固定数据
        let ci1 = CheckItem()
        ci1.itemKey = "isInspectDestory"
        ci1.itemName = "是否监销"
        ci1.optionAnswer = 1
        ci1.itemOptions = [CheckItemOption(optionKey: "true", optionName: "是", isDefault: true),
                           CheckItemOption(optionKey: "false", optionName: "否", isDefault: false)]
        cis.append(ci1)
        
        let ci2 = CheckItem()
        ci2.itemKey = "isConvertInspectDestory"
        ci2.itemName = "是否非监销转监销"
        ci2.optionAnswer = 1
        ci2.itemOptions = [CheckItemOption(optionKey: "true", optionName: "是", isDefault: false),
                           CheckItemOption(optionKey: "false", optionName: "否", isDefault: true)]
        cis.append(ci2)
        
        let ci3 = CheckItem()
        ci3.itemKey = "isTaxi"
        ci3.itemName = "是否出租车"
        ci3.optionAnswer = 1
        ci3.itemOptions = [CheckItemOption(optionKey: "true", optionName: "是", isDefault: false),
                           CheckItemOption(optionKey: "false", optionName: "否", isDefault: true)]
        cis.append(ci3)
        
        let ci4 = CheckItem()
        ci4.itemKey = "flowStatus"
        ci4.itemName = "车辆流程"
        ci4.optionAnswer = 0
        ci4.itemOptions = [CheckItemOption(optionKey: "C", optionName: "常规流程", isDefault: true),
                           CheckItemOption(optionKey: "H", optionName: "H流程", isDefault: false),
                           CheckItemOption(optionKey: "N", optionName: "N流程", isDefault: false)]
        cis.append(ci4)
        
        // 获取数据
        Alamofire.request(Router.missingParts()).responseJSON { response in
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        let obj = json["obj"]
                        for i in 0..<obj.count {
                            let opts = obj[i]["options"]
                            var options = [CheckItemOption]()
                            var defaultIndex = 0
                            for j in 0..<opts.count {
                                let cio = CheckItemOption(optionKey: opts[j]["value"].string!, optionName: opts[j]["label"].string!, isDefault: opts[j]["checked"].bool!)
                                options.append(cio)
                                if (cio.isDefault) {
                                    defaultIndex = j
                                }
                            }
                            
                            let ci = CheckItem()
                            ci.itemKey = obj[i]["key"].string!
                            ci.itemName = obj[i]["label"].string!
                            ci.itemOptions = options
                            ci.optionAnswer = defaultIndex
                            cis.append(ci)
                        }
                        completion(.normal, nil, cis)
                    } else if (code == ReturnedStatus.needLogin.rawValue) {
                        completion(.needLogin, msg, nil)
                    } else {
                        completion(.noData, msg, nil)
                    }
                } else {
                    completion(.noData, "获取车辆零部件信息失败", nil)
                }
            } else {
                completion(.noConnection, nil, nil)
            }
        }
    }
    
    // 得到指定车辆的所有检查数据
    func getAllCheckItemsForCar(carFrameNo: String, completion: @escaping ((ReturnedStatus, String?, [CheckItem]?) -> Void)) {
        // 自行实现这个方法
        
        // 模拟数据
//        var cis = [CheckItem]()
//        
//        let ci1 = CheckItem()
//        ci1.itemName = "是否监销"
//        ci1.itemOptions = [CheckItemOption(optionName: "是", isDefault: true),
//                           CheckItemOption(optionName: "否", isDefault: false)]
//        cis.append(ci1)
//        
//        let ci2 = CheckItem()
//        ci2.itemName = "是否非监销转监销"
//        ci2.itemOptions = [CheckItemOption(optionName: "是", isDefault: true),
//                           CheckItemOption(optionName: "否", isDefault: false)]
//        cis.append(ci2)
//        
//        let ci3 = CheckItem()
//        ci3.itemName = "车辆流程"
//        ci3.itemOptions = [CheckItemOption(optionName: "常规流程", isDefault: true),
//                           CheckItemOption(optionName: "H流程", isDefault: false),
//                           CheckItemOption(optionName: "N流程", isDefault: false)]
//        cis.append(ci3)
//        
//        let ci4 = CheckItem()
//        ci4.itemName = "电脑板"
//        ci4.itemOptions = [CheckItemOption(optionName: "有", isDefault: true),
//                           CheckItemOption(optionName: "无", isDefault: false)]
//        cis.append(ci4)
//        
//        let ci5 = CheckItem()
//        ci5.itemName = "三元催化"
//        ci5.itemOptions = [CheckItemOption(optionName: "有", isDefault: false),
//                           CheckItemOption(optionName: "无", isDefault: true)]
//        cis.append(ci5)
//        
//        let ci6 = CheckItem()
//        ci6.itemName = "ABS"
//        ci6.itemOptions = [CheckItemOption(optionName: "有", isDefault: true),
//                           CheckItemOption(optionName: "无", isDefault: false)]
//        cis.append(ci6)
//        
//        let ci7 = CheckItem()
//        ci7.itemName = "轮毂"
//        ci7.itemOptions = [CheckItemOption(optionName: "铁圈", isDefault: true),
//                           CheckItemOption(optionName: "铝圈", isDefault: false),
//                           CheckItemOption(optionName: "金圈", isDefault: false)]
//        cis.append(ci7)
//        completion(.normal, nil, cis)
    }
}




























