//
//  VCDailyList.swift
//
//  显示日报列表的view controller，对应storyboard是Main
//
//  Created by 姬鹏 on 2017/3/22.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit
import MJRefresh

private let dailyCell = "dailyCell"

class VCDailyList: UIViewController {
    
    let dlTable = UITableView()
    let refreshHeader = MJRefreshNormalHeader()
    let refreshFooter = MJRefreshAutoNormalFooter()
    var lastRefreshTime = Date()
    var total = 0
    var pageNo = 0
    let pageSize = 15
    var ds = [Daily]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false

        self.configTitleLabelByText(title: "日报")
        
        initView()
        self.dlTable.mj_header.beginRefreshing()
    }
    
    private func initView() {
        // 设置右上角的barButtonItem
        let addDailyButton = UIBarButtonItem(image: UIImage(named: "addDailyImage"), style: .plain, target: self, action: #selector(VCDailyList.addDaily(_:)))
        
        self.navigationItem.rightBarButtonItem = addDailyButton
        self.navigationItem.rightBarButtonItem!.imageInsets = UIEdgeInsetsMake(3, 0, 0, 0)
        
        // 为TableView添加刷新控件
        self.refreshHeader.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        self.refreshHeader.setTitle("下拉刷新数据", for: .idle)
        self.refreshHeader.setTitle("松开刷新数据", for: .pulling)
        self.refreshHeader.setTitle("正在刷新数据...", for: .refreshing)
        self.refreshHeader.lastUpdatedTimeLabel.isHidden = true
        self.dlTable.mj_header = self.refreshHeader
        self.refreshFooter.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        self.refreshFooter.setTitle("上拉加载更多", for: .idle)
        self.refreshFooter.setTitle("加载中...", for: .refreshing)
        self.refreshFooter.setTitle("没有更多数据了", for: .noMoreData)
        self.refreshFooter.stateLabel.isHidden = true
        self.dlTable.mj_footer = self.refreshFooter
        
        // 取消所有多余分隔线
        self.dlTable.tableFooterView = UIView()
        self.view.addSubview(self.dlTable)
        
        self.dlTable.delegate = self
        self.dlTable.register(UITableViewCell.self, forCellReuseIdentifier: dailyCell)
        
        self.dlTable.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tv]|", options: [], metrics: nil, views: ["tv": self.dlTable]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tv]|", options: [], metrics: nil, views: ["tv": self.dlTable]))        
    }

    private func launchData(completion: (() -> Swift.Void)? = nil) {
        // 设置日报数据
        let d = Daily()
        d.getDailyList(pageNo: self.pageNo, pageSize: self.pageSize, lastRefreshDate: self.lastRefreshTime) { (status: ReturnedStatus, msg: String?, ds: [Daily]?) in
            switch status {
            case .normal:
                self.dlTable.dataSource = self
                // 设置cell的分隔线，以便其可以顶头开始
                self.dlTable.layoutMargins = UIEdgeInsets.zero
                self.dlTable.separatorInset = UIEdgeInsets.zero
                self.dlTable.separatorColor = separatorLineColor
                
                self.ds = ds!
                
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
        self.ds.removeAll()
        self.lastRefreshTime = Date()
        self.launchData(completion: {
            self.dlTable.reloadData()
            self.dlTable.mj_header.endRefreshing()
            if self.total > self.pageNo * self.pageSize {
                self.refreshFooter.stateLabel.isHidden = false
                self.dlTable.mj_footer.endRefreshing()
            } else {
                self.dlTable.mj_footer.endRefreshingWithNoMoreData()
            }
        })
    }
    
    /// 上拉加载更多数据
    func footerRefresh() {
        self.pageNo += 1
        self.launchData(completion: {
            self.dlTable.reloadData()
            if self.total > self.pageNo * self.pageSize {
                self.dlTable.mj_footer.endRefreshing()
            } else {
                self.dlTable.mj_footer.endRefreshingWithNoMoreData()
            }
        })
    }
    
    /// 添加日报
    ///
    /// - Parameter sender: <#sender description#>
    func addDaily(_ sender: AnyObject) {
        self.pushViewControllerFromStoryboard(storyboardName: "Main", idInStoryboard: "vcAddDaily", animated: true, completion: nil)
        self.configNavigationBackItem(sourceViewController: self)
    }
    
    // 用于从添加日报界面返回
    @IBAction func backToDailyList(_ seg: UIStoryboardSegue!) {
        self.launchData(completion: {
            self.dlTable.reloadData()
        })
    }
}

extension VCDailyList: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: dailyCell, for: indexPath)

        cell.selectionStyle = .none
        
        cell.textLabel!.font = textFont
        cell.textLabel!.textColor = mainTextColor
        cell.textLabel!.text = self.ds[indexPath.row].dailyPerson + "于" + self.ds[indexPath.row].dailyTime + ":" + self.ds[indexPath.row].dailyDetail

        return cell
    }
}

extension VCDailyList: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}

























