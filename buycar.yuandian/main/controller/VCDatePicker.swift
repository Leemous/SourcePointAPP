//
//  VCDatePicker.swift
//  日期选择控制器
//
//  Created by 李萌 on 2017/6/25.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

class VCDatePicker: UIViewController {
    
    var datePickerField: DatePickerField!
    var datePickerBar: UIToolbar!
    var datePicker: UIDatePicker!
    var datePickerHeight: CGFloat!
    var minimumDate: Date?
    var maximumDate: Date?
    var pickedDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    func initWithDateField(datePickerField: DatePickerField!, minimumDate: Date?, maximumDate: Date?) {
        self.datePickerField = datePickerField
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        if (self.datePickerField.text != nil && self.datePickerField.text != "") {
            // 设置文本框中的日期选中
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            pickedDate = formatter.date(from: self.datePickerField.text!)
        } else if (minimumDate != nil) {
            // 文本框中没有值，选中最小日期
            pickedDate = minimumDate!
        } else {
            // 默认选中当天
            pickedDate = Date.init(timeIntervalSinceNow: 0)
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        // 背景设置成半透明
        self.modalPresentationStyle = .custom
        
        self.datePickerHeight = 216
        
        self.datePickerBar = UIToolbar(frame: CGRect(x: 0, y: screenHeight - datePickerHeight - 40, width: screenWidth, height: 40))
        self.datePickerBar.barStyle = .default
        
        let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(mainTextColor, for: .normal)
        cancelButton.addTarget(self, action: #selector(VCDatePicker.cancel(_:)), for: .touchUpInside)
        let barCancelItem = UIBarButtonItem(customView: cancelButton)
        
        let finishButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        finishButton.setTitle("完成", for: .normal)
        finishButton.setTitleColor(systemTintColor, for: .normal)
        finishButton.addTarget(self, action: #selector(VCDatePicker.finish(_:)), for: .touchUpInside)
        let barFinishItem = UIBarButtonItem(customView: finishButton)
        
        let space = UIView(frame: CGRect(x: cancelButton.frame.width, y: 0, width: screenWidth - cancelButton.frame.width - finishButton.frame.width - 50, height: 25))
        let barSpaceItem = UIBarButtonItem(customView: space)
        
        self.datePickerBar.setItems([barCancelItem, barSpaceItem, barFinishItem], animated: true)
        self.view.addSubview(datePickerBar)
        
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: screenHeight - datePickerHeight, width: screenWidth, height: datePickerHeight))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.locale = Locale(identifier: "zh_CN")
        self.datePicker.datePickerMode = .date
        self.datePicker.minimumDate = self.minimumDate
        self.datePicker.maximumDate = self.maximumDate
        self.datePicker.setDate(pickedDate, animated: false)
        self.view.addSubview(self.datePicker)
    }
    
    
    /// 取消按钮，返回原视图
    ///
    /// - Parameter sender: sender description
    func cancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /// 确定按钮，设置文本框的值，返回原视图
    ///
    /// - Parameter sender: sender description
    func finish(_ sender: AnyObject) {
        self.dismiss(animated: true) {
            self.datePickerField.text = convertDateToString(self.datePicker.date, pattern: "yyyy-MM-dd")
        }
    }
}
