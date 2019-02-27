//
//  TVCBuyCarCell.swift
//  
//  首页用于显示今日收车的table cell
//
//  Created by 姬鹏 on 2017/3/22.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

class TVCCarPurchaseCell: UITableViewCell {

    @IBOutlet weak var lisenceLabel: UILabel!
    @IBOutlet weak var frameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!

    var carPurchaseCellDelegate = CarPurchaseCellDelegate()

    override func draw(_ rect: CGRect) {
        self.lisenceLabel.text = carPurchaseCellDelegate.carLisenceNo
        self.frameLabel.text = carPurchaseCellDelegate.carFrameNo
        self.idLabel.text = "收车编号：" + carPurchaseCellDelegate.id
        self.tag = 1000
    }
}

class CarPurchaseCellDelegate {
    var carLisenceNo: String!
    var carFrameNo: String!
    var id: String!
}

























