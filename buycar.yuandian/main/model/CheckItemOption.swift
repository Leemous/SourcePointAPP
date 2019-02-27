//
//  CheckItemOption.swift
//
//  收车检查项的选项实体模型
//
//  Created by 姬鹏 on 2017/3/22.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import Foundation
import UIKit

class CheckItemOption: CommonModel {
    var optionKey: String!
    var optionName: String!
    var isDefault = false
    
    override init() {
        
    }
    
    init(optionKey: String, optionName: String, isDefault: Bool) {
        self.optionKey = optionKey
        self.optionName = optionName
        self.isDefault = isDefault
    }
}
