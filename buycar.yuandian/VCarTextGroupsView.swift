//
//  VCarTextGroupView.swift
//  buycar.yuandian
//  详情文本列表信息
//  Created by 李萌 on 2017/11/9.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

class VCarTextGroupsView: UIView {
    
    let groupHeight = CGFloat(50)
    var drawBottomSeparator = false
    var carInfoViewDelegate = CarInfoViewDelegate()
    var tgs = [TextGroup]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    /// 绘制一个TextGroup列表
    ///
    /// - Parameters:
    ///   - frame: 绘制边框
    ///   - drawBottomSeparator: 是否绘制底部分割线
    convenience init(frame: CGRect, drawBottomSeparator: Bool!) {
        self.init(frame: frame)
        self.drawBottomSeparator = drawBottomSeparator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // 设置所有标签
        var constraintView: UIView = self
        for tg in tgs {
            constraintView = self.appendSubview(constraintView, textGroup: tg)
        }
        
        // 添加一条完整的分割线，如果设置了不绘制分割线，则分割线的背景为白色，否则为系统分割线颜色
        let line = UIView()
        self.addSubview(line)
        line.backgroundColor = self.drawBottomSeparator ? separatorLineColor : UIColor.white
        line.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: line, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: line, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: line, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1))
        self.addConstraint(NSLayoutConstraint(item: line, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -1))
    }
    
    /// 添加一个子视图到当前视图
    ///
    /// - Parameters:
    ///   - constraintView: 子视图的约束对象，新视图的创建将根据它建立布局约束
    ///   - textGroup: 文本组合，提供label和text文本
    /// - Returns: 已添加的子视图
    private func appendSubview(_ constraintView: UIView!, textGroup: TextGroup!) -> UIView {
        // 创建视图
        let subview = UIView()
        let lblLabel = UILabel()
        let textLabel = UILabel()
        let line = UIView()
        
        // Label
        subview.addSubview(lblLabel)
        lblLabel.font = systemSmallFont
        lblLabel.textColor = mainTextColor
        lblLabel.text = textGroup.label
        // 适应父级容器高度，并在内容超出时截断尾部文本，用省略号代替
        lblLabel.numberOfLines = 0
        lblLabel.lineBreakMode = .byTruncatingTail
        lblLabel.translatesAutoresizingMaskIntoConstraints = false
        subview.addConstraint(NSLayoutConstraint(item: lblLabel, attribute: .leading, relatedBy: .equal, toItem: subview, attribute: .leading, multiplier: 1, constant: 18))
        subview.addConstraint(NSLayoutConstraint(item: lblLabel, attribute: .top, relatedBy: .equal, toItem: subview, attribute: .top, multiplier: 1, constant: 0))
        subview.addConstraint(NSLayoutConstraint(item: lblLabel, attribute: .width, relatedBy: .equal, toItem: subview, attribute: .width, multiplier: 0.4, constant: -18))
        subview.addConstraint(NSLayoutConstraint(item: lblLabel, attribute: .height, relatedBy: .equal, toItem: subview, attribute: .height, multiplier: 1, constant: 0))
        
        // Text
        subview.addSubview(textLabel)
        textLabel.font = systemSmallFont
        textLabel.textColor = mainTextColor
        textLabel.text = textGroup.text
        // 适应父级容器高度，并在内容超出时截断尾部文本，用省略号代替
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byTruncatingTail
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        subview.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .leading, relatedBy: .equal, toItem: lblLabel, attribute: .trailing, multiplier: 1, constant: 16))
        subview.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .trailing, relatedBy: .equal, toItem: subview, attribute: .trailing, multiplier: 1, constant: -18))
        subview.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .width, relatedBy: .equal, toItem: subview, attribute: .width, multiplier: 0.6, constant: -34))
        subview.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .height, relatedBy: .equal, toItem: lblLabel, attribute: .height, multiplier: 1, constant: 0))
        subview.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .centerY, relatedBy: .equal, toItem: lblLabel, attribute: .centerY, multiplier: 1, constant: 0))
        
        // Line
        subview.addSubview(line)
        line.backgroundColor = separatorLineColor
        line.translatesAutoresizingMaskIntoConstraints = false
        subview.addConstraint(NSLayoutConstraint(item: line, attribute: .leading, relatedBy: .equal, toItem: subview, attribute: .leading, multiplier: 1, constant: 18))
        subview.addConstraint(NSLayoutConstraint(item: line, attribute: .trailing, relatedBy: .equal, toItem: subview, attribute: .trailing, multiplier: 1, constant: -18))
        subview.addConstraint(NSLayoutConstraint(item: line, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1))
        subview.addConstraint(NSLayoutConstraint(item: line, attribute: .top, relatedBy: .equal, toItem: subview, attribute: .bottom, multiplier: 1, constant: -1))
        
        self.addSubview(subview)
        subview.backgroundColor = UIColor.white
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        // 创建高度的约束
        let subviewHeight = calculateHeight(textGroup)
        self.addConstraint(NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: subviewHeight))
        
        // 创建与相对视图的约束
        if constraintView == self {
            self.addConstraint(NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: constraintView, attribute: .leading, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: constraintView, attribute: .trailing, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: constraintView, attribute: .top, multiplier: 1, constant: 0))
        } else {
            self.addConstraint(NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: constraintView, attribute: .leading, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: constraintView, attribute: .trailing, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: constraintView, attribute: .bottom, multiplier: 1, constant: 0))
        }
        return subview
    }
    
    /// 计算总高度，需要先设置有效的tgs
    ///
    /// - Returns: 计算出的总高度
    func calculateTotalHeight() -> CGFloat {
        return CGFloat(tgs.count * Int(self.groupHeight))
    }
    
    /// 计算单个TextGroup的高度
    ///
    /// - Parameter textGroup: 文本组合对象
    /// - Returns: 计算所得的高度
    func calculateHeight(_ textGroup: TextGroup!) -> CGFloat {
        return self.groupHeight
    }
}

class TextGroup {
    var label: String!
    var text: String!
    
    init(_ label: String!, _ text: String!) {
        self.label = label
        self.text = text
    }
}
