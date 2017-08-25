//
//  VCConsignHistoryList.swift
//  buycar.yuandian
//
//  Created by 李萌 on 2017/8/24.
//  Copyright © 2017年 tymaker. All rights reserved.
//
import UIKit

private let historyCell = "pendingCell"

class VCConsignHistoryList: UIViewController {
    
    let chlTable = UITableView()
    var cps = [Consign]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.configTitleLabelByText(title: "已托运")
        
        launchData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func launchData(completion: (() -> Swift.Void)? = nil) {
        // 设置已托运数据
        let cps = Consign()
        cps.getConsignHistoryList(pageNo: 1, pageSize: 99) { (status: ReturnedStatus, msg: String?, cps: [Consign]?) in
            switch status {
            case .normal:
                self.view.addSubview(self.chlTable)
                
                self.chlTable.translatesAutoresizingMaskIntoConstraints = false
                self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tv]|", options: [], metrics: nil, views: ["tv": self.chlTable]))
                self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tv]|", options: [], metrics: nil, views: ["tv": self.chlTable]))
                
                self.chlTable.dataSource = self
                self.chlTable.delegate = self
                
                // 取消所有多余分隔线
                self.chlTable.tableFooterView = UIView()
                
                // 设置cell的分隔线，以便其可以顶头开始
                self.chlTable.layoutMargins = UIEdgeInsets.zero
                self.chlTable.separatorInset = UIEdgeInsets.zero
                self.chlTable.separatorColor = separatorLineColor
                
                self.chlTable.register(UINib(nibName: "ConsignHistoryCell", bundle: nil), forCellReuseIdentifier: historyCell)
                
                self.cps = cps!
                
                if let c = completion {
                    c()
                }
                
                // 如果之前存在无数据、无网络连接等问题，则先移除这些view
                self.removeNoConnectView(containerView: self.view)
                self.removeNoDataView(containerView: self.view)
            case .noData:
                self.showNoDataView(containerView: self.view)
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
    
    /// 用于从托运单详情返回
    ///
    /// - Parameter seg: <#seg description#>
    @IBAction func backToConsignHistoryList(_ seg: UIStoryboardSegue!) {
        self.launchData(completion: {
            self.chlTable.reloadData()
        })
    }
}

extension VCConsignHistoryList: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: historyCell, for: indexPath) as! TVCConsignHistoryCell
        
        cell.consignHistoryCellDelegate.id = self.cps[indexPath.row].id
        cell.consignHistoryCellDelegate.consignBySelf = self.cps[indexPath.row].consignBySelf
        cell.consignHistoryCellDelegate.carLisenceNo = self.cps[indexPath.row].carLicenseNo
        cell.consignHistoryCellDelegate.carFrameNo = self.cps[indexPath.row].carFrameNo
        
        if cell.tag == 3000 {
            // 重用单元格，手动设置label值
            cell.licenseLabel.text = self.cps[indexPath.row].carLicenseNo
            cell.frameLabel.text = self.cps[indexPath.row].carFrameNo
        }
        
        return cell
    }
}

extension VCConsignHistoryList: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TVCConsignHistoryCell
        alert(viewToBlock: nil, msg: cell.consignHistoryCellDelegate.id)
    }
}

