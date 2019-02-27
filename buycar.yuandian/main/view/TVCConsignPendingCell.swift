//
//  TVCPendingConsignCell.swift
//  buycar.yuandian
//
//  Created by 李萌 on 2017/8/21.
//  Copyright © 2017年 tymaker. All rights reserved.
//
import UIKit

class TVCConsignPendingCell: UITableViewCell {
    
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var frameLabel: UILabel!
    @IBOutlet weak var consignButton: UIButton!
    
    var consignPendingCellDelegate = ConsignPendingCellDelegate()
    
    override func draw(_ rect: CGRect) {
        self.licenseLabel.text = consignPendingCellDelegate.carLisenceNo
        self.frameLabel.text = consignPendingCellDelegate.carFrameNo
        self.tag = 2000
        self.consignButton.layer.borderColor = systemTintColor.cgColor
        self.consignButton.layer.borderWidth = 1
        self.consignButton.layer.cornerRadius = 16
    }
}

class ConsignPendingCellDelegate {
    var carId: String!
    var carLisenceNo: String!
    var carFrameNo: String!
}
