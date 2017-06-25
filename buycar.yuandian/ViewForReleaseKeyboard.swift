//
//  ViewForReleaseKeyboard.swift
//  
//  所有需要点击空白处释放键盘的页面的mainView，使用时需要将当前的FirstResponder赋值给fr变量
//
//  Created by 姬鹏 on 2017/3/21.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

class ViewForReleaseKeyboard: UIView {
    var fr: UIView?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.fr?.resignFirstResponder()
    }
}
