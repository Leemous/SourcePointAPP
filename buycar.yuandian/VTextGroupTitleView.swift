//
//  VTextGroupTitleView.swift
//  buycar.yuandian
//  组合文本标题
//  Created by 李萌 on 2017/11/10.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

class VTextGroupTitleView: UIView {
    
    var titleText: String?
    var drawSeparatorLine = false
    
    /// 绘制一个标题区域，不带底部分割线
    ///
    /// - Parameter frame: 绘制边框
    override init (frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 绘制一个标题区域
    ///
    /// - Parameters:
    ///   - frame: 绘制边框
    ///   - titleText: 标题文本
    convenience init(frame: CGRect, titleText: String?) {
        self.init(frame: frame)
        self.titleText = titleText
    }
    
    /// 绘制一个标题区域
    ///
    /// - Parameters:
    ///   - frame: 绘制边框
    ///   - titleText: 标题文本
    ///   - drawDivideLine: 是否绘制底部分割线
    convenience init(frame: CGRect, titleText: String?, drawSeparatorLine: Bool!) {
        self.init(frame: frame)
        self.titleText = titleText
        self.drawSeparatorLine = drawSeparatorLine
    }
    
    override func draw(_ rect: CGRect) {
        let lblTitle = UILabel()
        lblTitle.font = textFont
        lblTitle.textColor = systemTintColor
        lblTitle.text = self.titleText
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(lblTitle)
        self.addConstraint(NSLayoutConstraint(item: lblTitle, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 15))
        self.addConstraint(NSLayoutConstraint(item: lblTitle, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -15))
        self.addConstraint(NSLayoutConstraint(item: lblTitle, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        if (self.drawSeparatorLine) {
            let line = UIView()
            line.backgroundColor = separatorLineColor
            line.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(line)
            self.addConstraint(NSLayoutConstraint(item: line, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: line, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 1))
            self.addConstraint(NSLayoutConstraint(item: line, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1))
            self.addConstraint(NSLayoutConstraint(item: line, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -1))
        }
    }
}
