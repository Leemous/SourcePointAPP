//
//  VCConsignDetail.swift
//  托运详情页面
//
//  Created by 李萌 on 2017/8/24.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

private let horizontalGroupCell = "horizontalGroupCell"

class VCConsignDetail: UIViewController {
    var detailTable: UITableView!
    var remarkView: UIView!
    
    var tableCellCount = 0
    var consignDetailDelegate = ConsignDetailDelegate()
    var consign = Consign()
    
    var remarkLabel: UILabel!
    var remarkText: TextViewWithFinishButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        consignDetailDelegate.title = "44"
        consignDetailDelegate.consignBySelf = false
        consignDetailDelegate.id = "bd08ba855e095518015e0a503ed200a9"
        // 守卫代码，保证页面正常绘制不闪退
        guard consignDetailDelegate.title != nil && consignDetailDelegate.consignBySelf != nil && consignDetailDelegate.id != nil else {
            return
        }
        
        self.configTitleLabelByText(title: consignDetailDelegate.title)
        
        if consignDetailDelegate.consignBySelf {
            tableCellCount = 2
        } else {
            tableCellCount = 6
        }
        
        initView()
        launchData()
    }
    
    private func initView() {
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
        self.remarkText.isEditable = false
        self.remarkText.isSelectable = false
        self.remarkText.textAlignment = .left
        self.remarkText.backgroundColor = lightBackgroundColor
        self.remarkText.font = textFont
        self.remarkText.textColor = mainTextColor
        self.remarkText.translatesAutoresizingMaskIntoConstraints = false
        self.remarkView.addConstraint(NSLayoutConstraint(item: remarkText, attribute: .leading, relatedBy: .equal, toItem: self.remarkView, attribute: .leading, multiplier: 1, constant: 12))
        self.remarkView.addConstraint(NSLayoutConstraint(item: remarkText, attribute: .trailing, relatedBy: .equal, toItem: self.remarkView, attribute: .trailing, multiplier: 1, constant: -12))
        self.remarkView.addConstraint(NSLayoutConstraint(item: remarkText, attribute: .top, relatedBy: .equal, toItem: self.remarkLabel, attribute: .bottom, multiplier: 1, constant: 8))
        self.remarkView.addConstraint(NSLayoutConstraint(item: remarkText, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 118))
    }
    
    func launchData(completion: (() -> Swift.Void)? = nil) {
        // 加载数据
        consign.getConsign(id: consignDetailDelegate.id) { (status: ReturnedStatus, msg: String?, consign: Consign?) in
            switch status {
            case .normal:
                self.consign = consign!
                
                self.detailTable.reloadData()
                self.remarkText.text = self.consign.remark
                
                if let c = completion {
                    c()
                }
                
                // 如果之前存在无数据、无网络连接等问题，则先移除这些view
                self.removeNoConnectView(containerView: self.view)
            case .needLogin:
                self.needsLogout()
            case .noConnection:
                self.showNoConnectionView(containerView: self.view) { _ in
                    self.launchData()
                }
            default:
                break
            }
        }
    }
}

class ConsignDetailDelegate {
    var title: String!
    var id: String!
    var consignBySelf: Bool!
}

extension VCConsignDetail: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableCellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var groupText:String!
        var contentText:String!
        if self.consignDetailDelegate.consignBySelf {
            // 自运，只有负责人和托运日期
            switch indexPath.row {
            case 0:
                groupText = "负责人"
                contentText = self.consign.charger
                break
            case 1:
                groupText = "托运时间"
                contentText = self.consign.consignDate
                break
            default:
                groupText = ""
                contentText = ""
                break
            }
        } else {
            // 托运
            switch indexPath.row {
            case 0:
                groupText = "托运起点"
                contentText = self.consign.placeOfOrigin
                break
            case 1:
                groupText = "起运详址"
                contentText = self.consign.address
                break
            case 2:
                groupText = "托运终点"
                contentText = self.consign.destination
                break
            case 3:
                groupText = "托运人"
                contentText = self.consign.consignor
                break
            case 4:
                groupText = "负责人"
                contentText = self.consign.charger
                break
            case 5:
                groupText = "托运时间"
                contentText = self.consign.consignDate
                break
            default:
                groupText = ""
                contentText = ""
                break
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: horizontalGroupCell, for: indexPath) as! TVCHorizontalGroupCell
        cell.horizontalGroupCellDelegate.groupText = groupText
        cell.selectionStyle = .none
        
        if cell.tag == 4000 {
            cell.groupLabel.text = groupText
            cell.changeContentText(contentText)
        }
        return cell
    }
}

extension VCConsignDetail: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

