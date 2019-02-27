//
//  TVCPickerCell.swift
//  简单选择单元格
//
//  Created by 李萌 on 2017/8/25.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

class TVCSimplePickerCell: UITableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    
    var pickerCellDelegate = SimplePickerCellDelegate()
    
    override func draw(_ rect: CGRect) {
        guard pickerCellDelegate.text != nil else {
            return
        }
        self.contentLabel.text = pickerCellDelegate.text
        self.tag = 10000
    }
}

class SimplePickerCellDelegate {
    var key: String!
    var text: String!
}
