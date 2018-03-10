//
//  VCarInfoView.swift
//  
//  收车界面用来维护车辆基本信息view
//
//  Created by 姬鹏 on 2017/3/23.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

class VCarInfoView: UIView {
    private var licenseLabel: UILabel!
    private var frameLabel: UILabel!
    private var modelLabel: UILabel!
    private var scrapValueLabel: UILabel!
    private var forceScrappedDateSwitchLabel: UILabel!
    private var forceScrappedDateLabel: UILabel!
    private var memoLabel: UILabel!

    var licenseText: TextFieldWithFinishButton!
    var frameText: TextFieldWithFinishButton!
    var modelText: TextFieldWithFinishButton!
    var scrapValueText: TextFieldWithFinishButton!
    var forceScrappedDateSwitch: UISwitch!
    var forceScrappedDateText: DatePickerField!
    var memoText: TextViewWithFinishButton!
    
    var carInfoViewDelegate = CarInfoViewDelegate()
    
    override func draw(_ rect: CGRect) {
        initView()

        // 如果有值，则赋值给文本框
        self.licenseText.text = self.carInfoViewDelegate.lisenceNo
        self.frameText.text = self.carInfoViewDelegate.frameNo
        self.modelText.text = self.carInfoViewDelegate.model
        self.scrapValueText.text = self.carInfoViewDelegate.scrapValue
        self.forceScrappedDateSwitch.isOn = self.carInfoViewDelegate.forceScrappedOn == true
        self.forceScrappedDateText.text = self.carInfoViewDelegate.forceScrappedDate
        self.memoText.text = self.carInfoViewDelegate.memo
    }
    
