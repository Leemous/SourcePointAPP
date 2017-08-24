//
//  VCConsignPending.swift
//  buycar.yuandian
//
//  Created by 李萌 on 2017/8/22.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

private let pendingCell = "pendingCell"

class VCConsignPendingList: UIViewController {
    
    let cplTable = UITableView()
    var cps = [Consign]()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.configTitleLabelByText(title: "待托运")
        
        launchData()
        
        refreshControl.addTarget(self, action: #selector(VCConsignPendingList.refreshData), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        self.cplTable.addSubview(refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func launchData(completion: (() -> Swift.Void)? = nil) {
        // 设置日报数据
        let cps = Consign()
        cps.getConsignPendingList { (status: ReturnedStatus, msg: String?, cps: [Consign]?) in
            switch status {
            case .normal:
                self.view.addSubview(self.cplTable)
                
                self.cplTable.translatesAutoresizingMaskIntoConstraints = false
                self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tv]|", options: [], metrics: nil, views: ["tv": self.cplTable]))
                self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tv]|", options: [], metrics: nil, views: ["tv": self.cplTable]))
                
                self.cplTable.dataSource = self
                self.cplTable.delegate = self
                
                // 取消所有多余分隔线
                self.cplTable.tableFooterView = UIView()
                
                // 设置cell的分隔线，以便其可以顶头开始
                self.cplTable.layoutMargins = UIEdgeInsets.zero
                self.cplTable.separatorInset = UIEdgeInsets.zero
                self.cplTable.separatorColor = separatorLineColor
                
                self.cplTable.register(UINib(nibName: "ConsignPendingCell", bundle: nil), forCellReuseIdentifier: pendingCell)
                
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
    
    func refreshData() {
        self.launchData(completion: {
            self.cplTable.reloadData()
            self.refreshControl.endRefreshing()
        })
    }
    
    /// 弹出托运方式选择框
    ///
    /// - Parameter present: <#present description#>
    func presentConsignWayAction(_ carId: String!) {
        let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        action.addAction(UIAlertAction(title: "托运", style: .default) {_ in
            // 托运处理
            self.alert(viewToBlock: nil, msg: carId)
        })
        action.addAction(UIAlertAction(title: "自运", style: .default) {_ in
            // 自运处理
            self.alert(viewToBlock: nil, msg: carId)
        })
        action.addAction(UIAlertAction(title: "取消", style: .destructive, handler: nil))
        self.present(action, animated: true, completion: nil)
    }
    
    /// 托运按钮点击事件
    ///
    /// - Parameter carId: <#carId description#>
    func doConsign(sender : UIButton) {
        let tvc = sender.superView(of: TVCConsignPendingCell.self)!
        self.presentConsignWayAction(tvc.consignPendingCellDelegate.carId)
    }
    
    /// 用于从托运界面返回
    ///
    /// - Parameter seg: <#seg description#>
    @IBAction func backToConsignPendingList(_ seg: UIStoryboardSegue!) {
        self.launchData(completion: {
            self.cplTable.reloadData()
        })
    }
}

extension VCConsignPendingList: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: pendingCell, for: indexPath) as! TVCConsignPendingCell
        
        cell.consignPendingCellDelegate.carId = self.cps[indexPath.row].carId
        cell.consignPendingCellDelegate.carLisenceNo = self.cps[indexPath.row].carLicenseNo
        cell.consignPendingCellDelegate.carFrameNo = self.cps[indexPath.row].carFrameNo
        
        if cell.tag != 2000 {
            // 首次绘制单元格
            cell.selectionStyle = .none
        } else {
            // 重用单元格，手动设置label值
            cell.licenseLabel.text = self.cps[indexPath.row].carLicenseNo
            cell.frameLabel.text = self.cps[indexPath.row].carFrameNo
        }
        
        // 托运按钮点击，同一类型事件只能存在一个，重用cell指定事件时会覆盖原有事件
        cell.consignButton.addTarget(self, action: #selector(VCConsignPendingList.doConsign(sender:)), for: .touchUpInside)
        
        return cell
    }
}

extension VCConsignPendingList: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
