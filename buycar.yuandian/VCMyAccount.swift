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
    
    let myAccountDelegate = MyAccountDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configTitleLabelByText(title: "我的信息")
        
        self.logoutButton.addTarget(self, action: #selector(VCMyAccount.logout(_:)), for: .touchUpInside)
        
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
}

class MyAccountDelegate {
    var userName: String!
    var orgName: String!
}
























