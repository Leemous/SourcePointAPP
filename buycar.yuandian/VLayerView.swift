//
//  VLayerView.swift
//  buycar.yuandian
//
//  Created by 李萌 on 2017/7/4.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

class VLayerView: UIView {
    
    private var layerLabel: UILabel!
    private var layerMessage: String!
    
    init(layerMessage: String) {
        self.layerMessage = layerMessage
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        self.layerLabel = UILabel()
        self.addSubview(self.layerLabel)
        
        self.layerLabel.font = systemFont
        self.layerLabel.textColor = textInTintColor
        self.layerLabel.backgroundColor = UIColor.clear
        self.layerLabel.text = self.layerMessage
        
        self.layerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.layerLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.layerLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -40))
        self.addConstraint(NSLayoutConstraint(item: self.layerLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
    }
    
    override func didMoveToSuperview() {
        self.isOpaque = false
        self.backgroundColor = layerBackgroundColor
        self.alpha = 0.75
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
