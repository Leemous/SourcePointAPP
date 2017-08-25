//
//  ViewTools.swift
//  buycar.yuandian
//
//  Created by 李萌 on 2017/8/24.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

extension UIView {
    /// 返回当前View的指定类型的上级View
    ///
    /// - Parameter of: <#of description#>
    /// - Returns: <#return value description#>
    func superView<T: UIView>(of: T.Type) -> T? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let father = view as? T {
                return father
            }
        }
        return nil
    }
}

/// 带有完成按钮的单行文本框
class TextFieldWithFinishButton: UITextField {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40))
        bar.barStyle = .default
        
        let finishButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        finishButton.setTitle("完成", for: .normal)
        finishButton.setTitleColor(systemTintColor, for: .normal)
        finishButton.addTarget(self, action: #selector(TextFieldWithFinishButton.release(_:)), for: .touchUpInside)
        let barItem2 = UIBarButtonItem(customView: finishButton)
        
        let space = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth - finishButton.frame.width - 30, height: 25))
        let barItem1 = UIBarButtonItem(customView: space)
        
        bar.setItems([barItem1, barItem2], animated: true)
        
        self.inputAccessoryView = bar
    }
    
    func release(_ sender: AnyObject) {
        self.resignFirstResponder()
    }
}

/// 带有完成按钮的多行文本框
class TextViewWithFinishButton: UITextView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40))
        bar.barStyle = .default
        
        let finishButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        finishButton.setTitle("完成", for: .normal)
        finishButton.setTitleColor(systemTintColor, for: .normal)
        finishButton.addTarget(self, action: #selector(TextViewWithFinishButton.release(_:)), for: .touchUpInside)
        let barItem2 = UIBarButtonItem(customView: finishButton)
        
        let space = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth - finishButton.frame.width - 30, height: 25))
        let barItem1 = UIBarButtonItem(customView: space)
        
        bar.setItems([barItem1, barItem2], animated: true)
        
        self.inputAccessoryView = bar
    }
    
    func release(_ sender: AnyObject) {
        self.resignFirstResponder()
    }
}

/// 带有取消-完成按钮的日历选择框
class DatePickerField: UITextField {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}
