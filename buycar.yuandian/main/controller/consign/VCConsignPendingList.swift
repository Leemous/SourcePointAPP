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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectedAllButton: UIButton!
    @IBOutlet weak var batchConsignButton: UIButton!
    @IBOutlet weak var batchSelfConsignButton: UIButton!
    
    let refreshHeader = MJRefreshNormalHeader()
    let refreshFooter = MJRefreshAutoNormalFooter()
    var lastRefreshTime = Date()
    var total = 0
    var pageNo = 0
    let pageSize = 15
    
    lazy var cs = [Consign]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        
        self.tableView.mj_header.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        self.tableView.mj_header = self.refreshHeader
        self.refreshFooter.setRefreshingTarget(self, refreshingAction: #selector(VCConsignPendingList.footerRefresh))
        self.refreshFooter.setTitle("上拉加载更多", for: .idle)
        self.refreshFooter.setTitle("加载中...", for: .refreshing)
        self.refreshFooter.setTitle("没有更多数据了", for: .noMoreData)
        self.refreshFooter.stateLabel.isHidden = true
        self.tableView.mj_footer = self.refreshFooter
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // 设置cell的分隔线，以便其可以顶头开始
        self.tableView.layoutMargins = UIEdgeInsets.zero
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.separatorColor = separatorLineColor
        
        // 取消所有多余分隔线
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "ConsignPendingCell", bundle: nil), forCellReuseIdentifier: pendingCell)
    }
    
    private func launchData(completion: (() -> Swift.Void)? = nil) {
        // 设置待托运数据
        let cps = Consign()
        cps.getConsignPendingList(pageNo: self.pageNo, pageSize: self.pageSize, lastRefreshDate: self.lastRefreshTime) { (status: ReturnedStatus, msg: String?, total: Int?, cs: [Consign]?) in
            switch status {
            case .normal:
                
                self.total = total!
                self.cs.append(contentsOf: cs!)
                
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
        self.cs.removeAll()
        self.lastRefreshTime = Date()
        self.launchData(completion: {
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            if self.total > self.pageNo * self.pageSize {
                self.refreshFooter.stateLabel.isHidden = false
                self.tableView.mj_footer.endRefreshing()
            } else {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
        })
    }
    
    /// 上拉加载更多数据
    func footerRefresh() {
        self.pageNo += 1
        self.launchData(completion: {
            self.tableView.reloadData()
            if self.total > self.pageNo * self.pageSize {
                self.tableView.mj_footer.endRefreshing()
            } else {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
        })
    }
    
    /// 弹出托运方式选择框
    ///
    /// - Parameter consign: 托运信息
    func presentConsignWayAction(_ consign: Consign) {
        let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        action.addAction(UIAlertAction(title: "托运", style: .default) {_ in
            // 托运处理
            self.doConsign(cs: [consign])
        })
        action.addAction(UIAlertAction(title: "自运", style: .default) {_ in
            // 自运处理
            self.doConsign(cs: [consign], isConsignBySelf: true)
        })
        action.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(action, animated: true, completion: nil)
    }
    
    /// 用于从托运界面返回
    ///
    /// - Parameter seg: <#seg description#>
    @IBAction func backToConsignPendingList(_ seg: UIStoryboardSegue!) {
        self.tableView.mj_header.beginRefreshing()
    }
    
    @IBAction func didClickedSelectedAllButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        changeSelectedAll(isSelected: sender.isSelected)
    }
    
    @IBAction func didClickedBatchConsignButton(_ sender: Any) {
        let selectedConsigns = self.getSelected()
        if (selectedConsigns.count == 0) {
            self.alert(viewToBlock: self.batchConsignButton, msg: "未选择任何记录")
        } else {
            self.doConsign(cs: selectedConsigns)
        }
    }
    
    @IBAction func didClickedBatchSelfConsignButton(_ sender: Any) {
        let selectedConsigns = self.getSelected()
        if (selectedConsigns.count == 0) {
            self.alert(viewToBlock: self.batchConsignButton, msg: "未选择任何记录")
        } else {
            self.doConsign(cs: selectedConsigns, isConsignBySelf: true)
        }
    }
    
    private func getSelected() -> [Consign] {
        var selectedConsigns = [Consign]()
        for model in self.cs {
            if model.isSelected == true {
                selectedConsigns.append(model)
            }
        }
        return selectedConsigns
    }
    
    private func doConsign(cs: [Consign], isConsignBySelf: Bool = false) {
        self.pushViewControllerFromStoryboard(storyboardName: "Main", idInStoryboard: "vcConsign", animated: true, completion: {(vc: UIViewController) -> Void in
            let vcConsign = vc as! VCConsign
            vcConsign.consigns = cs
            vcConsign.consignForm.consignBySelf = isConsignBySelf
        })
        self.configNavigationBackItem(sourceViewController: self)
    }
    
    private func changeSelectedAll(isSelected: Bool) {
        var temp: [Consign] = []
        for model in self.cs {
            model.isSelected = isSelected
            temp.append(model)
        }
        self.cs = temp
        self.tableView.reloadData()
    }
    
    func checkSelectAll() {
        var isSelectedAll = true
        for model in self.cs {
            isSelectedAll = isSelectedAll && (model.isSelected == true)
        }
        self.selectedAllButton.isSelected = isSelectedAll
    }
}

extension VCConsignPendingList: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: pendingCell, for: indexPath) as! TVCConsignPendingCell
        cell.selectionStyle = .none
        
        let consign = self.cs[indexPath.row]
        
        cell.configure(model: ConsignPendingCellModel(consign.carId, consign.carLicenseNo, consign.carFrameNo, consign.isSelected))
        
        cell.selectedAction = { [weak self] (isSelected) in
            let newModel = consign
            newModel.isSelected = isSelected
            self?.cs[indexPath.row] = newModel
            // 检查是否全选
            self?.checkSelectAll()
            self?.tableView.reloadData()
        }
        
        cell.consignAction = { [weak self] in
            self?.presentConsignWayAction(consign)
        }
        
        return cell
    }
}

extension VCConsignPendingList: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
