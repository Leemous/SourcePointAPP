//
//  VCConsignHistoryList.swift
//  buycar.yuandian
//
//  Created by 李萌 on 2017/8/24.
//  Copyright © 2017年 tymaker. All rights reserved.
//
import UIKit
import MJRefresh

private let historyCell = "pendingCell"

class VCConsignHistoryList: UIViewController {
    
    let chlTable = UITableView()
    let refreshHeader = MJRefreshNormalHeader()
    let refreshFooter = MJRefreshAutoNormalFooter()
    var lastRefreshTime = Date()
    var total = 0
    var pageNo = 1
    let pageSize = 15
    var cps = [Consign]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        initView()
        self.chlTable.mj_header.beginRefreshing()
        
        //发送一个名字为currentPageChanged，附带object的值代表当前页面的索引
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentPageChanged"), object: 1)
    }
    
    private func initView() {
        // 为TableView添加刷新控件
        self.refreshHeader.setRefreshingTarget(self, refreshingAction: #selector(VCConsignPendingList.headerRefresh))
        self.refreshHeader.setTitle("下拉刷新数据", for: .idle)
        self.refreshHeader.setTitle("松开刷新数据", for: .pulling)
        self.refreshHeader.setTitle("正在刷新数据...", for: .refreshing)
        self.refreshHeader.lastUpdatedTimeLabel.isHidden = true
        self.chlTable.mj_header = refreshHeader
        self.refreshFooter.setRefreshingTarget(self, refreshingAction: #selector(VCConsignPendingList.footerRefresh))
        self.refreshFooter.setTitle("上拉加载更多", for: .idle)
        self.refreshFooter.setTitle("加载中...", for: .refreshing)
        self.refreshFooter.setTitle("没有更多数据了", for: .noMoreData)
        self.refreshFooter.stateLabel.isHidden = true
        self.chlTable.mj_footer = refreshFooter
        
        // 取消所有多余分隔线
        self.chlTable.tableFooterView = UIView()
        self.view.addSubview(self.chlTable)
        
        self.chlTable.delegate = self
        self.chlTable.register(UINib(nibName: "ConsignHistoryCell", bundle: nil), forCellReuseIdentifier: historyCell)
        
        self.chlTable.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tv]|", options: [], metrics: nil, views: ["tv": self.chlTable]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tv]|", options: [], metrics: nil, views: ["tv": self.chlTable]))
    }
    
    private func launchData(completion: (() -> Swift.Void)? = nil) {
        // 设置已托运数据
        let cps = Consign()
        cps.getConsignHistoryList(pageNo: self.pageNo, pageSize: self.pageSize, lastRefreshDate: self.lastRefreshTime) { (status: ReturnedStatus, msg: String?, total: Int?, cps: [Consign]?) in
            switch status {
            case .normal:
                self.chlTable.dataSource = self
                // 设置cell的分隔线，以便其可以顶头开始
                self.chlTable.layoutMargins = UIEdgeInsets.zero
                self.chlTable.separatorInset = UIEdgeInsets.zero
                self.chlTable.separatorColor = separatorLineColor
                
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
            self.chlTable.reloadData()
            self.chlTable.mj_header.endRefreshing()
            if self.total > self.pageNo * self.pageSize {
                // 下拉刷新数据时，如果总数大于一页的内容，则展示底部状态
                self.refreshFooter.stateLabel.isHidden = false
                self.chlTable.mj_footer.endRefreshing()
            } else {
                self.chlTable.mj_footer.endRefreshingWithNoMoreData()
            }
        })
    }
    
    /// 上拉加载更多数据
    func footerRefresh() {
        self.pageNo += 1
        self.launchData(completion: {
            self.chlTable.reloadData()
            if self.total > self.pageNo * self.pageSize {
                self.chlTable.mj_footer.endRefreshing()
            } else {
                self.chlTable.mj_footer.endRefreshingWithNoMoreData()
            }
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
        self.pushViewControllerFromStoryboard(storyboardName: "Main", idInStoryboard: "vcConsignDetail", animated: true, completion: {(vc: UIViewController) -> Void in
            let consignDetail = vc as! VCConsignDetail
            
            consignDetail.consignDetailDelegate.title = cell.consignHistoryCellDelegate.carLisenceNo
            consignDetail.consignDetailDelegate.consignBySelf = cell.consignHistoryCellDelegate.consignBySelf
            consignDetail.consignDetailDelegate.id = cell.consignHistoryCellDelegate.id
        })
        self.configNavigationBackItem(sourceViewController: self)
    }
}

