//
//  User.swift
//
//  User实体类，用于执行登录和退出
//
//  Created by 姬鹏 on 2017/3/21.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class User: CommonModel {
    var userName: String!
    var orgName: String!

    private var password: String!
    private var deviceId: String!

    var userLoginCompletion: (() -> Void)!
    var userLogoutCompletion: (() -> Void)!
    
    // 用于在退出登录时，构造本对象
    override init() {
        
    }
    
    // 用于登录时，构造本对象
    init(userName: String, password: String) {
        self.userName = userName
        self.password = password
    }

    // 验证用户名和密码是否正确
    func login(_ sender: UIViewController, viewToBlock: UIView?) {
        if self.userName == nil || self.password == nil {
            return
        }
        
        // 此处添加请求代码
        Alamofire.request(Router.login(userName, password)).responseJSON { response in
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        // 登录成功
                        let obj = json["obj"]
                        sender.setStringInUserDefaultsByKey(key: userKey, value: obj["name"].string!)
                        sender.setStringInUserDefaultsByKey(key: deviceIdKey, value: obj["deviceId"].string!)
                        // 关闭自己
                        sender.navigationController!.dismiss(animated: true, completion: nil)
                        if let c = self.userLoginCompletion {
                            c()
                        }
                    } else if (code == 0) {
                        sender.alert(viewToBlock: viewToBlock, msg: msg)
                    }
                } else {
                    sender.alert(viewToBlock: viewToBlock, msg: "登录失败")
                }
            } else {
                sender.alert(viewToBlock: viewToBlock, msg: msgNoConnection)
            }
        }
    }
    
    // 用户退出登录，即使未登录。并执行退出之后的指定步骤
    func logout(_ sender: UIViewController, viewToBlock: UIView?) {
        let headers = self.getHeaderWithDeviceId()
        if headers["Sinone-DeviceId"] != nil {
            // 在此处添加请求代码
            Alamofire.request(Router.logout()).responseJSON { response in
                if (response.result.isSuccess) {
                    // 请求成功
                    if let jsonValue = response.result.value {
                        let json = JSON(jsonValue)
                        let code = json["code"].int
                        let msg = json["msg"].string!
                        if (code == 1) {
                            // 退出成功
                            if let c = self.userLogoutCompletion {
                                c()
                            }
                        } else {
                            sender.alert(viewToBlock: viewToBlock, msg: msg)
                        }
                    } else {
                        sender.alert(viewToBlock: viewToBlock, msg: "退出失败")
                    }
                } else {
                    sender.alert(viewToBlock: viewToBlock, msg: msgNoConnection)
                }
            }
        } else {
            // 出现找不到deviceId的情况(会吗？)，直接执行退出函数
            if let c = self.userLogoutCompletion {
                c()
            }
        }
    }
    
    func getUserInfo(completion: @escaping ((ReturnedStatus, String?, User?) -> Void)) {
        // 此处添加请求代码
        Alamofire.request(Router.userinfo()).responseJSON { response in
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        let user = User()
                        let obj = json["obj"]
                        user.userName = obj["name"].string!
                        user.orgName = obj["depart"].string!
                        completion(.normal, nil, user)
                    } else if (code == ReturnedStatus.needLogin.rawValue) {
                        completion(.needLogin, msg, nil)
                    } else {
                        completion(.noData, msg, nil)
                    }
                } else {
                    completion(.noData, "获取用户信息失败", nil)
                }
            } else {
                completion(.noConnection, nil, nil)
            }
        }
    }
}


