    private func initView() {
        // 设置所有标签
        // 车牌号标签
        self.licenseLabel = UILabel()
        self.addSubview(self.licenseLabel)
        self.licenseLabel.font = systemFont
        self.licenseLabel.textColor = mainTextColor
        self.licenseLabel.text = "车牌号"
        self.licenseLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.licenseLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 18))
        self.addConstraint(NSLayoutConstraint(item: self.licenseLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 18))

        // 车架号标签
        self.frameLabel = UILabel()
        self.addSubview(self.frameLabel)
        self.frameLabel.font = systemFont
        self.frameLabel.textColor = mainTextColor
        self.frameLabel.text = "车架号"
        self.frameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.frameLabel, attribute: .leading, relatedBy: .equal, toItem: self.licenseLabel, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.frameLabel, attribute: .top, relatedBy: .equal, toItem: self.licenseLabel, attribute: .bottom, multiplier: 1, constant: 20))
        
        // 车辆品牌标签
        self.modelLabel = UILabel()
        self.addSubview(self.modelLabel)
        self.modelLabel.font = systemFont
        self.modelLabel.textColor = mainTextColor
        self.modelLabel.text = "车辆品牌"
        self.modelLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.modelLabel, attribute: .leading, relatedBy: .equal, toItem: self.frameLabel, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.modelLabel, attribute: .top, relatedBy: .equal, toItem: self.frameLabel, attribute: .bottom, multiplier: 1, constant: 20))

        // 残值标签
        self.scrapValueLabel = UILabel()
        self.addSubview(self.scrapValueLabel)
        self.scrapValueLabel.font = systemFont
        self.scrapValueLabel.textColor = mainTextColor
        self.scrapValueLabel.text = "残值"
        self.scrapValueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.scrapValueLabel, attribute: .leading, relatedBy: .equal, toItem: self.modelLabel, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.scrapValueLabel, attribute: .top, relatedBy: .equal, toItem: self.modelLabel, attribute: .bottom, multiplier: 1, constant: 20))
        
        // 强制报废提醒标签
        self.forceScrappedDateSwitchLabel = UILabel()
        self.addSubview(self.forceScrappedDateSwitchLabel)
        self.forceScrappedDateSwitchLabel.font = systemFont
        self.forceScrappedDateSwitchLabel.textColor = mainTextColor
        self.forceScrappedDateSwitchLabel.text = "强制报废提醒"
        self.forceScrappedDateSwitchLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.forceScrappedDateSwitchLabel, attribute: .leading, relatedBy: .equal, toItem: self.scrapValueLabel, attribute: .leading, multiplier:1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.forceScrappedDateSwitchLabel, attribute: .top, relatedBy: .equal, toItem: self.scrapValueLabel, attribute: .bottom, multiplier:1, constant: 20))
        
        // 强制报废日期标签
        self.forceScrappedDateLabel = UILabel()
        self.addSubview(self.forceScrappedDateLabel)
        self.forceScrappedDateLabel.font = systemFont
        self.forceScrappedDateLabel.textColor = mainTextColor
        self.forceScrappedDateLabel.text = "强制报废日期"
        self.forceScrappedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.forceScrappedDateLabel, attribute: .leading, relatedBy: .equal, toItem: self.forceScrappedDateSwitchLabel, attribute: .leading, multiplier:1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.forceScrappedDateLabel, attribute: .top, relatedBy: .equal, toItem: self.forceScrappedDateSwitchLabel, attribute: .bottom, multiplier:1, constant: 20))

        // 备注标签
        self.memoLabel = UILabel()
        self.addSubview(self.memoLabel)
        self.memoLabel.font = systemSmallFont
        self.memoLabel.textColor = systemTintColor
        self.memoLabel.text = "备注"
        self.memoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.memoLabel, attribute: .leading, relatedBy: .equal, toItem: self.forceScrappedDateLabel, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.memoLabel, attribute: .top, relatedBy: .equal, toItem: self.forceScrappedDateLabel, attribute: .bottom, multiplier: 1, constant: 22))
        
        // 设置所有文本框
        // 车牌号文本框
        self.licenseText = TextFieldWithFinishButton()
        self.addSubview(self.licenseText)
        self.licenseText.contentMode = .redraw
        self.licenseText.font = textFont
        self.licenseText.textColor = mainTextColor
        self.licenseText.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.licenseText, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 90))
        self.addConstraint(NSLayoutConstraint(item: self.licenseText, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -18))
        self.addConstraint(NSLayoutConstraint(item: self.licenseText, attribute: .centerY, relatedBy: .equal, toItem: self.licenseLabel, attribute: .centerY, multiplier: 1, constant: 0))

        // 车架号文本框
        self.frameText = TextFieldWithFinishButton()
        self.addSubview(self.frameText)
        self.frameText.contentMode = .redraw
        self.frameText.font = textFont
        self.frameText.textColor = mainTextColor
        self.frameText.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.frameText, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 90))
        self.addConstraint(NSLayoutConstraint(item: self.frameText, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -18))
        self.addConstraint(NSLayoutConstraint(item: self.frameText, attribute: .centerY, relatedBy: .equal, toItem: self.frameLabel, attribute: .centerY, multiplier: 1, constant: 0))
        
        // 车辆品牌文本框
        self.modelText = TextFieldWithFinishButton()
        self.addSubview(self.modelText)
        self.modelText.contentMode = .redraw
        self.modelText.font = textFont
        self.modelText.textColor = mainTextColor
        self.modelText.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.modelText, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 90))
        self.addConstraint(NSLayoutConstraint(item: self.modelText, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -18))
        self.addConstraint(NSLayoutConstraint(item: self.modelText, attribute: .centerY, relatedBy: .equal, toItem: self.modelLabel, attribute: .centerY, multiplier: 1, constant: 0))

        // 残值文本框
        self.scrapValueText = TextFieldWithFinishButton()
        self.addSubview(self.scrapValueText)
        self.scrapValueText.contentMode = .redraw
        self.scrapValueText.font = textFont
        self.scrapValueText.textColor = mainTextColor
        self.scrapValueText.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.scrapValueText, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 90))
        self.addConstraint(NSLayoutConstraint(item: self.scrapValueText, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -18))
        self.addConstraint(NSLayoutConstraint(item: self.scrapValueText, attribute: .centerY, relatedBy: .equal, toItem: self.scrapValueLabel, attribute: .centerY, multiplier: 1, constant: 0))
        
        // 强制报废开关
        self.forceScrappedDateSwitch = UISwitch()
        self.addSubview(self.forceScrappedDateSwitch)
        self.forceScrappedDateSwitch.translatesAutoresizingMaskIntoConstraints = false
        self.forceScrappedDateSwitch.addTarget(self, action: #selector(switchDidChange), for: .valueChanged)
        self.addConstraint(NSLayoutConstraint(item: self.forceScrappedDateSwitch, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -18))
        self.addConstraint(NSLayoutConstraint(item: self.forceScrappedDateSwitch, attribute: .centerY, relatedBy: .equal, toItem: self.forceScrappedDateSwitchLabel, attribute: .centerY, multiplier: 1, constant: 0))
        
        // 强制报废日期文本框
        self.forceScrappedDateText = DatePickerField()
        self.addSubview(self.forceScrappedDateText)
        self.forceScrappedDateText.contentMode = .redraw
        self.forceScrappedDateText.font = textFont
        self.forceScrappedDateText.textColor = mainTextColor
        self.forceScrappedDateText.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.forceScrappedDateText, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 120))
        self.addConstraint(NSLayoutConstraint(item: self.forceScrappedDateText, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -18))
        self.addConstraint(NSLayoutConstraint(item: self.forceScrappedDateText, attribute: .centerY, relatedBy: .equal, toItem: self.forceScrappedDateLabel, attribute: .centerY, multiplier: 1, constant: 0))

        // 备注文本框
        self.memoText = TextViewWithFinishButton()
        self.addSubview(self.memoText)
        self.memoText.contentMode = .redraw
        self.memoText.isEditable = true
        self.memoText.isSelectable = true
        self.memoText.textAlignment = .left
        self.memoText.backgroundColor = lightBackgroundColor
        self.memoText.font = textFont
        self.memoText.textColor = mainTextColor
        self.memoText.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self.memoText, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 12))
        self.addConstraint(NSLayoutConstraint(item: self.memoText, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -12))
        self.addConstraint(NSLayoutConstraint(item: self.memoText, attribute: .top, relatedBy: .equal, toItem: self.memoLabel, attribute: .bottom, multiplier: 1, constant: 8))
        self.addConstraint(NSLayoutConstraint(item: self.memoText, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 118))
        
        // 为车牌号文本框设置下划线
        let hline1 = UIView()
        hline1.backgroundColor = separatorLineColor
        self.addSubview(hline1)
        hline1.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: hline1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1))
        self.addConstraint(NSLayoutConstraint(item: hline1, attribute: .leading, relatedBy: .equal, toItem: self.licenseText, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: hline1, attribute: .trailing, relatedBy: .equal, toItem: self.licenseText, attribute: .trailing, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: hline1, attribute: .top, relatedBy: .equal, toItem: self.licenseText, attribute: .bottom, multiplier: 1, constant: 5))
        
        // 为车架号文本框设置下划线
        let hline2 = UIView()
        hline2.backgroundColor = separatorLineColor
        self.addSubview(hline2)
        hline2.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: hline2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1))
        self.addConstraint(NSLayoutConstraint(item: hline2, attribute: .leading, relatedBy: .equal, toItem: self.frameText, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: hline2, attribute: .trailing, relatedBy: .equal, toItem: self.frameText, attribute: .trailing, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: hline2, attribute: .top, relatedBy: .equal, toItem: self.frameText, attribute: .bottom, multiplier: 1, constant: 5))
        
        // 为车辆品牌文本框设置下划线
        let hline3 = UIView()
        hline3.backgroundColor = separatorLineColor
        self.addSubview(hline3)
        hline3.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: hline3, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1))
        self.addConstraint(NSLayoutConstraint(item: hline3, attribute: .leading, relatedBy: .equal, toItem: self.modelText, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: hline3, attribute: .trailing, relatedBy: .equal, toItem: self.modelText, attribute: .trailing, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: hline3, attribute: .top, relatedBy: .equal, toItem: self.modelText, attribute: .bottom, multiplier: 1, constant: 5))
        
        // 为残值文本框设置下划线
        let hline4 = UIView()
        hline4.backgroundColor = separatorLineColor
        self.addSubview(hline4)
        hline4.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: hline4, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1))
        self.addConstraint(NSLayoutConstraint(item: hline4, attribute: .leading, relatedBy: .equal, toItem: self.scrapValueText, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: hline4, attribute: .trailing, relatedBy: .equal, toItem: self.scrapValueText, attribute: .trailing, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: hline4, attribute: .top, relatedBy: .equal, toItem: self.scrapValueText, attribute: .bottom, multiplier: 1, constant: 5))
        
        // 为强制报废日期设置下划线
        let hline5 = UIView()
        hline5.backgroundColor = separatorLineColor
        self.addSubview(hline5)
        hline5.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: hline5, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1))
        self.addConstraint(NSLayoutConstraint(item: hline5, attribute: .leading, relatedBy: .equal, toItem: self.forceScrappedDateText, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: hline5, attribute: .trailing, relatedBy: .equal, toItem: self.forceScrappedDateText, attribute: .trailing, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: hline5, attribute: .top, relatedBy: .equal, toItem: self.forceScrappedDateText, attribute: .bottom, multiplier: 1, constant: 5))
        
        // 设置备注文本框的圆角边框
        let _ = drawRoundBorderForView(memoText, borderRadius: 6, borderWidth: 1, borderColor: systemTintColor)
    }
    
    func switchDidChange() {
        if (self.forceScrappedDateSwitch.isOn) {
            // 强制报废开关：开
            self.forceScrappedDateText.text = convertDateToString(Date.init(timeIntervalSinceNow: 0), pattern: "yyyy-MM-dd")
            self.forceScrappedDateText.isEnabled = true
        } else {
            // 强制报废开关：关
            self.forceScrappedDateText.text = ""
            self.forceScrappedDateText.isEnabled = false
        }
    }
}

class CarInfoViewDelegate {
    var lisenceNo: String?
    var frameNo: String?
    var model: String?
    var scrapValue: String?
    var forceScrappedOn: Bool?
    var forceScrappedDate: String?
    var memo: String?
}



























