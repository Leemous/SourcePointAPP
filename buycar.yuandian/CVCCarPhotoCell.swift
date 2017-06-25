//
//  CVCCarPhotoCell.swift
//  
//  用于显示车辆照片的collection cell
//
//  Created by 姬鹏 on 2017/3/23.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

class CVCCarPhotoCell: UICollectionViewCell {
    @IBOutlet weak var carPhotoImage: UIImageView!
    
    var setted = false
    
    override func draw(_ rect: CGRect) {
        let _ = drawRoundBorderForView(self.carPhotoImage, borderRadius: 10, borderWidth: 1, borderColor: separatorLineColor)
    }
    
    func setItem(_ image: UIImage, setted: Bool) {
        self.carPhotoImage.image = image
        self.carPhotoImage.contentMode = .scaleAspectFill
        self.setted = setted
        
        // 开始设置删除图片按钮
        if self.setted {
            if self.carPhotoImage.viewWithTag(11111) == nil {
                let positionX = self.carPhotoImage.bounds.size.width - 20
                let removeButton = DoNothingImageView(frame: CGRect(x: positionX, y: 0, width: 20, height: 20))
                removeButton.image = UIImage(named: "removePhotoImage")
                removeButton.isUserInteractionEnabled = true
                removeButton.tag = 11111
                self.carPhotoImage.addSubview(removeButton)
            }
        } else {
            if let rb = self.carPhotoImage.viewWithTag(11111) {
                rb.removeFromSuperview()
            }
        }
    }
}

class DoNothingImageView: UIImageView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
}


























