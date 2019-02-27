//
//  NCLogin.swift
//
//  登录界面的navigation controller，对应storyboard是Login
//
//  Created by 姬鹏 on 2017/3/21.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

class NCLogin: UINavigationController {

    let userLoginDelegate = UserLoginDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NCLogin: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = systemTintColor
        navigationController.navigationBar.tintColor = textInTintColor
        navigationController.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationFont!, NSForegroundColorAttributeName: textInTintColor]
    }
}

class UserLoginDelegate {
    var completion: (() -> Void)?
}

























