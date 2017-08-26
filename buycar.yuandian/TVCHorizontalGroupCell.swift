//
//  TVC.swift
//  buycar.yuandian
//
//  Created by 李萌 on 2017/8/24.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

/// 水平布局组合单元格：可以做展示、输入、下拉选择
class TVCHorizontalGroupCell: UITableViewCell {
    
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    var contentButton: UIButton!
    var textFieldView: TextFieldWithFinishButton!
    
    var horizontalGroupCellDelegate = HorizontalGroupCellDelegate()
    var afterDraw: (() -> Void)!            // 绘制完成后的处理
    var clickToPick: (() -> Void)!          // 选择完成后的处理
    var afterTextChanged: ((String) -> Void)!    // 文本变化时的处理
    
    override func draw(_ rect: CGRect) {
        guard horizontalGroupCellDelegate.groupText != nil else {
            return
        }
        self.groupLabel.text = horizontalGroupCellDelegate.groupText
        
        if horizontalGroupCellDelegate.editable {
            initEditableView()
        } else {
            initNotEditableView()
        }
        
        
        if let ad = afterDraw {
            ad()
        }
        
        self.tag = 4000
    }
    
    /// 可编辑的视图，包括文本输入与选择两种
    func initEditableView() {
        switch horizontalGroupCellDelegate.type {
        case .input:
            // 绘制文本输入框
            self.textFieldView = TextFieldWithFinishButton()
            self.addSubview(self.textFieldView)
            self.textFieldView.contentMode = .redraw
            self.textFieldView.font = systemFont
            self.textFieldView.textColor = UIColor.darkGray
            self.textFieldView.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraint(NSLayoutConstraint(item: self.textFieldView, attribute: .leading, relatedBy: .equal, toItem: self.groupLabel, attribute: .leading, multiplier: 1, constant: 115))
            self.addConstraint(NSLayoutConstraint(item: self.textFieldView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -18))
            self.addConstraint(NSLayoutConstraint(item: self.textFieldView, attribute: .centerY, relatedBy: .equal, toItem: self.groupLabel, attribute: .centerY, multiplier: 1, constant: 0))
            
            self.textFieldView.addTarget(self, action: #selector(TVCHorizontalGroupCell.textChanged), for: .editingChanged)
            
            if horizontalGroupCellDelegate.placeholderText != nil {
                self.textFieldView.placeholder = horizontalGroupCellDelegate.placeholderText
            }
            break
        case .picker:
            guard clickToPick != nil else {
                return
            }
            // 选择框
            if horizontalGroupCellDelegate.placeholderText != nil {
                self.contentLabel.textColor = placeholderDefaultColor
                self.contentLabel.text = horizontalGroupCellDelegate.placeholderText
            }
            // 添加一个下拉操作按钮
            self.contentButton = UIButton()
            self.contentLabel.addSubview(self.contentButton)
            self.contentButton.setImage(UIImage(named: "arrowBottomImage"), for: .normal)
            self.contentButton.contentMode = .redraw
            self.contentButton.translatesAutoresizingMaskIntoConstraints = false
            self.contentLabel.addConstraint(NSLayoutConstraint(item: self.contentButton, attribute: .trailing, relatedBy: .equal, toItem: self.contentLabel, attribute: .trailing, multiplier: 1, constant: -18))
            self.contentLabel.addConstraint(NSLayoutConstraint(item: self.contentButton, attribute: .centerY, relatedBy: .equal, toItem: self.contentLabel, attribute: .centerY, multiplier: 1, constant: 0))
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TVCHorizontalGroupCell.clickPick))
            self.contentLabel.isUserInteractionEnabled = true
            self.contentLabel.addGestureRecognizer(tapGestureRecognizer)
            break
        }
    }
    
    /// 不可编辑的视图，进行赋值操作，并把操作按钮从父视图中移除
    func initNotEditableView() {
        if horizontalGroupCellDelegate.placeholderText != nil {
            self.contentLabel.text = horizontalGroupCellDelegate.placeholderText
        }
        
        changeContentText(horizontalGroupCellDelegate.contentText)
    }
    
    /// 修改内容文本
    ///
    /// - Parameter contentText: 改变后的内容文本
    func changeContentText(_ contentText: String!) {
        self.horizontalGroupCellDelegate.contentText = contentText
        if contentText != nil {
            self.contentLabel.text = contentText
            self.contentLabel.textColor = UIColor.darkGray
        } else {
            self.contentLabel.text = self.horizontalGroupCellDelegate.placeholderText
            self.contentLabel.textColor = placeholderDefaultColor
        }
    }
    
    /// 修改内容值和文本
    ///
    /// - Parameters:
    ///   - contentKey: 内容值
    ///   - contentText: 内容文本
    func changeContentKeyAndText(contentKey: String!, contentText: String!) {
        self.horizontalGroupCellDelegate.contentKey = contentKey
        changeContentText(contentText)
    }
    
    /// 点击选择事件
    func clickPick() {
        if let ctp = self.clickToPick {
            ctp()
        }
    }
    
    /// 文本框编辑事件
    func textChanged() {
        if let atc = afterTextChanged {
            atc(self.textFieldView.text!)
        }
    }
    
    /// 获得真正的值
    ///
    /// - Returns: 选择器获取Option的key，输入框获得输入的文本
    func getRealValue() -> String? {
        if horizontalGroupCellDelegate.editable {
            switch horizontalGroupCellDelegate.type {
            case .input:
                return horizontalGroupCellDelegate.contentText
            case .picker:
                return horizontalGroupCellDelegate.contentKey
            }
        } else {
            return horizontalGroupCellDelegate.contentText
        }
    }
}

/// 水平布局组合单元格委托
class HorizontalGroupCellDelegate {
    var editable: Bool
    var type: HorizontalGroupType
    var groupText: String!
    var placeholderText: String?
    var contentKey: String?
    var contentText: String?
    
    init() {
        editable = false
        type = .input
    }
}

/// 水平组合单元格类型
///
/// - input: 输入框
/// - picker: 选择
enum HorizontalGroupType {
    case input
    case picker
}
