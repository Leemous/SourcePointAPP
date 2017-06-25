//
//  VNoConnectionView.swift
//
//  无网络连接时的背景View
//
//  Created by 姬鹏 on 2017/3/21.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

public let NoConnectionViewTag = 11001

class VNoConnectionView: UIView {

    @IBOutlet weak var retryButton: UIButton!

    // 用于retry按钮的回调函数
    var retryFunction: ((AnyObject) -> Void)!
    
    override func awakeFromNib() {
        retryButton.addTarget(self, action: #selector(retry(_:)), for: .touchUpInside)
    }
    
    override func draw(_ rect: CGRect) {
        let _ = drawRoundBorderForView(retryButton, borderRadius: 8, borderWidth: 1, borderColor: UIColor.clear)
    }
    
    func retry(_ sender: AnyObject) {
        retryFunction(sender)
    }
}
























