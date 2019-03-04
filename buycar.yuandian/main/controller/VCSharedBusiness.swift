//
//  VCSharedBusiness.swift
//
//  与本系统相关的view controller通用业务方法
//
//  Created by 姬鹏 on 2017/3/20.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// 获得当前视图
    ///
    /// - Parameter base:UIApplication下获取的rootViewController
    /// - Returns: 当前视图的UIViewController
    class func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
    
    // 检查用户是否处于登录状态，如果处于登录状态，则返回true
    func isLogined() -> Bool {
        var logined = true
        
        let deviceId = self.getStringFromUserDefaultsByKey(key: deviceIdKey)
        
        if deviceId == "" || deviceId == nil {
            logined = false
        }
        
        return logined
    }
    
    // 打开登录界面
    func needsLogin(_ completion: (() -> Void)?) {
        //
    }
    
    // 在已登录的情况下，退出登录
    func needsLogout() {
        let user = User()
        user.userLogoutCompletion = {
            let _ = self.removeStringFromUserDefaultsByKey(key: deviceIdKey)
            let _ = self.removeStringFromUserDefaultsByKey(key: userKey)
            let _ = self.removeStringFromUserDefaultsByKey(key: defaultPlaceOfOriginIdKey)
            let _ = self.removeStringFromUserDefaultsByKey(key: defaultPlaceOfOriginKey)
            let _ = self.removeStringFromUserDefaultsByKey(key: defaultAddressKey)
            // 将首页设置成Login界面
            let w = (UIApplication.shared.delegate as! AppDelegate).window!
            let sb = UIStoryboard(name: "Login", bundle: nil)
            let vcLogin = sb.instantiateViewController(withIdentifier: "vcLogin") as! VCLogin
            let ncLogin = NCHome(rootViewController: vcLogin)
            
            w.rootViewController = ncLogin
            w.makeKeyAndVisible()
        }
        user.logout(self, viewToBlock: nil)
    }
    
    // 显示没有网络连接的错误提示界面，并设置该界面中重试按钮的回调函数
    func showNoConnectionView(containerView view: UIView, clickEvent event: @escaping ((AnyObject) -> Void)) {
        let nib = UINib(nibName: "NoConnectionView", bundle: nil)
        let ncv = nib.instantiate(withOwner: nib, options: nil)[0] as! VNoConnectionView
        ncv.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        view.addSubview(ncv)
        
        ncv.tag = NoConnectionViewTag
        ncv.retryFunction = event
    }
    
    // 将没有网络连接的错误提示界面从主界面中移除
    func removeNoConnectView(containerView view: UIView) {
        if let ncv = view.viewWithTag(NoConnectionViewTag) {
            ncv.removeFromSuperview()
        }
    }
    
    // 显示没有数据的提示界面，并设置该界面中按钮的文本和点击该按钮时的回调函数
    func showNoDataView(containerView view: UIView) {
        let nib = UINib(nibName: "NoDataView", bundle: nil)
        let ndv = nib.instantiate(withOwner: nib, options: nil)[0] as! VNoDataView
        ndv.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        view.addSubview(ndv)
        
        ndv.tag = NoDataViewTag
    }
    
    // 将没有数据提示界面从主界面中移除
    func removeNoDataView(containerView view: UIView) {
        if let ndv = view.viewWithTag(NoDataViewTag) {
            ndv.removeFromSuperview()
        }
    }
    
    /// 显示日期选择器
    ///
    /// - Parameter dateField: 日期输入框
    func showDatePicker(dateField: DatePickerField, minimumDate: Date?, maximumDate: Date?) {
        let datePicker = VCDatePicker()
        datePicker.initWithDateField(datePickerField: dateField, minimumDate: minimumDate, maximumDate: maximumDate)
        datePicker.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.present(datePicker, animated: true, completion: nil)
    }
    
    /// 显示表格选择器
    ///
    /// - Parameters:
    ///   - options: 选项集合
    ///   - completion: 选择完成的事件
    func showTablePickerView(options: [Option], completion: @escaping ((String, String) -> Void)) {
        let pickerView = VCSimplePicker()
        pickerView.opts = options
        pickerView.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        pickerView.pickCompletion = completion
        self.present(pickerView, animated: true, completion: nil)
    }
    
    /// 点击图片放大，全屏展示
    ///
    /// - Parameters:
    ///   - imageView: 被点击的UIImageView
    ///   - alpha: 放大后的背景透明度
    func showBigImageWithImageView(imageView: UIImageView!, alpha: CGFloat) {
        guard imageView.image != nil else {
            return
        }
        // 要放大展示的图像
        let image = imageView.image
        // 放大后的背景层
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
        backgroundView.alpha = 0
        // 放大后的图像容器
        let bigImageView = UIImageView(frame: imageView.bounds)
        bigImageView.image = image
        bigImageView.tag = 500
        bigImageView.contentMode = .scaleAspectFit
        backgroundView.addSubview(bigImageView)
        self.view.addSubview(backgroundView)
        
        // 动画展示
        UIView.animate(withDuration: 0.4) {
            let width = screenWidth
            let height = image!.size.height * width / image!.size.width
            let y = (screenHeight - height) * 0.5
            
            bigImageView.frame = CGRect(x: 0, y: y, width: width, height: height)
            backgroundView.alpha = 1
        }
        
        // 点击大图缩小
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideBigImage))
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /// 点击隐藏大图
    ///
    /// - Parameter tap: 手势操作
    func hideBigImage(tap: UITapGestureRecognizer) {
        let backgroundView = tap.view
        UIView.animate(withDuration: 0.4, animations: {
            backgroundView?.alpha = 0
        }) { (finished) in
            backgroundView?.removeFromSuperview()
        }
    }
}
