//
//  VCSeekForDetail.swift
//  buycar.yuandian
//  搜索车辆详细信息
//  Created by 李萌 on 2017/11/8.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class VCSeekForCarDetail: UIViewController {
    
    @IBOutlet weak var lisenceLabel: UILabel!
    @IBOutlet weak var frameLabel: UILabel!
    @IBOutlet weak var lisenceText: TextFieldWithFinishButton!
    @IBOutlet weak var frameText: TextFieldWithFinishButton!
    @IBOutlet weak var seekButton: UIButton!
    
    var layer: VLayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configTitleLabelByText(title: "查找车辆")
        
        self.lisenceText.delegate = self
        self.frameText.delegate = self
        
        self.seekButton.addTarget(self, action: #selector(VCSeekForCarDetail.doSeek(_:)), for: .touchUpInside)
        
        self.initView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initView() {
        let _ = drawRoundBorderForView(seekButton, borderRadius: 17, borderWidth: 1, borderColor: UIColor.clear)
        
        // 为文本框设置下划线
        self.configUnderlyingLineForTextField(tf: self.lisenceText, height: 1, leading: 84, trailing: -18)
        self.configUnderlyingLineForTextField(tf: self.frameText, height: 1, leading: 84, trailing: -18)
        
        layer = VLayerView(layerMessage: "正在查询车辆信息...")
    }
    
    func doSeek(_ sender: AnyObject) {
        let viewToBlock = self.seekButton
        // 此处开始查询
        if self.checkEmpty(textfield: self.lisenceText) && self.checkEmpty(textfield: self.frameText) {
            self.alert(viewToBlock: viewToBlock, msg: "请输入查询条件")
            return
        }
        self.view.addSubview(self.layer)
        self.seekButton.isEnabled = false
        self.lisenceText.resignFirstResponder()
        self.frameText.resignFirstResponder()
        
        let carNumber = self.lisenceText.text!
        let carFrameNumber = self.frameText.text!
        Alamofire.request(Router.seekCarDetail(carNumber, carFrameNumber)).responseJSON {
            response in
            if self.layer.superview != nil {
                self.seekButton.isEnabled = true
                self.layer.removeFromSuperview()
            }
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        self.pushViewControllerFromStoryboard(storyboardName: "Main", idInStoryboard: "vcCarDetail", animated: true) { (vc: UIViewController) in
                            let vc = vc as! VCCarDetail
                            
                            vc.detail = json["obj"].arrayValue
                        }
                    } else {
                        self.alertLong(viewToBlock: viewToBlock, msg: msg)
                    }
                } else {
                    self.alert(viewToBlock: viewToBlock, msg: "查找车辆信息失败")
                }
            } else {
                self.alert(viewToBlock: viewToBlock, msg: msgNoConnection)
            }
        }
        self.configNavigationBackItem(sourceViewController: self)
    }
}

extension VCSeekForCarDetail: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let v = self.view as! ViewForReleaseKeyboard
        v.fr = textField
    }
}
