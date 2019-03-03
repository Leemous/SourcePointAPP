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
    @IBOutlet weak var selectedButton: UIButton!
    
    var selectedAction: ((_ isSelected: Bool) -> Void)?
    var consignAction: (() -> Void)?
    
    override func draw(_ rect: CGRect) {
        self.tag = 2000
        self.consignButton.layer.borderColor = systemTintColor.cgColor
        self.consignButton.layer.borderWidth = 1
        self.consignButton.layer.cornerRadius = 16
    }
    
    @IBAction func didSelectedCell(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if let handle = self.selectedAction {
            handle(sender.isSelected)
        }
    }
    
    @IBAction func didClickedConsignButton(_ sender: Any) {
        if let handle = self.consignAction {
            handle()
        }
    }
    
    func configure(model: ConsignPendingCellModel) {
        self.licenseLabel.text = model.carLisense
        self.frameLabel.text = model.carFrameNo
        self.selectedButton.isSelected = model.isSelected == true
    }
}

class ConsignPendingCellModel {
    var carId: String!
    var carLisense: String!
    var carFrameNo: String!
    var isSelected: Bool?
    
    init(_ carId: String, _ carLisense: String, _ carFrameNo: String, _ isSelected: Bool?) {
        self.carId = carId
        self.carLisense = carLisense
        self.carFrameNo = carFrameNo
        self.isSelected = isSelected
    }
}
