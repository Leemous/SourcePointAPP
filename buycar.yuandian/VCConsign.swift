//
//  VCDoConsign.swift
//  填写托运信息页面
//
//  Created by 李萌 on 2017/8/24.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private let horizontalGroupCell = "horizontalGroupCell"

class VCConsign: UIViewController {
    var detailTable: UITableView!
    var remarkView: UIView!
    
    var tableCellCount = 0
    var consignDelegate = ConsignDelegate()
    
    var addressText: TextFieldWithFinishButton!     // 此处用来记录详细地址的输入框对象，便于隐藏软键盘
    var remarkLabel: UILabel!
    var remarkText: TextViewWithFinishButton!
    
    let option = Option()
    var placeOfOrigins: [Option]!
    var destinations: [Option]!
    var consigors: [Option]!
    var consignChargers: [Option]!
    
    var layer: VLayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        consignDelegate.title = "自运"
        consignDelegate.consignBySelf = false
        consignDelegate.carId = ""
        
        // 守卫代码，保证页面正常绘制不闪退
        guard consignDelegate.title != nil && consignDelegate.consignBySelf != nil && consignDelegate.carId != nil else {
            return
        }
        
        self.configTitleLabelByText(title: consignDelegate.title)
        
        if consignDelegate.consignBySelf {
            tableCellCount = 1
        } else {
            tableCellCount = 5
        }
        
        initView()
    }
    
    private func initView() {
        // 设置右上角的barButtonItem
        let saveCarPurchaseButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(VCConsign.saveConsign))
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
        
        self.remarkView = UIView(frame: CGRect(x: 0, y: CGFloat(tableCellCount * 50 + 10), width: screenWidth, height: 150))
        self.view.addSubview(self.remarkView)
        // 备注标签
        self.remarkLabel = UILabel()
        self.remarkView.addSubview(remarkLabel)
        self.remarkLabel.font = systemSmallFont
        self.remarkLabel.textColor = systemTintColor
        self.remarkLabel.text = "备注"
        self.remarkLabel.translatesAutoresizingMaskIntoConstraints = false
        self.remarkView.addConstraint(NSLayoutConstraint(item: remarkLabel, attribute: .leading, relatedBy: .equal, toItem: self.remarkView, attribute: .leading, multiplier: 1, constant: 18))
        self.remarkView.addConstraint(NSLayoutConstraint(item: remarkLabel, attribute: .top, relatedBy: .equal, toItem: self.remarkView, attribute: .top, multiplier: 1, constant: 0))
        
        self.remarkText = TextViewWithFinishButton()
        self.remarkView.addSubview(remarkText)
        self.remarkText.contentMode = .redraw
        self.remarkText.isEditable = true
        self.remarkText.isSelectable = true
        self.remarkText.textAlignment = .left
        self.remarkText.backgroundColor = lightBackgroundColor
        self.remarkText.font = textFont
        self.remarkText.textColor = UIColor.darkGray
        self.remarkText.translatesAutoresizingMaskIntoConstraints = false
        self.remarkView.addConstraint(NSLayoutConstraint(item: remarkText, attribute: .leading, relatedBy: .equal, toItem: self.remarkView, attribute: .leading, multiplier: 1, constant: 12))
        self.remarkView.addConstraint(NSLayoutConstraint(item: remarkText, attribute: .trailing, relatedBy: .equal, toItem: self.remarkView, attribute: .trailing, multiplier: 1, constant: -12))
        self.remarkView.addConstraint(NSLayoutConstraint(item: remarkText, attribute: .top, relatedBy: .equal, toItem: self.remarkLabel, attribute: .bottom, multiplier: 1, constant: 8))
        self.remarkView.addConstraint(NSLayoutConstraint(item: remarkText, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 118))
        
        // 设置备注文本框的圆角边框
        let _ = drawRoundBorderForView(remarkText, borderRadius: 6, borderWidth: 1, borderColor: systemTintColor)
        
        // 遮罩层
        self.layer = VLayerView(layerMessage: "正在保存数据...")
    }
    
    /// 保存托运单
    func saveConsign() {
        // 构造数据
        var paramDict: [String : Any] = [:]
        paramDict["carId"] = self.consignDelegate.carId
        paramDict["consignBySelf"] = self.consignDelegate.consignBySelf
        paramDict["remark"] = self.remarkText.text
        
        if !self.consignDelegate.consignBySelf {
            // 托运
            if self.consignDelegate.placeOfOriginId == nil {
                self.alert(viewToBlock: nil, msg: "请选择托运起点")
                return
            } else {
                paramDict["placeOfOriginId"] = self.consignDelegate.placeOfOriginId
            }
            if self.consignDelegate.address == nil {
                self.addressText.becomeFirstResponder()
                self.alert(viewToBlock: nil, msg: "请填写起运详细地址")
                return
            } else {
                paramDict["address"] = self.consignDelegate.address
            }
            if self.consignDelegate.destinationId == nil {
                self.alert(viewToBlock: nil, msg: "请选择托运终点")
                return
            } else {
                paramDict["destinationId"] = self.consignDelegate.destinationId
            }
            if self.consignDelegate.consignorId == nil {
                self.alert(viewToBlock: nil, msg: "请选择托运人")
                return
            } else {
                paramDict["consignorId"] = self.consignDelegate.consignorId
            }
        }
        if self.consignDelegate.chargerId == nil {
            self.alert(viewToBlock: nil, msg: "请选择负责人")
            return
        } else {
            paramDict["chargerId"] = self.consignDelegate.chargerId
        }
        
        // 显示遮罩层
        self.view.addSubview(self.layer)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        // 保存到服务器
        Alamofire.request(Router.saveConsign(paramDict)).responseJSON { response in
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
                        // 保存成功，返回托运页面
                        self.performSegue(withIdentifier: "backFromConsign", sender: self)
                    } else {
                        self.alert(viewToBlock: nil, msg: msg)
                    }
                } else {
                    self.alert(viewToBlock: nil, msg: "保存托运信息失败")
                }
            } else {
                self.alert(viewToBlock: nil, msg: msgNoConnection)
            }
        }
    }
}

