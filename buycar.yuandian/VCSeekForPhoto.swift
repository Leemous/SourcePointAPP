//
//  VCSeekForPhoto.swift
//  
//  用于拍照之前的查询的view controller，对应的storyboard是Main
//
//  Created by 姬鹏 on 2017/3/22.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class VCSeekForPhoto: UIViewController {

    @IBOutlet weak var lisenceLabel: UILabel!
    @IBOutlet weak var frameLabel: UILabel!
    @IBOutlet weak var lisenceText: TextFieldWithFinishButton!
    @IBOutlet weak var frameText: TextFieldWithFinishButton!
    @IBOutlet weak var seekButton: UIButton!

    var uploadResultMsg: String?
    let seekForPhotoDelegate = VCSeekForPhotoDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configTitleLabelByText(title: self.seekForPhotoDelegate.seekForTitle)
        
        self.lisenceText.delegate = self
        self.frameText.delegate = self
        
        seekButton.addTarget(self, action: #selector(VCSeekForPhoto.doSeek(_:)), for: .touchUpInside)
        
        initView()
        
        if uploadResultMsg != nil {
            self.alert(viewToBlock: nil, msg: uploadResultMsg!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doSeek(_ sender: AnyObject) {
        let viewToBlock = self.seekButton
        // 此处开始查询
        if self.checkEmpty(textfield: self.lisenceText) && self.checkEmpty(textfield: self.frameText) {
            self.alert(viewToBlock: viewToBlock, msg: "请输入查询条件")
            return
        }
        var router: Router!
        let carNumber = self.lisenceText.text!
        let carFrameNumber = self.frameText.text!
        // 根据seekType查找照片
        if self.seekForPhotoDelegate.seekFor == .forPurchase {
            router = Router.seekCollectPhoto(carNumber, carFrameNumber)
        } else {
            router = Router.seekSupervisedPhoto(carNumber, carFrameNumber)
        }
        Alamofire.request(router).responseJSON {
            response in
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        let obj = json["obj"]
                        let imageUrls = obj["images"]
                        self.pushViewControllerFromStoryboard(storyboardName: "Main", idInStoryboard: "vcCarPhoto", animated: true) { (vc: UIViewController) in
                            let cp = vc as! VCCarPhoto
                            
                            // 此处要放置查询结果
                            // 图片链接数组
                            var images = [UIImage]()
                            for i in 0..<imageUrls.count {
                                let urlString = imageUrls[i].stringValue
                                let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                                
                                let data = try! Data(contentsOf: url!)
                                let image = UIImage(data: data)
                                images.append(image!)
                            }
                            
                            cp.carPhotoDelegate.seekFor = self.seekForPhotoDelegate.seekFor
                            if self.seekForPhotoDelegate.seekFor == .forPurchase {
                                cp.carPhotoDelegate.photoTitle = "车辆拍照"
                            } else {
                                cp.carPhotoDelegate.photoTitle = "监销拍照"
                            }
                            cp.carPhotoDelegate.carId = obj["carId"].string!
                            cp.carPhotoDelegate.carNo = obj["carNo"].stringValue
                            cp.carPhotoDelegate.lisenceNo = obj["carNumber"].stringValue
                            cp.carPhotoDelegate.frameNo = obj["carShelfNumber"].stringValue
                            cp.carPhotoDelegate.carPhotos = images
                        }
                    } else {
                        self.alertLong(viewToBlock: viewToBlock, msg: msg)
                    }
                } else {
                    self.alert(viewToBlock: viewToBlock, msg: "获取收车照片失败")
                }
            } else {
                self.alert(viewToBlock: viewToBlock, msg: msgNoConnection)
            }
        }
        self.configNavigationBackItem(sourceViewController: self)
    }
    
    private func initView() {
        let _ = drawRoundBorderForView(seekButton, borderRadius: 17, borderWidth: 1, borderColor: UIColor.clear)
        
        // 为文本框设置下划线
        self.configUnderlyingLineForTextField(tf: self.lisenceText, height: 1, leading: 84, trailing: -18)
        self.configUnderlyingLineForTextField(tf: self.frameText, height: 1, leading: 84, trailing: -18)
    }
    
    // 用于从拍照界面返回
    @IBAction func backToSeekForPhoto(_ seg: UIStoryboardSegue!) {
        
    }
}

extension VCSeekForPhoto: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let v = self.view as! ViewForReleaseKeyboard
        v.fr = textField
    }
}

// 用来确定查询类型的枚举
enum SeekForType: Int {
    case forPurchase
    case forCheck
}

class VCSeekForPhotoDelegate {
    var seekFor: SeekForType!
    var seekForTitle: String!
}


























