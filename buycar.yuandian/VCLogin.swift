//
//  VCLogin.swift
//
//  登录界面的view controller，对应storyboard是Login
//
//  Created by 姬鹏 on 2017/3/21.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

class VCLogin: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var pwdImage: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var pwdText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configTitleLabelByText(title: "登录")
        
        self.nameText.delegate = self
        self.pwdText.delegate = self
        
        self.loginButton.addTarget(self, action: #selector(VCLogin.doLogin(_:)), for: .touchUpInside)
        
        initViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initViews() {
        let _ = drawRoundBorderForView(self.loginButton, borderRadius: 17, borderWidth: 1, borderColor: UIColor.clear)

        // 设置文本框下划线
        self.configUnderlyingLineForTextField(tf: self.nameText, height: 1, leading: 36, trailing: -36)
        self.configUnderlyingLineForTextField(tf: self.pwdText, height: 1, leading: 36, trailing: -36)
        
        // 设置文本框的placeholder
        self.configPlaceHolderForTextField(tf: self.nameText, placeHolder: "用户名")
        self.configPlaceHolderForTextField(tf: self.pwdText, placeHolder: "密码")
    }
    
    func doLogin(_ sender: AnyObject) {
        // 检查用户名框是否为空
        if self.checkEmpty(textfield: self.nameText) {
            self.alert(viewToBlock: self.loginButton, msg: "请填写用户名")
            return
        }
        
        // 检查密码框是否为空
        if self.checkEmpty(textfield: self.pwdText) {
            self.alert(viewToBlock: self.loginButton, msg: "请填写密码")
            return
        }

        let user = User(userName: self.nameText.text!, password: self.pwdText.text!)
        user.userLoginCompletion = completion
        user.login(self, viewToBlock: self.loginButton)
    }
    
    func completion () {
        let w = (UIApplication.shared.delegate as! AppDelegate).window!
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vcHome = sb.instantiateViewController(withIdentifier: "vcHome") as! VCHome
        let ncHome = NCHome(rootViewController: vcHome)

        w.rootViewController = ncHome
        w.makeKeyAndVisible()
    }
}

extension VCLogin: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let v = self.view as! ViewForReleaseKeyboard
        v.fr = textField
    }
}

























