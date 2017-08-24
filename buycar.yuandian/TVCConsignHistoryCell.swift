//
//  TVCConsignHistoryCell.swift
//  buycar.yuandian
//
//  Created by 李萌 on 2017/8/23.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

class TVCConsignHistoryCell: UITableViewCell {
    
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var frameLabel: UILabel!
    
    var consignHistoryCellDelegate = ConsignHistoryCellDelegate()
    
    override func draw(_ rect: CGRect) {
        self.licenseLabel.text = consignHistoryCellDelegate.carLisenceNo
        self.frameLabel.text = consignHistoryCellDelegate.carFrameNo
        self.tag = 3000
    }
}

class ConsignHistoryCellDelegate {
    var id: String!
    var carLisenceNo: String!
    var carFrameNo: String!
}
