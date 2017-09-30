//
//  CVCCarPhotoCell.swift
//
//  用于显示车辆照片的collection cell
//
//  Created by 姬鹏 on 2017/3/23.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

private let CarPhotoImageTag = 11111

class CVCCarPhotoCell: UICollectionViewCell {
    @IBOutlet weak var carPhotoImage: UIImageView!
    
    var imageClick: (() -> Void)!
    var removeCompletion: (() -> Void)!
    
    override func draw(_ rect: CGRect) {
        let _ = drawRoundBorderForView(self.carPhotoImage, borderRadius: 10, borderWidth: 1, borderColor: separatorLineColor)
    }
    
    /// 设置单元格
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - supportPreview: 是否需要支持预览，默认支持
    func setItem(_ image: UIImage, supportPreview: Bool! = true) {
        self.carPhotoImage.image = image
        self.carPhotoImage.contentMode = .scaleAspectFill
        
        if let rb = self.carPhotoImage.viewWithTag(CarPhotoImageTag) {
            rb.removeFromSuperview()
        }
        
        if supportPreview {
            // 为图片添加手势预览事件
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CVCCarPhotoCell.previewImage))
            self.carPhotoImage.isUserInteractionEnabled = true
            self.carPhotoImage.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    /// 设置可点击的单元格
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - imageClick: 点击图片时的事件
    func setItem(_ image: UIImage, imageClick: @escaping (() -> Void)) {
        self.carPhotoImage.image = image
        self.carPhotoImage.contentMode = .scaleAspectFill
        self.imageClick = imageClick
        
        if let rb = self.carPhotoImage.viewWithTag(CarPhotoImageTag) {
            rb.removeFromSuperview()
        }
        
        // 为图片添加手势事件
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CVCCarPhotoCell.clickImage))
        self.carPhotoImage.isUserInteractionEnabled = true
        self.carPhotoImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /// 设置带移除按钮的单元格
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - supportPreview: 是否需要支持预览，默认支持
    ///   - removeCompletion: 移除图片后所执行的操作
    func setRemovableItem(_ image: UIImage, supportPreview: Bool! = true, removeCompletion: @escaping (() -> Void)) {
        self.removeCompletion = removeCompletion
        self.setItem(image, supportPreview: supportPreview)
        
        if self.carPhotoImage.viewWithTag(CarPhotoImageTag) == nil {
            let positionX = self.carPhotoImage.bounds.size.width - 20
            
            let removeButton = UIButton(frame: CGRect(x: positionX, y: 0, width: 20, height: 20))
            removeButton.setBackgroundImage(UIImage(named: "removePhotoImage"), for: .normal)
            removeButton.tag = CarPhotoImageTag
            removeButton.addTarget(self, action: #selector(CVCCarPhotoCell.removeButtonClick), for: .touchUpInside)
            self.carPhotoImage.addSubview(removeButton)
        }
    }
    
    /// 预览图片
    func previewImage() {
        if let currentViewController = UIViewController.currentViewController() {
            currentViewController.showBigImageWithImageView(imageView: self.carPhotoImage, alpha: 1)
        }
    }
    
    /// 点击图片
    func clickImage() {
        if let ic = self.imageClick {
            ic()
        }
    }
    
    /// 移除按钮点击事件
    func removeButtonClick() {
        // 移除完成回调
        if let rc = self.removeCompletion {
            rc()
        }
    }
}