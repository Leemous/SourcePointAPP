//
//  DoublePictureGroup.swift
//  buycar.yuandian
//
//  Created by 李萌 on 2019/3/4.
//  Copyright © 2019年 tymaker. All rights reserved.
//

import UIKit

class DoublePictureGroup: UIView {
    
    /// 左侧图片
    var leftImage: UIImage? {
        didSet {
            if let img = self.leftImage {
                self.photoViewL.image = img
            } else {
                self.photoViewL.image = self.holderImageL
            }
        }
    }
    
    /// 右侧图片
    var rightImage: UIImage? {
        didSet {
            if let img = self.rightImage {
                self.photoViewR.image = img
            } else {
                self.photoViewR.image = self.holderImageR
            }
        }
    }
    
    // 标题文本
    private var titleText: String!
    // 左侧占位图
    private var holderImageL: UIImage?
    // 右侧占位图
    private var holderImageR: UIImage?
    // 左侧视图选择图片事件
    private var pickerPictureL: ((UIImage?) -> Void)?
    // 右侧视图选择图片事件
    private var pickerPictureR: ((UIImage?) -> Void)?
    // 水平间隙宽度
    private var horizontalSpaceWidth: CGFloat!
    
    // 标题视图
    private var titleLabel: UILabel
    // 左侧照片视图L
    private var photoViewL: UIImageView
    // 右侧照片视图R
    private var photoViewR: UIImageView
    // 底部横线
    private var bottomLine: UIView
    
    // 是否绘制完成
    private var isDrawFinished = false
    
    /// 创建一个两张照片选择的组合视图
    ///
    /// - Parameters:
    ///   - frame: 位置及大小
    ///   - titleText: 表单标题文本
    ///   - holderImage: 占位图片
    ///   - pickerPicture: 图片选择事件
    init(frame: CGRect, titleText: String, holderImageL: UIImage? = nil, pickerPictureL: ((UIImage?) -> Void)? = nil, holderImageR: UIImage? = nil, pickerPictureR: ((UIImage?) -> Void)? = nil) {
        
        self.titleText = titleText
        self.holderImageL = holderImageL
        self.pickerPictureL = pickerPictureL
        self.holderImageR = holderImageR
        self.pickerPictureR = pickerPictureR
        self.horizontalSpaceWidth = (frame.width - 134 * 2) / 3
        
        // 设置表单标题文本属性
        self.titleLabel = UILabel()
        self.titleLabel.text = self.titleText
        // 初始化左侧照片视图
        self.photoViewL = UIImageView()
        // 初始化右侧照片视图
        self.photoViewR = UIImageView()
        // 初始化底部横线
        self.bottomLine = UIView()
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        self.tag = 3320
        
        if !self.isDrawFinished {
            // 将表单标题文本添加到视图中
            self.addSubview(self.titleLabel)
            // 为表单标题文本添加约束
            self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10))
            self.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10))
            self.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.titleText.isEmpty ? 0 : 30))
            
            // 设置左侧照片视图属性
            self.photoViewL.backgroundColor = heavyBackgroundColor
            self.photoViewL.contentMode = .scaleAspectFill
            self.photoViewL.clipsToBounds = true
            if self.photoViewL.image == nil {
                self.photoViewL.image = self.holderImageL
            }
            // 将左侧照片视图添加到视图中
            self.addSubview(self.photoViewL)
            // 为左侧照片视图添加约束
            self.photoViewL.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraint(NSLayoutConstraint(item: self.photoViewL, attribute: .top, relatedBy: .equal, toItem: self.titleLabel, attribute: .bottom, multiplier: 1, constant: 10))
            self.addConstraint(NSLayoutConstraint(item: self.photoViewL, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: self.horizontalSpaceWidth))
            self.addConstraint(NSLayoutConstraint(item: self.photoViewL, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 134))
            self.addConstraint(NSLayoutConstraint(item: self.photoViewL, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80))
            // 为左侧照片视图绑定事件
            let tapGRL = UITapGestureRecognizer(target: self, action: #selector(photoViewClickL))
            self.photoViewL.isUserInteractionEnabled = true
            self.photoViewL.addGestureRecognizer(tapGRL)
            
            // 设置右侧照片视图属性
            self.photoViewR.backgroundColor = heavyBackgroundColor
            self.photoViewR.contentMode = .scaleAspectFill
            self.photoViewR.clipsToBounds = true
            if self.photoViewR.image == nil {
                self.photoViewR.image = self.holderImageR
            }
            // 将右侧照片视图添加到视图中
            self.addSubview(self.photoViewR)
            // 为右侧照片视图添加约束
            self.photoViewR.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraint(NSLayoutConstraint(item: self.photoViewR, attribute: .top, relatedBy: .equal, toItem: self.titleLabel, attribute: .bottom, multiplier: 1, constant: 10))
            self.addConstraint(NSLayoutConstraint(item: self.photoViewR, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -self.horizontalSpaceWidth))
            self.addConstraint(NSLayoutConstraint(item: self.photoViewR, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 134))
            self.addConstraint(NSLayoutConstraint(item: self.photoViewR, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80))
            // 为右侧照片视图绑定事件
            let tapGRR = UITapGestureRecognizer(target: self, action: #selector(photoViewClickR))
            self.photoViewR.isUserInteractionEnabled = true
            self.photoViewR.addGestureRecognizer(tapGRR)
            
            // 底部横线
            self.bottomLine.backgroundColor = separatorLineColor
            // 将底部横线添加到视图中
            self.addSubview(self.bottomLine)
            // 为底部横线添加约束
            self.bottomLine.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraint(NSLayoutConstraint(item: self.bottomLine, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: self.bottomLine, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: self.bottomLine, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1))
            self.addConstraint(NSLayoutConstraint(item: self.bottomLine, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
            
            // 标记绘制完成
            self.isDrawFinished = true
        }
    }
    
    /// 左侧照片视图点击事件
    @objc private func photoViewClickL() {
        if let ppl = self.pickerPictureL {
            ppl(self.leftImage)
        }
    }
    
    /// 右侧照片视图点击事件
    @objc private func photoViewClickR() {
        if let ppr = self.pickerPictureR {
            ppr(self.rightImage)
        }
    }
}
