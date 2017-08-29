//
//  VCConsignPending.swift
//  buycar.yuandian
//
//  Created by 李萌 on 2017/8/22.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit
import MJRefresh

private let pendingCell = "pendingCell"

class VCConsignPendingList: UIViewController {
    
    let cplTable = UITableView()
    let refreshHeader = MJRefreshNormalHeader()
    let refreshFooter = MJRefreshAutoNormalFooter()
    var lastRefreshTime = Date()
    var total = 0
    var pageNo = 0
    let pageSize = 15
    var cps = [Consign]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        initView()
        self.cplTable.mj_header.beginRefreshing()
        
        //发送一个名字为currentPageChanged，附带object的值代表当前页面的索引
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentPageChanged"), object: 0)
    }
    
    private func initView() {
        // 为TableView添加刷新控件
        self.refreshHeader.setRefreshingTarget(self, refreshingAction: #selector(VCConsignPendingList.headerRefresh))
        self.refreshHeader.setTitle("下拉刷新数据", for: .idle)
        self.refreshHeader.setTitle("松开刷新数据", for: .pulling)
        self.refreshHeader.setTitle("正在刷新数据...", for: .refreshing)
        self.refreshHeader.lastUpdatedTimeLabel.isHidden = true
        self.cplTable.mj_header = refreshHeader
        self.refreshFooter.setRefreshingTarget(self, refreshingAction: #selector(VCConsignPendingList.footerRefresh))
        self.refreshFooter.setTitle("上拉加载更多", for: .idle)
        self.refreshFooter.setTitle("加载中...", for: .refreshing)
        self.refreshFooter.setTitle("没有更多数据了", for: .noMoreData)
        self.refreshFooter.stateLabel.isHidden = true
        self.cplTable.mj_footer = refreshFooter
        
        // 取消所有多余分隔线
        self.cplTable.tableFooterView = UIView()
        self.view.addSubview(self.cplTable)
        
        self.cplTable.delegate = self
        self.cplTable.register(UINib(nibName: "ConsignPendingCell", bundle: nil), forCellReuseIdentifier: pendingCell)
        
        self.cplTable.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tv]|", options: [], metrics: nil, views: ["tv": self.cplTable]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tv]|", options: [], metrics: nil, views: ["tv": self.cplTable]))
    }
    
    private func launchData(completion: (() -> Swift.Void)? = nil) {
        // 设置待托运数据
        let cps = Consign()
        cps.getConsignPendingList(pageNo: self.pageNo, pageSize: self.pageSize, lastRefreshDate: self.lastRefreshTime) { (status: ReturnedStatus, msg: String?, total: Int?, cps: [Consign]?) in
            switch status {
            case .normal:
                self.cplTable.dataSource = self
                // 设置cell的分隔线，以便其可以顶头开始
                self.cplTable.layoutMargins = UIEdgeInsets.zero
                self.cplTable.separatorInset = UIEdgeInsets.zero
                self.cplTable.separatorColor = separatorLineColor
                
                self.total = total!
                self.cps.append(contentsOf: cps!)
                
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
    
    /// 下拉刷新数据
    func headerRefresh() {
        self.pageNo = 1
        self.cps.removeAll()
        self.lastRefreshTime = Date()
        self.launchData(completion: {
            self.cplTable.reloadData()
            self.cplTable.mj_header.endRefreshing()
            if self.total > self.pageNo * self.pageSize {
                self.refreshFooter.stateLabel.isHidden = false
                self.cplTable.mj_footer.endRefreshing()
            }
        })
    }
    
    /// 上拉加载更多数据
    func footerRefresh() {
        self.pageNo += 1
        self.launchData(completion: {
            self.cplTable.reloadData()
            if self.total > self.pageNo * self.pageSize {
                self.cplTable.mj_footer.endRefreshing()
            } else {
                self.cplTable.mj_footer.endRefreshingWithNoMoreData()
            }
        })
    }
    
    /// 托运按钮点击事件
    ///
    /// - Parameter carId: <#carId description#>
    func doConsign(sender : UIButton) {
        let tvc = sender.superView(of: TVCConsignPendingCell.self)!
        self.presentConsignWayAction(tvc.consignPendingCellDelegate.carId)
    }
    
    /// 弹出托运方式选择框
    ///
    /// - Parameter present: <#present description#>
    func presentConsignWayAction(_ carId: String!) {
        let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        action.addAction(UIAlertAction(title: "托运", style: .default) {_ in
            // 托运处理
            self.pushViewControllerFromStoryboard(storyboardName: "Main", idInStoryboard: "vcConsign", animated: true, completion: {(vc: UIViewController) -> Void in
                let consign = vc as! VCConsign
                consign.consignDelegate.carId = carId
                consign.consignDelegate.consignBySelf = false
                consign.consignDelegate.title = "托运"
            })
            self.configNavigationBackItem(sourceViewController: self)
        })
        action.addAction(UIAlertAction(title: "自运", style: .default) {_ in
            // 自运处理
            self.pushViewControllerFromStoryboard(storyboardName: "Main", idInStoryboard: "vcConsign", animated: true, completion: {(vc: UIViewController) -> Void in
                let consign = vc as! VCConsign
                consign.consignDelegate.carId = carId
                consign.consignDelegate.consignBySelf = true
                consign.consignDelegate.title = "自运"
            })
            self.configNavigationBackItem(sourceViewController: self)
        })
        action.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(action, animated: true, completion: nil)
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
        cell.consignPendingCellDelegate.carLisenceNo = self.cps[indexPath.row].carLicenseNo + "\(indexPath.row)"
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
