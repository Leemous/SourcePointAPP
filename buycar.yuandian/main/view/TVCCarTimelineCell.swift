//
//  TVCCarTimelineCell.swift
//  buycar.yuandian
//
//  Created by 李萌 on 2019/2/27.
//  Copyright © 2019年 tymaker. All rights reserved.
//

import UIKit

class TVCCarTimelineCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(model: CarTimelineCellModel) {
        timeLabel.text = model.time
        eventLabel.text = model.event
        
        if (model.isImportant) {
            timeLabel.textColor = UIColor.mi_hex("E7505A")
            symbolLabel.textColor = UIColor.mi_hex("E7505A")
            eventLabel.textColor = UIColor.mi_hex("E7505A")
        } else {
            timeLabel.textColor = UIColor.darkGray
            symbolLabel.textColor = UIColor.darkGray
            eventLabel.textColor = UIColor.darkGray
        }
    }
}

/// 车辆时间线单元格model
class CarTimelineCellModel {
    /// 时间
    var time: String!
    /// 事件
    var event: String!
    /// 是否重要节点
    var isImportant: Bool!
    
    init(_ time: String, _ event: String, _ isImportant: Bool = false) {
        self.time = time
        self.event = event
        self.isImportant = isImportant
    }
}
