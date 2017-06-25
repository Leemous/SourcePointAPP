//
//  Qiniu.swift
//  七牛的实体模型
//
//  Created by 李萌 on 2017/6/5.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import Foundation
import Alamofire

class Qiniu: CommonModel {
    var uptoken: String!
    var expires: String!
    var urlPrefix: String!
    
    override init() {
        
    }
    
    func getConfig(completion: @escaping ((ReturnedStatus, String?, Qiniu?) -> Void)) {
        // 此处添加请求代码
        Alamofire.request(Router.qiniu()).responseJSON { response in
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        let qn = Qiniu()
                        qn.uptoken = json["obj"]["uptoken"].string!
                        qn.expires = json["obj"]["expires"].string!
                        let cdnDomain = json["obj"]["cdnDomain"].string!
                        let domain = json["obj"]["domain"].string!
                        if cdnDomain != "" {
                            qn.urlPrefix = cdnDomain
                        } else {
                            qn.urlPrefix = domain
                        }
                        completion(.normal, nil, qn)
                    } else {
                        completion(.noData, msg, nil)
                    }
                } else {
                    completion(.noData, "服务器开小差了，请稍后再试", nil)
                }
            } else {
                completion(.noConnection, nil, nil)
            }
        }
    }
}
























