//
//  VCMyAccount.swift
//  
//  我的账户界面的view controller，对应storyboard是Main
//
//  Created by 姬鹏 on 2017/3/22.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

class VCMyAccount: UIViewController {

    @IBOutlet weak var avatorImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var orgNameLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var consignSettingView: UIView!
    
    let myAccountDelegate = MyAccountDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configTitleLabelByText(title: "我的信息")
        
        self.logoutButton.addTarget(self, action: #selector(VCMyAccount.logout(_:)), for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(VCMyAccount.clickConsignSetting))
        self.consignSettingView.isUserInteractionEnabled = true
        self.consignSettingView.addGestureRecognizer(tapGestureRecognizer)
        
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func initView() {
        userNameLabel.text = self.myAccountDelegate.userName
        orgNameLabel.text = self.myAccountDelegate.orgName
    }
    
    func logout(_ sender: AnyObject) {
        self.needsLogout()
    }
    
    func clickConsignSetting() {
        self.pushViewControllerFromStoryboard(storyboardName: "Main", idInStoryboard: "vcConsignSetting", animated: true, completion: nil)
        self.configNavigationBackItem(sourceViewController: self)
    }
    
    // 用于从托运起点设置界面返回
    @IBAction func backFromConsignSetting(_ seg: UIStoryboardSegue!) {
        
    }
}

class MyAccountDelegate {
    var userName: String!
    var orgName: String!
}
























