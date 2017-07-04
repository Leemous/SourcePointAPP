//
//  VAlertView.swift
//  
//  提示框View
//
//  Created by 姬鹏 on 2017/3/21.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

class VAlertView: UIView {

    private var alertLabel: UILabel!
    private var alertMessage: String!
    
    init(alertMessage: String, frame: CGRect) {
        self.alertMessage = alertMessage
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        let _ = drawRoundBorderForView(self, borderRadius: 6, borderWidth: 1, borderColor: UIColor.clear)
    }
    
    override func layoutSubviews() {
        self.alertLabel = UILabel()
        self.addSubview(self.alertLabel)
        
        self.alertLabel.font = systemFont
        self.alertLabel.textColor = textInTintColor
        self.alertLabel.backgroundColor = UIColor.clear
        self.alertLabel.text = self.alertMessage

        self.alertLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.alertLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.alertLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.alertLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
    }
    
    override func didMoveToSuperview() {
        self.isOpaque = false
        self.backgroundColor = alertBackgroundColor
        self.alpha = 0.75
    }
    
    func showAlert(_ sender: UIView?, stillTime: CGFloat) {
        UIView.animate(withDuration: Double(stillTime), animations: {
            self.alpha = 0
        }, completion: { (b: Bool) -> Void in
            self.removeFromSuperview()
            if let s = sender {
                s.isUserInteractionEnabled = true
            }
        })
    }
}
























