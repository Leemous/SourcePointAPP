//
//  VCUnifiedSetting.swift
//  
//  与view controller相关的通用设置方法
//
//  Created by 姬鹏 on 2017/3/20.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit
import MobileCoreServices

extension UIViewController {
    // 该方法统一为navigation item的title设置一个UILabel，以便可以对title的样式进行控制
    func configTitleLabelByText(title: String) {
        // 设置navigation item的标题
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        lbl.attributedText = getAttributedString(title, fontFamily: navigationFont!, fontColor: textInTintColor)
        self.navigationItem.titleView = lbl
    }
    
    // 该方法统一为text field设置相关属性，并设置他的placeholder
    func configPlaceHolderForTextField(tf: UITextField, placeHolder ph: String) {
        tf.font = textFont
        tf.textColor = mainTextColor
        tf.attributedPlaceholder = getAttributedString(ph, fontFamily: textFont!, fontColor: placeholderColor)
    }
    
    // 该方法统一为text field设置下方的水平装饰线条
    func configUnderlyingLineForTextField(tf: UITextField, height: CGFloat, leading: CGFloat, trailing: CGFloat) {
        let hline = UIView()
        hline.backgroundColor = separatorLineColor
        self.view.addSubview(hline)
        hline.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: hline, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height))
        self.view.addConstraint(NSLayoutConstraint(item: hline, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: leading))
        self.view.addConstraint(NSLayoutConstraint(item: hline, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: trailing))
        self.view.addConstraint(NSLayoutConstraint(item: hline, attribute: .top, relatedBy: .equal, toItem: tf, attribute: .bottom, multiplier: 1, constant: 5))
    }
    
    // 为处于navigation controller之下的view controller设置不带文字的返回按钮
    func configNavigationBackItem(sourceViewController vc: UIViewController) {
        let tempBackButton = UIBarButtonItem()
        tempBackButton.title = ""
        vc.navigationItem.backBarButtonItem = tempBackButton
    }
    
    // 显示不带有任何交互的提示框，这个提示框会在4秒后消失
    func alert(viewToBlock sender: UIView?, msg: String) {
        let alert = VAlertView(alertMessage: msg, frame: CGRect(x: screenWidth/2-100, y: screenHeight/2-20, width: 200, height: 40))
        self.navigationController!.view.addSubview(alert)
        alert.showAlert(sender, stillTime: 3)
    }
    
    
    /// 弹出字符较多的提示框
    ///
    /// - Parameters:
    ///   - sender: 弹出时禁用哪个view
    ///   - msg: 弹出信息
    func alertLong(viewToBlock sender: UIView?, msg: String) {
        let alert = VAlertView(alertMessage: msg, frame: CGRect(x: screenWidth/2-150, y: screenHeight/2-20, width: 300, height: 40))
        self.navigationController!.view.addSubview(alert)
        alert.showAlert(sender, stillTime: 3)
    }
    
    // 向user defaults中写入一个字符串值
    func setStringInUserDefaultsByKey(key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    // 从user defaults中获取指定key所对应的字符串值
    func getStringFromUserDefaultsByKey(key: String) -> String? {
        let str = UserDefaults.standard.value(forKey: key) as? String
        if let value = str {
            return value
        } else {
            return nil
        }
    }
    
    // 从user defaults中移除一个键的值，如果移除成功，则返回true
    @discardableResult
    func removeStringFromUserDefaultsByKey(key: String) -> Bool {
        var removed = false
        
        UserDefaults.standard.removeObject(forKey: key)
        
        if self.getStringFromUserDefaultsByKey(key: key) == nil || self.getStringFromUserDefaultsByKey(key: key) == "" {
            removed = true
        }
        
        return removed
    }
    
    // 弹出一个view controller
    func popupViewControllerFromStoryboard(storyboardName sbn: String, idInStoryboard sbi: String, completion: (() -> Void)?) {
        let sb = UIStoryboard(name: sbn, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: sbi)
        self.present(vc, animated: true) {
            if let c = completion {
                c()
            }
        }
    }
    
    // push一个view controller
    func pushViewControllerFromStoryboard(storyboardName sbn: String, idInStoryboard sbi: String, animated: Bool, completion: ((UIViewController) -> Void)?) {
        let sb = UIStoryboard(name: sbn, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: sbi)
        
        if let c = completion {
            c(vc)
        }

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /// 验证输入框内容是否为空
    ///
    /// - Parameters:
    ///   - textfield: 输入框view
    ///   - escapeWhitespace: 是否去除首尾空格
    /// - Returns: 若为空则返回true，否则返回false
    func checkEmpty(textfield: UITextField, escapeWhitespace: Bool) -> Bool {
        // 默认输入框为空
        var isEmpty = true
        
        // 存在字符时，若需要去除首尾空格检查
        if textfield.text != "" && escapeWhitespace {
            let whitespace = NSCharacterSet.whitespacesAndNewlines
            let escapeWhitespaceStr = textfield.text!.trimmingCharacters(in: whitespace)
            if escapeWhitespaceStr != "" {
                isEmpty = false
            }
        }
        
        return isEmpty
    }
    
    /// 验证输入框内容是否为空，去除首尾空格，内容为空时变成第一响应
    ///
    /// - Parameter textfield: 输入框view
    /// - Returns: 若为空则返回true，否则返回false
    func checkEmpty(textfield: UITextField) -> Bool {
        // 默认输入框为空
        let isEmpty = checkEmpty(textfield: textfield, escapeWhitespace: true)
        
        // 内容为空时变成第一响应
        if isEmpty {
            textfield.becomeFirstResponder()
        }
        
        return isEmpty
    }
    
    
    /// 验证输入框内容是否为数字
    ///
    /// - Parameter textfield: 输入框view
    /// - Returns: 若为数字则返回true，否则返回false
    func checkNumber(textfield: UITextField) -> Bool {
        // 先检查是否为空
        let isEmpty = checkEmpty(textfield: textfield, escapeWhitespace: true)
        var isNumber = false
        if !isEmpty {
            let scan: Scanner = Scanner(string: textfield.text!)
            var val:Float = 0
            isNumber = scan.scanFloat(&val) && scan.isAtEnd
        }
        // 内容不为数字时变成第一响应
        if !isNumber {
            textfield.becomeFirstResponder()
        }
        return isNumber
    }
    
    func initCameraPicker() -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = [kUTTypeImage as String]
        return picker
    }
    
    func initPhotoPicker() -> UIImagePickerController {
        let picker =  UIImagePickerController()
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = [kUTTypeImage as String]
        return picker
    }
    
    func presentAlertAction(present: ((Int) -> Void)!) {
        let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        action.addAction(UIAlertAction(title: "拍照", style: .default) {_ in
            present(0)
        })
        action.addAction(UIAlertAction(title: "从相册选取", style: .default) {_ in
            present(1)
        })
        action.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(action, animated: true, completion: nil)
    }
}

























