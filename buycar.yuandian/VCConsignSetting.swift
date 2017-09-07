//
//  VCConsignSetting.swift
//  buycar.yuandian
//
//  Created by 李萌 on 2017/9/7.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private let horizontalGroupCell = "horizontalGroupCell"

class VCConsignSetting: UIViewController {
    var detailTable: UITableView!
    var consignSettingDelegate = ConsignSettingDelegate()
    
    let option = Option()
    var placeOfOrigins: [Option]!
    
    var layer: VLayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 默认配置
        self.consignSettingDelegate.placeOfOriginId = self.getStringFromUserDefaultsByKey(key: defaultPlaceOfOriginIdKey)
        self.consignSettingDelegate.placeOfOrigin = self.getStringFromUserDefaultsByKey(key: defaultPlaceOfOriginKey)
        self.consignSettingDelegate.address = self.getStringFromUserDefaultsByKey(key: defaultAddressKey)
        
        self.configTitleLabelByText(title: "设置托运起点")
        
        initView()
        launchData()
    }
    
    private func initView() {
        // 设置右上角的barButtonItem
        let saveCarPurchaseButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(VCConsignSetting.saveConsignSetting))
        self.navigationItem.rightBarButtonItem = saveCarPurchaseButton
        
        // 初始化视图
        self.detailTable = UITableView()
        self.detailTable.tableFooterView = UIView()
        // 设置cell的分隔线
        self.detailTable.separatorInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        self.detailTable.dataSource = self
        self.detailTable.delegate = self
        // 取消所有多余分隔线
        self.detailTable.tableFooterView = UIView()
        
        // 设置cell的分隔线，以便其可以顶头开始
        self.detailTable.layoutMargins = UIEdgeInsets.zero
        self.detailTable.separatorInset = UIEdgeInsets.zero
        self.detailTable.separatorColor = separatorLineColor
        
        self.detailTable.register(UINib(nibName: "HorizontalGroupCell", bundle: nil), forCellReuseIdentifier: horizontalGroupCell)
        self.view.addSubview(self.detailTable)
        
        self.detailTable.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tv]|", options: [], metrics: nil, views: ["tv": self.detailTable]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tv]|", options: [], metrics: nil, views: ["tv": self.detailTable]))
        
        // 遮罩层
        self.layer = VLayerView(layerMessage: "正在保存...")
    }
    
    /// 加载托运起点设置
    private func launchData() {
        // 获取数据
        Alamofire.request(Router.getConsignSetting()).responseJSON { response in
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    if (code == 1) {
                        self.consignSettingDelegate.placeOfOriginId = json["obj"]["placeOfOriginId"].string!
                        self.consignSettingDelegate.placeOfOrigin = json["obj"]["placeOfOrigin"].string!
                        self.consignSettingDelegate.address = json["obj"]["address"].string!
                        
                        self.setStringInUserDefaultsByKey(key: defaultPlaceOfOriginIdKey, value: self.consignSettingDelegate.placeOfOriginId)
                        self.setStringInUserDefaultsByKey(key: defaultPlaceOfOriginKey, value: self.consignSettingDelegate.placeOfOrigin)
                        self.setStringInUserDefaultsByKey(key: defaultAddressKey, value: self.consignSettingDelegate.address)
                        self.detailTable.reloadData()
                    }
                } else {
                    self.alert(viewToBlock: nil, msg: "保存托运起点信息失败")
                }
            } else {
                self.alert(viewToBlock: nil, msg: msgNoConnection)
            }
        }
    }
    
    /// 保存托运起点设置
    func saveConsignSetting() {
        // 显示遮罩层
        self.view.addSubview(self.layer)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        let placeOfOriginId = self.consignSettingDelegate.placeOfOriginId == nil ? "" : self.consignSettingDelegate.placeOfOriginId
        let address = self.consignSettingDelegate.address == nil ? "" : self.consignSettingDelegate.address
        
        // 保存到服务器
        Alamofire.request(Router.saveConsignSetting(placeOfOriginId!, address!)).responseJSON { response in
            if self.layer.superview != nil {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.layer.removeFromSuperview()
            }
            if (response.result.isSuccess) {
                // 请求成功
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    let code = json["code"].int
                    let msg = json["msg"].string!
                    if (code == 1) {
                        // 保存成功，更新本地配置
                        self.setStringInUserDefaultsByKey(key: defaultPlaceOfOriginIdKey, value: self.consignSettingDelegate.placeOfOriginId)
                        self.setStringInUserDefaultsByKey(key: defaultPlaceOfOriginKey, value: self.consignSettingDelegate.placeOfOrigin)
                        self.setStringInUserDefaultsByKey(key: defaultAddressKey, value: self.consignSettingDelegate.address)
                        // 返回我的账户页面
                        self.performSegue(withIdentifier: "backFromConsignSetting", sender: self)
                    } else {
                        self.alert(viewToBlock: nil, msg: msg)
                    }
                } else {
                    self.alert(viewToBlock: nil, msg: "保存托运起点信息失败")
                }
            } else {
                self.alert(viewToBlock: nil, msg: msgNoConnection)
            }
        }
    }
}

class ConsignSettingDelegate {
    var placeOfOriginId: String!
    var placeOfOrigin: String!
    var address: String!
}

extension VCConsignSetting: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell所需配置
        var groupText: String!
        var placeholderText: String!
        var horizontalGroupType: HorizontalGroupType!
        var clickToPick: (() -> Void)!
        
        let cell = tableView.dequeueReusableCell(withIdentifier: horizontalGroupCell, for: indexPath) as! TVCHorizontalGroupCell
        if indexPath.row == 0 {
            // 托运起点
            groupText = "托运起点"
            placeholderText = "请选择托运起点"
            horizontalGroupType = .picker
            let pickCompletion = { (key: String, text: String) in
                cell.changeContentKeyAndText(contentKey: key, contentText: text)
                // 选中后修改委托中的记录值
                self.consignSettingDelegate.placeOfOriginId = key
                self.consignSettingDelegate.placeOfOrigin = text
            }
            clickToPick = {
                if self.placeOfOrigins == nil {
                    self.option.getPlaceOfOrigins(completion: { (status: ReturnedStatus, msg: String?, options: [Option]?) in
                        switch status {
                        case .normal:
                            self.placeOfOrigins = options!
                            self.showTablePickerView(options: self.placeOfOrigins, completion: pickCompletion)
                        case .noConnection:
                            self.alert(viewToBlock: nil, msg: msgNoConnection)
                        default:
                            break
                        }
                    })
                } else {
                    self.showTablePickerView(options: self.placeOfOrigins, completion: pickCompletion)
                }
            }
            // 设置默认值
            cell.changeContentKeyAndText(contentKey: self.consignSettingDelegate.placeOfOriginId, contentText: self.consignSettingDelegate.placeOfOrigin)
        } else if indexPath.row == 1 {
            // 非自运，起运详址
            groupText = "起运详址"
            placeholderText = "请填写起运详细地址"
            horizontalGroupType = .input
            cell.afterTextChanged = { (newText: String) in
                self.consignSettingDelegate.address = newText
            }
            // 设置默认值
            cell.changeContentTextField(self.consignSettingDelegate.address)
        }
        
        cell.horizontalGroupCellDelegate.groupText = groupText
        cell.horizontalGroupCellDelegate.placeholderText = placeholderText
        cell.horizontalGroupCellDelegate.editable = true
        cell.horizontalGroupCellDelegate.type = horizontalGroupType
        cell.clickToPick = clickToPick
        cell.selectionStyle = .none
        return cell
    }
}

extension VCConsignSetting: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