class ConsignDelegate {
    var title: String!
    var carId: String!
    var consignBySelf: Bool!
    var placeOfOriginId: String!
    var address: String!
    var destinationId: String!
    var consignorId: String!
    var chargerId: String!
}

extension VCConsign: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableCellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell所需配置
        var groupText: String!
        var placeholderText: String!
        var horizontalGroupType: HorizontalGroupType!
        var clickToPick: (() -> Void)!
        
        let cell = tableView.dequeueReusableCell(withIdentifier: horizontalGroupCell, for: indexPath) as! TVCHorizontalGroupCell
        if !self.consignDelegate.consignBySelf && indexPath.row == 0 {
            // 非自运，托运起点
            groupText = "托运起点"
            placeholderText = "请选择托运起点"
            horizontalGroupType = .picker
            let pickCompletion = { (key: String, text: String) in
                cell.horizontalGroupCellDelegate.contentKey = key
                cell.horizontalGroupCellDelegate.contentText = text
                cell.changeContentKeyAndText(contentKey: key, contentText: text)
                // 选中后修改委托中的记录值
                self.consignDelegate.placeOfOriginId = key
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
        } else if !self.consignDelegate.consignBySelf && indexPath.row == 1 {
            // 非自运，起运详址
            groupText = "起运详址"
            placeholderText = "请填写起运详细地址"
            horizontalGroupType = .input
            cell.afterDraw = {
                self.addressText = cell.textFieldView
            }
            cell.afterTextChanged = { (newText: String) in
                self.consignDelegate.address = newText
            }
        } else if !self.consignDelegate.consignBySelf && indexPath.row == 2 {
            // 非自运，托运终点
            groupText = "托运终点"
            placeholderText = "请选择托运终点"
            horizontalGroupType = .picker
            let pickCompletion = { (key: String, text: String) in
                cell.horizontalGroupCellDelegate.contentKey = key
                cell.horizontalGroupCellDelegate.contentText = text
                cell.changeContentKeyAndText(contentKey: key, contentText: text)
                // 选中后修改委托中的记录值
                self.consignDelegate.destinationId = key
            }
            clickToPick = {
                if self.destinations == nil {
                    self.option.getDestinations(completion: { (status: ReturnedStatus, msg: String?, options: [Option]?) in
                        switch status {
                        case .normal:
                            self.destinations = options!
                            self.showTablePickerView(options: self.destinations, completion: pickCompletion)
                        case .noConnection:
                            self.alert(viewToBlock: nil, msg: msgNoConnection)
                        default:
                            break
                        }
                    })
                } else {
                    self.showTablePickerView(options: self.destinations, completion: pickCompletion)
                }
            }
        } else if !self.consignDelegate.consignBySelf && indexPath.row == 3 {
            // 非自运，托运人
            groupText = "托运人"
            placeholderText = "请选择托运人"
            horizontalGroupType = .picker
            let pickCompletion = { (key: String, text: String) in
                cell.horizontalGroupCellDelegate.contentKey = key
                cell.horizontalGroupCellDelegate.contentText = text
                cell.changeContentKeyAndText(contentKey: key, contentText: text)
                // 选中后修改委托中的记录值
                self.consignDelegate.consignorId = key
            }
            clickToPick = {
                if self.consigors == nil {
                    self.option.getConsignors(completion: { (status: ReturnedStatus, msg: String?, options: [Option]?) in
                        switch status {
                        case .normal:
                            self.consigors = options!
                            self.showTablePickerView(options: self.consigors, completion: pickCompletion)
                        case .noConnection:
                            self.alert(viewToBlock: nil, msg: msgNoConnection)
                        default:
                            break
                        }
                    })
                } else {
                    self.showTablePickerView(options: self.consigors, completion: pickCompletion)
                }
            }
        } else if (!self.consignDelegate.consignBySelf && indexPath.row == 4) || (self.consignDelegate.consignBySelf && indexPath.row == 0) {
            // 负责人
            groupText = "负责人"
            placeholderText = "请选择负责人"
            horizontalGroupType = .picker
            let pickCompletion = { (key: String, text: String) in
                cell.horizontalGroupCellDelegate.contentKey = key
                cell.horizontalGroupCellDelegate.contentText = text
                cell.changeContentKeyAndText(contentKey: key, contentText: text)
                // 选中后修改委托中的记录值
                self.consignDelegate.chargerId = key
            }
            clickToPick = {
                if self.consignChargers == nil {
                    self.option.getConsignChargers(completion: { (status: ReturnedStatus, msg: String?, options: [Option]?) in
                        switch status {
                        case .normal:
                            self.consignChargers = options!
                            self.showTablePickerView(options: self.consignChargers, completion: pickCompletion)
                        case .noConnection:
                            self.alert(viewToBlock: nil, msg: msgNoConnection)
                        default:
                            break
                        }
                    })
                } else {
                    self.showTablePickerView(options: self.consignChargers, completion: pickCompletion)
                }
            }
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

extension VCConsign: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
