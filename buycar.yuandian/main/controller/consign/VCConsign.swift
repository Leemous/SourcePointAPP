//
//  VCDoConsign.swift
//  填写托运信息页面
//
//  Created by 李萌 on 2017/8/24.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

private let horizontalGroupCell = "horizontalGroupCell"

class VCConsign: UIViewController {
    
    var detailTable: UITableView!
    var headerView: UIView!
    var remarkView: UIView!
    
    var layer: VLayerView!
    
    var addressText: TextFieldWithFinishButton!     // 此处用来记录详细地址的输入框对象，便于隐藏软键盘
    var remarkLabel: UILabel!
    var remarkText: TextViewWithFinishButton!
    
    let option = Option()
    var placeOfOrigins: [Option]!
    var destinations: [Option]!
    var consigors: [Option]!
    var consignChargers: [Option]!
    
    var consigns: [Consign] = []
    var consignForm = ConsignForm()
    var tableCellCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 守卫代码，保证页面正常绘制不闪退
        guard consignForm.consignBySelf != nil && consigns.count != 0 else {
            return
        }
        
        self.configTitleLabelByText(title: consignForm.consignBySelf ? "自运" : "托运")
        self.tableCellCount = consignForm.consignBySelf ? 1 : 5
        
        initView()
    }
    
    private func initView() {
        // 设置右上角的barButtonItem
        let saveCarPurchaseButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(VCConsign.saveConsign))
        self.navigationItem.rightBarButtonItem = saveCarPurchaseButton
        
        // 初始化视图
        self.detailTable = UITableView()
        self.detailTable.tableFooterView = UIView()
        // 设置cell的分隔线，以便其可以顶头开始
        self.detailTable.layoutMargins = UIEdgeInsets.zero
        self.detailTable.separatorInset = UIEdgeInsets.zero
        self.detailTable.separatorColor = separatorLineColor
        // 设置委托和数据源
        self.detailTable.dataSource = self
        self.detailTable.delegate = self
        // 取消所有多余分隔线
        self.detailTable.tableHeaderView = UIView()
        self.detailTable.tableFooterView = UIView()
        
        // 注册单元格
        self.detailTable.register(UINib(nibName: "HorizontalGroupCell", bundle: nil), forCellReuseIdentifier: horizontalGroupCell)
        self.view.addSubview(self.detailTable)
        
        self.detailTable.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tv]|", options: [], metrics: nil, views: ["tv": self.detailTable]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tv]|", options: [], metrics: nil, views: ["tv": self.detailTable]))
        
        // 设置表头
        self.headerView = UIView(frame: CGRect(x: 10, y: 10, width: screenWidth - 20, height: 40))
        self.headerView.backgroundColor = UIColor.mi_hex("FEECCE")
        let headerTitleLabel = UILabel()
        headerTitleLabel.text = "本次托运的车牌号为："
        self.headerView.addSubview(headerTitleLabel)
        
        headerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.headerView.addConstraint(NSLayoutConstraint(item: headerTitleLabel, attribute: .top, relatedBy: .equal, toItem: self.headerView, attribute: .top, multiplier: 1, constant: 10))
        self.headerView.addConstraint(NSLayoutConstraint(item: headerTitleLabel, attribute: .leading, relatedBy: .equal, toItem: self.headerView, attribute: .leading, multiplier: 1, constant: 10))
        self.headerView.addConstraint(NSLayoutConstraint(item: headerTitleLabel, attribute: .trailing, relatedBy: .equal, toItem: self.headerView, attribute: .trailing, multiplier: 1, constant: -10))
        self.headerView.addConstraint(NSLayoutConstraint(item: headerTitleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
        
        let carLicenseLabel = UILabel()
        carLicenseLabel.numberOfLines = 0
        carLicenseLabel.lineBreakMode = .byWordWrapping
        var carLicenses = ""
        for consign in self.consigns {
            carLicenses += consign.carLicenseNo + ","
        }
        // 移除最后一个分隔符
        carLicenses.remove(at: carLicenses.index(before: carLicenses.endIndex))
        carLicenseLabel.text = carLicenses
        self.headerView.addSubview(carLicenseLabel)
        
        // 计算车牌号label的高度
        let carLicenseLabelHeight = self.calculateUILabelHeight(width: screenWidth - 40, text: carLicenses, font: carLicenseLabel.font)
        
        carLicenseLabel.translatesAutoresizingMaskIntoConstraints = false
        self.headerView.addConstraint(NSLayoutConstraint(item: carLicenseLabel, attribute: .top, relatedBy: .equal, toItem: headerTitleLabel, attribute: .bottom, multiplier: 1, constant: 5))
        self.headerView.addConstraint(NSLayoutConstraint(item: carLicenseLabel, attribute: .leading, relatedBy: .equal, toItem: headerTitleLabel, attribute: .leading, multiplier: 1, constant: 0))
        self.headerView.addConstraint(NSLayoutConstraint(item: carLicenseLabel, attribute: .trailing, relatedBy: .equal, toItem: headerTitleLabel, attribute: .trailing, multiplier: 1, constant: 0))
        self.headerView.addConstraint(NSLayoutConstraint(item: carLicenseLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: carLicenseLabelHeight))
        
        self.headerView.frame.size.height = self.headerView.frame.size.height + carLicenseLabelHeight
        
        self.detailTable.tableHeaderView = self.headerView
        
        self.remarkView = UIView(frame: CGRect(x: 0, y: self.headerView.frame.size.height + CGFloat(tableCellCount * 50 + 10), width: screenWidth, height: 150))
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
        var carIds = ""
        for item in self.consigns {
            carIds += item.carId + ","
        }
        // 移除最后一个分隔符
        carIds.remove(at: carIds.index(before: carIds.endIndex))
        
        // 构造数据
        consignForm.carIds = carIds
        consignForm.remark = self.remarkText.text
        
        if !self.consignForm.consignBySelf {
            // 托运
            if self.consignForm.placeOfOriginId == nil {
                self.alert(viewToBlock: nil, msg: "请选择托运起点")
                return
            }
            if self.consignForm.address == nil {
                self.addressText.becomeFirstResponder()
                self.alert(viewToBlock: nil, msg: "请填写起运详细地址")
                return
            }
            if self.consignForm.destinationId == nil {
                self.alert(viewToBlock: nil, msg: "请选择托运终点")
                return
            }
            if self.consignForm.consignorId == nil {
                self.alert(viewToBlock: nil, msg: "请选择托运人")
                return
            }
        }
        if self.consignForm.chargerId == nil {
            self.alert(viewToBlock: nil, msg: "请选择负责人")
            return
        }
        
        // 显示遮罩层
        self.view.addSubview(self.layer)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        // 保存到服务器
        let consign = Consign()
        consign.saveConsign(consignForm: consignForm) { (status: ReturnedStatus, msg: String?) in
            if self.layer.superview != nil {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.layer.removeFromSuperview()
            }
            switch status {
            case .normal:
                // 保存成功，返回托运页面
                self.performSegue(withIdentifier: "backToConsignPendingList", sender: self)
            case .needLogin:
                self.needsLogout()
            case .noConnection:
                self.alert(viewToBlock: nil, msg: msgNoConnection)
            default:
                break
            }
        }
    }
    
    /// 计算UILabel的宽度
    ///
    /// - Parameters:
    ///   - width: UILabel宽度
    ///   - text: UILabel的文本
    ///   - font: UILabel的字体
    /// - Returns: UILabel的高度
    private func calculateUILabelHeight(width: CGFloat, text: String, font: UIFont) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        label.text = text
        label.font = font
        label.numberOfLines = 0
        label.sizeToFit()
        return label.frame.size.height
    }
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
        if !self.consignForm.consignBySelf && indexPath.row == 0 {
            // 非自运，托运起点
            groupText = "托运起点"
            placeholderText = "请选择托运起点"
            horizontalGroupType = .picker
            let pickCompletion = { (key: String, text: String) in
                cell.changeContentKeyAndText(contentKey: key, contentText: text)
                // 选中后修改委托中的记录值
                self.consignForm.placeOfOriginId = key
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
            self.consignForm.placeOfOriginId = self.getStringFromUserDefaultsByKey(key: defaultPlaceOfOriginIdKey)
            cell.changeContentKeyAndText(contentKey: self.getStringFromUserDefaultsByKey(key: defaultPlaceOfOriginIdKey), contentText: self.getStringFromUserDefaultsByKey(key: defaultPlaceOfOriginKey))
        } else if !self.consignForm.consignBySelf && indexPath.row == 1 {
            // 非自运，起运详址
            groupText = "起运详址"
            placeholderText = "请填写起运详细地址"
            horizontalGroupType = .input
            cell.afterDraw = {
                self.addressText = cell.textFieldView
            }
            cell.afterTextChanged = { (newText: String) in
                self.consignForm.address = newText
            }
            // 设置默认值
            self.consignForm.address = self.getStringFromUserDefaultsByKey(key: defaultAddressKey)
            cell.horizontalGroupCellDelegate.contentText = self.getStringFromUserDefaultsByKey(key: defaultAddressKey)
        } else if !self.consignForm.consignBySelf && indexPath.row == 2 {
            // 非自运，托运终点
            groupText = "托运终点"
            placeholderText = "请选择托运终点"
            horizontalGroupType = .picker
            let pickCompletion = { (key: String, text: String) in
                cell.changeContentKeyAndText(contentKey: key, contentText: text)
                // 选中后修改委托中的记录值
                self.consignForm.destinationId = key
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
        } else if !self.consignForm.consignBySelf && indexPath.row == 3 {
            // 非自运，托运人
            groupText = "托运人"
            placeholderText = "请选择托运人"
            horizontalGroupType = .picker
            let pickCompletion = { (key: String, text: String) in
                cell.changeContentKeyAndText(contentKey: key, contentText: text)
                // 选中后修改委托中的记录值
                self.consignForm.consignorId = key
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
        } else if (!self.consignForm.consignBySelf && indexPath.row == 4) || (self.consignForm.consignBySelf && indexPath.row == 0) {
            // 负责人
            groupText = "负责人"
            placeholderText = "请选择负责人"
            horizontalGroupType = .picker
            let pickCompletion = { (key: String, text: String) in
                cell.changeContentKeyAndText(contentKey: key, contentText: text)
                // 选中后修改委托中的记录值
                self.consignForm.chargerId = key
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
