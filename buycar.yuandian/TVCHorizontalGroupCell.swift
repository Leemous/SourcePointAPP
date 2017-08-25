//
//  TVC.swift
//  buycar.yuandian
//
//  Created by 李萌 on 2017/8/24.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

class TVCHorizontalGroupCell: UITableViewCell {
    
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentButton: UIButton!
    
    var horizontalGroupCellDelegate = HorizontalGroupCellDelegate()
    
    override func draw(_ rect: CGRect) {
        self.groupLabel.text = horizontalGroupCellDelegate.groupText
        
        if horizontalGroupCellDelegate.placeholderText != nil {
            self.contentLabel.text = horizontalGroupCellDelegate.placeholderText
        }
        
        changeContentText(horizontalGroupCellDelegate.contentText)
        
        if !(horizontalGroupCellDelegate.editable!) {
            self.contentButton.removeFromSuperview()
        }
        self.tag = 4000
    }
    
    func changeContentText(_ contentText: String!) {
        if contentText != nil {
            self.contentLabel.text = contentText
            self.contentLabel.textColor = UIColor.darkGray
        }
    }
}

class HorizontalGroupCellDelegate {
    var editable: Bool!
    var groupText: String!
    var placeholderText: String?
    var contentText: String?
}
